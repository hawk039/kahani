import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/core/utils/theme.dart';
import 'story_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'widgets/story_action_bar.dart';

class StoryDetailPage extends StatelessWidget {
  static const routeName = '/story-detail';
  final Story story;

  const StoryDetailPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryDetailViewModel(story),
      child: WillPopScope(
        onWillPop: () async {
          final viewModel = context.read<StoryDetailViewModel>();
          Navigator.of(context).pop(viewModel.story);
          return true;
        },
        child: Consumer<StoryDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
                viewModel.clearError();
              });
            }

            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context, viewModel),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Remove Hero from here
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: CachedNetworkImage(
                                    imageUrl: viewModel.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppTheme.borderDarker,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        color: AppTheme.secondary,
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: AppTheme.borderDarker,
                                      child: const Icon(Icons.image_not_supported, color: AppTheme.textMutedDark),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Remove Hero from here
                                  Text(
                                    viewModel.title,
                                    style: AppTheme.heading.copyWith(fontSize: 24.sp),
                                  ),
                                  SizedBox(height: 12.h),
                                  viewModel.isEditing
                                      ? TextField(
                                          controller: viewModel.storyTextController,
                                          maxLines: null,
                                          cursorColor: Colors.white,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppTheme.textLight,
                                            height: 1.5,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Your story here...',
                                          ),
                                        )
                                      : Text(
                                          viewModel.storyTextController.text.replaceAll('\\n', '\n\n'),
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppTheme.textLight,
                                            height: 1.5,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        border: const Border(top: BorderSide(color: AppTheme.borderDarker, width: 1.5)),
                      ),
                      child: Column(
                        children: [
                          const StoryActionBar(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed: viewModel.isEditing && !viewModel.isSaving
                                    ? () => viewModel.saveStory()
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.secondary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppTheme.secondary.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: viewModel.isSaving
                                    ? const CupertinoActivityIndicator(color: Colors.white)
                                    : Text(
                                        "Save Story",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, StoryDetailViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(viewModel.story),
          ),
          Text(
            "Your Story",
            style: AppTheme.heading.copyWith(fontSize: 20.sp),
          ),
          SizedBox(width: 48.w), // Balance the back button
        ],
      ),
    );
  }
}
