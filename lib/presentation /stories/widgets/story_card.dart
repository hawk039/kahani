import 'dart:developer';
import 'dart:ui';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark.withOpacity(0.96),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
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
                      color: AppTheme.surfaceDark.withOpacity(0.96),
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
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.subtitle,
                      style: AppTheme.inputStyle(context).copyWith(
                        fontSize: 12.sp,
                        color: AppTheme.textMutedDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      viewModel.title,
                      style: AppTheme.heading.copyWith(fontSize: 20.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      viewModel.description,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.inputStyle(context).copyWith(
                        fontSize: 14.sp,
                        color: AppTheme.textLight.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.wordCount,
                          style: AppTheme.inputStyle(context).copyWith(
                            fontSize: 12.sp,
                            color: AppTheme.secondary.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.r,
                          color: AppTheme.textMutedDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
