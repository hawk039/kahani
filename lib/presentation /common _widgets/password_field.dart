import 'package:flutter/material.dart';
import '../../core/utils/theme.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final VoidCallback? onForgotPassword; // <-- added callback

  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.errorText,
    this.onForgotPassword,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label + Forgot Password (same line)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: AppTheme.label,
            ),
            if (widget.onForgotPassword != null)
              GestureDetector(
                onTap: widget.onForgotPassword,
                child: Text(
                  "Forgot Password?",
                  style: AppTheme.label.copyWith(
                    fontSize: 12,
                    color: AppTheme.secondary,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // 🔹 Password TextField
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          style: AppTheme.input,
          decoration: InputDecoration(
            hintText: widget.label == 'Password'
                ? 'Enter your password'
                : 'Confirm your password',
            hintStyle: TextStyle(color: AppTheme.textMutedLight),

            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: AppTheme.surfaceLight,

            errorText: widget.errorText,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.secondary),
            ),

            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.textMutedDark,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
      ],
    );
  }
}
