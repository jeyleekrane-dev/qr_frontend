import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final String? labelText;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    this.label,
    this.icon,
    required this.controller,
    this.isPassword = false,
    this.hintText,
    this.validator,
    this.labelText,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only render label if provided — prevents null-dereference crash
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon ??
                (icon != null
                    ? Icon(icon, color: Colors.blueAccent, size: 20)
                    : null),
            hintText: hintText,
            labelText: labelText,
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
              borderSide:
                  const BorderSide(color: Colors.blueAccent, width: 1.5),
            ),

            // Error borders
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}