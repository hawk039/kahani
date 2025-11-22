// lib/presentation/common_widgets/social_button.dart
import 'package:flutter/material.dart';
import '../../core/utils/theme.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? leading;
  const SocialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: leading ?? const SizedBox(width: 20, height: 20),
        label: Text(label, style: AppTheme.input.copyWith(fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppTheme.surfaceLight,
          foregroundColor: AppTheme.textLight,
          side: BorderSide(color: AppTheme.borderLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
