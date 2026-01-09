import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:kahani_app/core/app_routes.dart';
import 'package:kahani_app/data/models/story.dart';
import '../home/home_view_model.dart';
import '../profile/widgets/profile_dropdown.dart';
import 'story_detail_page.dart';
import 'widgets/filter_chip_widget.dart';
import 'widgets/story_card.dart';
import 'widgets/story_card_shimmer.dart';
import 'widgets/story_card_view_model.dart';
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
  bool _isProfileDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    // FIX: Schedule the fetch to run after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchStories(isInitial: true);
    });

    _scrollController.addListener(() {
      // Use the provider from a scope that is allowed to listen.
      final homeProvider = context.read<HomeProvider>();
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
    final uniqueGenres = homeProvider.stories
        .map((s) => s.metadata.genre)
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
            if (_isProfileDropdownVisible)
              Positioned(
                top: 60.h,
                left: 16.w,
                child: ProfileDropdown(
                  onLogout: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const String? imageUrl = null;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isProfileDropdownVisible = !_isProfileDropdownVisible;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: _isProfileDropdownVisible
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
              ),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppTheme.secondary,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: 40.r,
                          height: 40.r,
                        ),
                      )
                    :  Icon(Icons.person, color: Colors.white, size: 24.r),
              ),
            ),
          ),
          Text("My Stories", style: AppTheme.heading.copyWith(fontSize: 24.sp)),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    HomeProvider homeProvider,
    List<String> uniqueGenres,
  ) {
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
              ...uniqueGenres.map(
                (genre) => FilterChipWidget(
                  label: genre,
                  isSelected: homeProvider.filterGenre == genre,
                  onTap: () => homeProvider.setFilterGenre(genre),
                ),
              ),
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
          ListView(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppAssets.parchmentAnimation,
                  width: 300.w,
                  height: 300.h,
                ),
                SizedBox(height: 24.h),
                Text(
                  "No stories yet. Begin your journey!",
                  style: TextStyle(
                    color: AppTheme.textMutedDark,
                    fontSize: 18.sp,
                  ),
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
              child: Center(
                child: CupertinoActivityIndicator(color: AppTheme.secondary),
              ),
            );
          }

          final story = homeProvider.filteredStories[index];
          final cardViewModel = StoryCardViewModel(story);

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: OpenContainer(
              transitionType: ContainerTransitionType.fade,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              closedColor: AppTheme.surfaceDark,
              openColor: AppTheme.primary,
              middleColor: AppTheme.primary,
              transitionDuration: const Duration(milliseconds: 500),
              onClosed: (story) {
                if (story != null) {
                  homeProvider.updateStoryInList(story as Story);
                }
              },
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return StoryCard(viewModel: cardViewModel);
              },
              openBuilder: (BuildContext _, VoidCallback __) {
                return StoryDetailPage(story: story);
              },
            ),
          );
        },
      ),
    );
  }
}
