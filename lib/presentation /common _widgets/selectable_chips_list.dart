import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/utils/theme.dart';
import '../home/home_view_model.dart';

// --- FIX: Added the missing enum definition ---
enum ChipType { genre, tone, language }

class SelectableChipList extends StatelessWidget {
  final List<String> options;
  final ChipType chipType;

  const SelectableChipList({super.key, required this.options, required this.chipType});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    String? selectedValue;
    Function(String?) onSelected;

    switch (chipType) {
      case ChipType.genre:
        selectedValue = homeProvider.selectedGenre;
        onSelected = homeProvider.setSelectedGenre;
        break;
      case ChipType.tone:
        selectedValue = homeProvider.selectedTone;
        onSelected = homeProvider.setSelectedTone;
        break;
      case ChipType.language:
        selectedValue = homeProvider.selectedLanguage;
        onSelected = homeProvider.setSelectedLanguage;
        break;
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            onSelected(selected ? option : null);
          },
          backgroundColor: AppTheme.borderDarker,
          selectedColor: AppTheme.secondary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMutedLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: isSelected ? AppTheme.secondary : AppTheme.borderDarker,
              width: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}
