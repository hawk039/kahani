import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/presentation%20/home/home_view_model.dart';
import 'package:kahani_app/presentation%20/stories/widgets/filter_chip_widget.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card.dart';
import 'package:provider/provider.dart';
import '../../core/utils/theme.dart';
import '../home/home.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      // homeProvider.fetchStories(); // This endpoint does not exist yet
      homeProvider.fetchSampleImages();  // Pre-load the sample images for the dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when stories change
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: AppTheme.storyCard,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar, Search, and Filters remain the same...
            Container(
              color: AppTheme.storyCard,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text("My Stories", style: AppTheme.heading),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(color: AppTheme.textLight),
                cursorColor: AppTheme.textLight,
                decoration: InputDecoration(
                  hintText: "Search your stories...",
                  prefixIcon: Icon(Icons.search, color: AppTheme.textMutedDark),
                  filled: true,
                  fillColor: AppTheme.borderDarker,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.secondary, width: 2),
                  ),
                  hintStyle: TextStyle(color: AppTheme.textMutedDark),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FilterChipWidget(label: "Sort by", icon: Icons.sort),
                  FilterChipWidget(label: "Genre"),
                  FilterChipWidget(label: "Date"),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // --- DYNAMIC STORY LIST ---
            Expanded(
              child: homeProvider.stories.isEmpty
                  ? const Center(
                      child: Text(
                        "No stories yet. Begin your journey!",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: homeProvider.stories.length,
                      itemBuilder: (context, index) {
                        final story = homeProvider.stories[index];
                        final subtitle =
                            '${story.metadata.genre} | Created: ${story.createdAt}';
                        final wordCount = '${story.story.split(' ').length} Words';
                        final imageUrl = 'https://kahani-backend-wuj0.onrender.com/images/${story.metadata.filename}';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: StoryCard(
                            title: "A tale of ${story.metadata.genre}",
                            subtitle: subtitle,
                            description: story.story,
                            words: wordCount,
                            imageUrl: imageUrl,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<Story?>(
            context: context,
            barrierColor: AppTheme.primary.withOpacity(0.9),
            builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const CreateStoryDialogContent(),
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: AppTheme.secondary,
        shape: const CircleBorder(),
        child: const Icon(Icons.auto_awesome, color: AppTheme.textLight),
      ),
    );
  }
}
