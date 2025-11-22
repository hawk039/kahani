import 'package:flutter/material.dart';
import '../../../../core/utils/theme.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const EmailField({
    super.key,
    required this.controller,
    this.label = 'Email Address',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.label,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: AppTheme.input,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.surfaceLight,
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: AppTheme.textMutedLight),

            // No floating label
            floatingLabelBehavior: FloatingLabelBehavior.never,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.secondary),
            ),
          ),
        ),
      ],
    );
  }
}
