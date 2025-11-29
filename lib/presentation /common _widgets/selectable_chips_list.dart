import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kahani_app/core/utils/theme.dart';

import '../home/home_view_model.dart';

enum ChipType { genre, tone }

class SelectableChipList extends StatelessWidget {
  final List<String> options;
  final ChipType chipType;

  const SelectableChipList({
    Key? key,
    required this.options,
    required this.chipType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    String? selectedValue;
    void Function(String?)? updateFunction;

    switch (chipType) {
      case ChipType.genre:
        selectedValue = provider.selectedGenre;
        updateFunction = provider.setSelectedGenre; // updated
        break;
      case ChipType.tone:
        selectedValue = provider.selectedTone;
        updateFunction = provider.setSelectedTone; // updated
        break;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((item) {
        final isActive = selectedValue == item;
        return ChoiceChip(
          label: Text(
            item,
            style: TextStyle(
              color: AppTheme.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isActive,
          onSelected: (_) => updateFunction!(isActive ? null : item),
          backgroundColor: AppTheme.borderDarker,
          selectedColor: AppTheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        );
      }).toList(),
    );
  }
}
