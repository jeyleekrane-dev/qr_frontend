import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'teacher_service.dart';

class LiveMonitorList extends ConsumerStatefulWidget {
  final String sessionId;
  const LiveMonitorList({super.key, required this.sessionId});

  @override
  ConsumerState<LiveMonitorList> createState() => _LiveMonitorListState();
}

class _LiveMonitorListState extends ConsumerState<LiveMonitorList> {
  // Lists for data management
  List<dynamic> _attendees = [];
  List<dynamic> _searchResults = [];
  
  // State for search logic
  bool _isSearching = false;
  bool _isLoadingSearch = false;
  final _searchController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchAttendees();
    // Refresh the "Present" list every 5 seconds, but only if not searching
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isSearching) _fetchAttendees();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Fetch only students who have successfully scanned
  Future<void> _fetchAttendees() async {
    try {
      final list = await ref.read(teacherServiceProvider).getSessionAttendees(widget.sessionId);
      if (mounted) {
        setState(() => _attendees = list);
      }
    } catch (e) {
      debugPrint("Analytics fetch failed: $e");
    }
  }

  // Search the entire student database (for those who can't scan)
  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoadingSearch = true;
    });

    try {
      final results = await ref.read(teacherServiceProvider).searchStudents(query);
      setState(() {
        _searchResults = results;
        _isLoadingSearch = false;
      });
    } catch (e) {
      setState(() => _isLoadingSearch = false);
      debugPrint("Search failed: $e");
    }
  }

  // Manually mark a student as present
  Future<void> _manuallyMark(String studentId) async {
    try {
      await ref.read(teacherServiceProvider).markManually(widget.sessionId, studentId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student marked present!"), backgroundColor: Colors.green),
      );
      
      // Reset search and refresh list
      _searchController.clear();
      setState(() => _isSearching = false);
      _fetchAttendees();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to mark: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Modern Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _handleSearch,
            decoration: InputDecoration(
              hintText: "Search student (Battery/Network issue)...",
              prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
              suffixIcon: _isSearching 
                ? IconButton(
                    icon: const Icon(Icons.close), 
                    onPressed: () {
                      _searchController.clear();
                      _handleSearch("");
                    }) 
                : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // 2. Section Header (only shows if not searching)
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Live Attendees",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text("${_attendees.length} Present"),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

        // 3. Main Content Area
        Expanded(
          child: _isSearching 
            ? _buildSearchResults() 
            : _buildLiveAttendeesList(),
        ),
      ],
    );
  }

  // View for normal live updates
  Widget _buildLiveAttendeesList() {
    if (_attendees.isEmpty) {
      return const Center(child: Text("Waiting for students to scan..."));
    }
    return ListView.separated(
      itemCount: _attendees.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final student = _attendees[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(student['first_name'][0], style: const TextStyle(color: Colors.white)),
          ),
          title: Text("${student['first_name']} ${student['last_name']}"),
          subtitle: Text("Status: ${student['status']}"),
          trailing: const Icon(Icons.check_circle, color: Colors.green),
        );
      },
    );
  }

  // View for manual search results
  Widget _buildSearchResults() {
    if (_isLoadingSearch) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchResults.isEmpty) {
      return const Center(child: Text("No students found."));
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final student = _searchResults[index];
        // Check if student is already in the present list
        bool isAlreadyPresent = _attendees.any((a) => a['id'] == student['id']);

        return ListTile(
          title: Text("${student['first_name']} ${student['last_name']}"),
          subtitle: Text(student['student_id'] ?? "No ID available"),
          trailing: isAlreadyPresent
              ? const Icon(Icons.check_circle, color: Colors.green)
              : ElevatedButton(
                  onPressed: () => _manuallyMark(student['id'].toString()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade100,
                    foregroundColor: Colors.orange.shade900,
                    elevation: 0,
                  ),
                  child: const Text("Mark Manually"),
                ),
        );
      },
    );
  }
}