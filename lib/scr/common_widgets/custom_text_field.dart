// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class CustomTextField extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool isPassword;
//   final TextEditingController controller;
//   final String? hintText;
//
//
//   const CustomTextField({
//     super.key,
//     required this.label,
//     required this.icon,
//     required this.controller,
//     this.isPassword = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.inter(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.black54,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: isPassword,
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? hintText; // 👈 Kept optional
  final String? Function(String?)? validator; // 👈 Added optional validator
  final String? labelText;
  final String? keyboardType;
  final Icon? prefixIcon;


  const CustomTextField({
    super.key,
     this.label,
     this.icon,
    required this.controller,
    this.isPassword = false,
    this.hintText, // 👈 Added to constructor (Not required)
    this.validator,
    this.labelText,
    this.prefixIcon, this.keyboardType, // 👈 Added to constructor (Not required)
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        // 1. Swapped TextField to TextFormField to natively support validation
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator, // 👈 Passed down (If null, validation is skipped)
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
            hintText: hintText, // 👈 Connected here!
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,

            // Modern Border Configuration
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
            ),

            // Added Error borders so validation errors render beautifully
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}