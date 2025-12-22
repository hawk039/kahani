import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/presentation%20/home/home_view_model.dart';
import 'package:kahani_app/presentation%20/stories/story_detail_page.dart';
import 'package:kahani_app/presentation%20/stories/widgets/filter_chip_widget.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card.dart';
import 'package:provider/provider.dart';
import '../../core/utils/assets.dart';
import '../../core/utils/theme.dart';
import '../home/home.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    if (homeProvider.sampleImages.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        homeProvider.fetchSampleImages();
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.storyCard,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppTheme.storyCard,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "My Stories",
                        style: AppTheme.heading.copyWith(fontSize: 24.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (homeProvider.stories.isNotEmpty)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 16.sp,
                      ),
                      cursorColor: AppTheme.textLight,
                      decoration: InputDecoration(
                        hintText: "Search your stories...",
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppTheme.textMutedDark,
                          size: 24.r,
                        ),
                        filled: true,
                        fillColor: AppTheme.borderDarker,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppTheme.secondary,
                            width: 2,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: AppTheme.textMutedDark,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      children: [
                        FilterChipWidget(label: "Sort by", icon: Icons.sort),
                        FilterChipWidget(label: "Genre"),
                        FilterChipWidget(label: "Date"),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            Expanded(
              child: homeProvider.stories.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.all(48.r),
                          decoration: const BoxDecoration(
                            color: AppTheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            AppAssets.feather,
                            width: 64.w,
                            height: 64.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "No stories yet. Begin your journey!",
                          style: TextStyle(
                            color: AppTheme.textMutedDark,
                            fontSize: 18.sp,
                          ),
                        ),
                        const Spacer(),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: homeProvider.stories.length,
                      itemBuilder: (context, index) {
                        final story = homeProvider.stories[index];
                        final firstParagraph = story.story.split('\n\n').first;
                        final description = '$firstParagraph...';

                        final subtitle =
                            '${story.metadata.genre} | Created: ${story.createdAt}';
                        final wordCount =
                            '${story.story.split(' ').length} Words';
                        final imageUrl =
                            'https://kahani-backend-wuj0.onrender.com/images/${story.metadata.filename}';
                        final imageBytes = (index == 0)
                            ? homeProvider.selectedImage
                            : null;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StoryDetailPage(story: story),
                                ),
                              );
                            },
                            child: StoryCard(
                              title: "A tale of ${story.metadata.genre}",
                              subtitle: subtitle,
                              description: description,
                              words: wordCount,
                              imageUrl: imageUrl,
                              imageBytes: imageBytes,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            sizeConstraints: BoxConstraints.tightFor(width: 90.r, height: 90.r),
          ),
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await showDialog<Story?>(
              context: context,
              builder: (context) => Dialog(
                insetPadding: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: ScreenUtil().screenHeight * 0.8,
                  child: const CreateStoryDialogContent(),
                ),
              ),
            );
          },
          backgroundColor: AppTheme.secondary,
          shape: const CircleBorder(),
          child: Icon(
            Icons.auto_awesome,
            color: AppTheme.textLight,
            size: 45.r,
          ),
        ),
      ),
    );
  }
}
