import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final String? error;

  const MyTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hintText != null)
          Text(
            hintText!,
            style: TextStyle(
              color: Get.theme.primaryColor.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (hintText != null) SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Get.theme.primaryColorLight,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Get.theme.primaryColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(6),
            ),
            errorText: error,
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(6),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(6),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            isDense: true,
          ),
          cursorColor: Get.theme.primaryColor,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
