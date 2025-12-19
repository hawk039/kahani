import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../core/utils/theme.dart';

class StoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String words;
  final String imageUrl;
  final Uint8List? imageBytes;

  const StoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.words,
    required this.imageUrl,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (imageBytes != null) {
      imageProvider = MemoryImage(imageBytes!);
    } else {
      imageProvider = NetworkImage(imageUrl);
    }

    return Card(
      color: AppTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image(
              image: imageProvider,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  color: AppTheme.borderDarker,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, color: AppTheme.textMutedDark),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: AppTheme.inputStyle(context)),
                Text(title, style: AppTheme.heading.copyWith(fontSize: 20)),
                const SizedBox(height: 6),
                Text(description, style: AppTheme.inputStyle(context)),
                const SizedBox(height: 6),
                Text(words, style: AppTheme.inputStyle(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
