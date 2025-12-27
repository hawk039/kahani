import 'dart:developer';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card_view_model.dart';
import '../../../core/utils/theme.dart';

class StoryCard extends StatelessWidget {
  final StoryCardViewModel viewModel;
  final Uint8List? imageBytes; // This is for the temporary local image

  const StoryCard({
    super.key,
    required this.viewModel,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: viewModel.imageUrl,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 160.h,
                      color: AppTheme.borderDarker,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppTheme.secondary,
                        strokeWidth: 2.0,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      // --- LOGGING THE ERROR ---
                      log("Image failed to load: $url, Error: $error");
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
                Text(viewModel.subtitle, style: AppTheme.inputStyle(context).copyWith(fontSize: 12.sp)),
                Text(viewModel.title, style: AppTheme.heading.copyWith(fontSize: 20.sp)),
                SizedBox(height: 6.h),
                Text(viewModel.description, style: AppTheme.inputStyle(context).copyWith(fontSize: 14.sp)),
                SizedBox(height: 6.h),
                Text(viewModel.wordCount, style: AppTheme.inputStyle(context).copyWith(fontSize: 12.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
