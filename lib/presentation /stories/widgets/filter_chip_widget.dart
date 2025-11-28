import 'package:flutter/material.dart';

import '../../../core/utils/theme.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final IconData? icon;

  const FilterChipWidget({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppTheme.borderDarker,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderDarker),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 16, color: AppTheme.textLight),
          if (icon != null) const SizedBox(width: 4),
          Text(label, style: AppTheme.label),
          const Icon(Icons.expand_more, size: 16, color: AppTheme.textLight),
        ],
      ),
    );
  }
}
