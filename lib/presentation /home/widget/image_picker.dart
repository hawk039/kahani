import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kahani_app/core/utils/theme.dart';

class HorizontalImagePicker extends StatelessWidget {
  final List<String> sampleImages;
  final Uint8List? selectedImageBytes;
  final String? selectedSampleUrl;
  final VoidCallback onUploadTap;
  final Function(String url) onSampleSelected;

  const HorizontalImagePicker({
    super.key,
    required this.sampleImages,
    required this.onUploadTap,
    required this.onSampleSelected,
    this.selectedImageBytes,
    this.selectedSampleUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose an Image",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: sampleImages.length + 1, // +1 for upload card
            itemBuilder: (context, index) {
              if (index == 0) {
                // Upload Button Card
                return GestureDetector(
                  onTap: onUploadTap,
                  child:
                  Container(
                    width: 100,
                    height: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      color: AppTheme.borderDarker,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined, size: 32),
                        SizedBox(height: 6),
                        Text("Upload", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }

              // Sample Image Cards
              final imgUrl = sampleImages[index - 1];
              final isSelected = imgUrl == selectedSampleUrl;

              return GestureDetector(
                onTap: () => onSampleSelected(imgUrl),
                child: Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imgUrl),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
