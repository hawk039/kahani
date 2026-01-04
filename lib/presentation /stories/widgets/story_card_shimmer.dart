import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/utils/theme.dart';

class StoryCardShimmer extends StatelessWidget {
  const StoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppTheme.storyCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.borderDarker, width: 1.5),
      ),
      child: Shimmer.fromColors(
        baseColor: AppTheme.borderDarker,
        highlightColor: AppTheme.storyCard.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // Shimmer will be applied to this color
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 24.h,
              width: 200.w,
              color: Colors.white,
            ),
            SizedBox(height: 8.h),
            Container(
              height: 16.h,
              width: 100.w,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
