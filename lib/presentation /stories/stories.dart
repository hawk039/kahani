import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kahani_app/core/app_routes.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/presentation%20/home/home.dart';
import 'package:kahani_app/presentation%20/home/home_view_model.dart';
import 'package:kahani_app/presentation%20/stories/widgets/filter_chip_widget.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card_shimmer.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card_view_model.dart';
import 'package:provider/provider.dart';

import '../../core/utils/assets.dart';
import '../../core/utils/theme.dart';

class StoriesPage extends StatefulWidget {
  static const routeName = '/stories';
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.fetchStories(isInitial: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        homeProvider.fetchStories();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final uniqueGenres = homeProvider.stories.map((s) => s.metadata.genre).toSet().toList();

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            if (homeProvider.stories.isNotEmpty)
              _buildFilterSection(homeProvider, uniqueGenres),

            Expanded(
              child: homeProvider.isLoading && homeProvider.stories.isEmpty
                  ? _buildShimmerList()
                  : (homeProvider.filteredStories.isEmpty
                      ? _buildEmptyState(homeProvider)
                      : _buildStoryList(homeProvider)),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text("My Stories",
                  style: AppTheme.heading.copyWith(fontSize: 24.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          sizeConstraints: BoxConstraints.tightFor(
            width: 70.r,
            height: 70.r,
          ),
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
        elevation: 8.0,
        child: Icon(Icons.auto_awesome, color: AppTheme.textLight, size: 45.r),
      ),
    );
  }

  Widget _buildFilterSection(
      HomeProvider homeProvider, List<String> uniqueGenres) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: TextField(
            onChanged: homeProvider.setSearchQuery,
            style: TextStyle(color: AppTheme.textLight, fontSize: 16.sp),
            cursorColor: AppTheme.textLight,
            decoration: InputDecoration(
              hintText: "Search your stories...",
              prefixIcon:
                  Icon(Icons.search, color: AppTheme.textMutedDark, size: 24.r),
              filled: true,
              fillColor: AppTheme.borderDarker,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppTheme.secondary, width: 2),
              ),
              hintStyle: TextStyle(color: AppTheme.textMutedDark, fontSize: 16.sp),
            ),
          ),
        ),
        SizedBox(
          height: 40.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              FilterChipWidget(
                label: homeProvider.sortBy == SortBy.newest
                    ? "Sort: Newest"
                    : "Sort: Oldest",
                icon: Icons.sort,
                isSelected: true,
                onTap: () {
                  final newSort = homeProvider.sortBy == SortBy.newest
                      ? SortBy.oldest
                      : SortBy.newest;
                  homeProvider.setSortBy(newSort);
                },
              ),
              ...uniqueGenres.map((genre) => FilterChipWidget(
                    label: genre,
                    isSelected: homeProvider.filterGenre == genre,
                    onTap: () => homeProvider.setFilterGenre(genre),
                  )),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildEmptyState(HomeProvider homeProvider) {
    return RefreshIndicator(
      onRefresh: () => homeProvider.fetchStories(isInitial: true),
      backgroundColor: AppTheme.secondary,
      color: Colors.white,
      child: Stack(
        children: [
          ListView(), // Needed for RefreshIndicator to work
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "No stories yet. Begin your journey!",
                  style: TextStyle(color: AppTheme.textMutedDark, fontSize: 18.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: const StoryCardShimmer(),
      ),
    );
  }

  Widget _buildStoryList(HomeProvider homeProvider) {
    return RefreshIndicator(
      onRefresh: () => homeProvider.fetchStories(isInitial: true),
      backgroundColor: AppTheme.secondary,
      color: Colors.white,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: homeProvider.filteredStories.length +
            (homeProvider.isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= homeProvider.filteredStories.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CupertinoActivityIndicator(color: AppTheme.secondary)),
            );
          }

          final story = homeProvider.filteredStories[index];
          final cardViewModel = StoryCardViewModel(story);

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: () async {
                final updatedStory = await Navigator.pushNamed(
                  context,
                  AppRoutes.storyDetail,
                  arguments: story,
                ) as Story?;

                if (updatedStory != null) {
                  homeProvider.updateStoryInList(updatedStory);
                }
              },
              child: StoryCard(
                viewModel: cardViewModel,
              ),
            ),
          );
        },
      ),
    );
  }
}
