import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Image(
              image: imageProvider,
              height: 160.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160.h,
                  color: AppTheme.borderDarker,
                  alignment: Alignment.center,
                  child: Icon(Icons.image_not_supported, color: AppTheme.textMutedDark, size: 48.r),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: AppTheme.inputStyle(context).copyWith(fontSize: 12.sp)),
                Text(title, style: AppTheme.heading.copyWith(fontSize: 20.sp)),
                SizedBox(height: 6.h),
                Text(description, style: AppTheme.inputStyle(context).copyWith(fontSize: 14.sp)),
                SizedBox(height: 6.h),
                Text(words, style: AppTheme.inputStyle(context).copyWith(fontSize: 12.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
