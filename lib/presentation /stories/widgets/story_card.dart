import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'story_card_view_model.dart';
import '../../../core/utils/theme.dart';

class StoryCard extends StatelessWidget {
  final StoryCardViewModel viewModel;

  const StoryCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: AppTheme.backgroundLight.withOpacity(0.18),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Remove Hero from here
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
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
                log("Image failed to load: $url, Error: $error");
                return Container(
                  height: 160.h,
                  color: AppTheme.borderDarker,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppTheme.textMutedDark,
                    size: 48.r,
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.r),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.surfaceDark.withOpacity(0.96),
                  AppTheme.surfaceDark.withOpacity(1.0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.subtitle,
                  style: AppTheme.inputStyle(context)
                      .copyWith(fontSize: 12.sp),
                ),
                SizedBox(height: 2.h),
                // Remove Hero from here
                Text(
                  viewModel.title,
                  style: AppTheme.heading.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 6.h),
                Text(
                  viewModel.description,
                  style: AppTheme.inputStyle(context)
                      .copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 6.h),
                Text(
                  viewModel.wordCount,
                  style: AppTheme.inputStyle(context)
                      .copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
