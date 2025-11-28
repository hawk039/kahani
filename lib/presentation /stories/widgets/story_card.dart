import 'package:flutter/material.dart';

import '../../../core/utils/theme.dart';

class StoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String words;
  final String imageUrl;

  const StoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.words,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.borderDarker,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
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
