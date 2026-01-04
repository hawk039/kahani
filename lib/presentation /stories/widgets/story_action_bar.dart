import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kahani_app/core/utils/theme.dart';
import 'package:kahani_app/presentation%20/stories/story_detail_view_model.dart';
import 'package:provider/provider.dart';

class StoryActionBar extends StatelessWidget {
  const StoryActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StoryDetailViewModel>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(
            context,
            icon: viewModel.isEditing ? Icons.done : Icons.edit,
            label: viewModel.isEditing ? "Done" : "Edit",
            onTap: viewModel.toggleEditing,
          ),
          _buildActionItem(
            context,
            icon: Icons.auto_awesome,
            label: "Regenerate",
            onTap: () {
              // TODO: Implement Regenerate functionality
            },
          ),
          _buildActionItem(
            context,
            icon: Icons.share,
            label: "Share",
            onTap: () {
              // TODO: Implement Share functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.borderDarker
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.textMutedDark, size: 24.r),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}
