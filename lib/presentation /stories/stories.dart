import 'dart:ui';
import 'package:flutter/material.dart';
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
    // As soon as this page loads, trigger the initial image fetch.
    // We use `listen: false` because we don't need to rebuild this widget
    // when the images arrive; we just need to trigger the fetch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchSampleImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.storyCard,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(
                  color: AppTheme.textLight,
                ),
                cursorColor: AppTheme.textLight,
                decoration: InputDecoration(
                  hintText: "Search your stories...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textMutedDark,
                  ),
                  filled: true,
                  fillColor: AppTheme.borderDarker,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // No border normally
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.secondary,
                      width: 2,
                    ),
                  ),
                  hintStyle: TextStyle(color: AppTheme.textMutedDark),
                ),
              ),
            ),
            // Chips / Filters
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
            // Story List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: const [
                  StoryCard(
                    title: "The Last Stargazer",
                    subtitle: "Sci-Fi | Created: Oct 26, 2023",
                    description:
                        "In a world where the stars had vanished, one astronomer remembered the old tales. Every night, she'd climb the tallest hill, hoping to catch a glimpse of the forgotten light...",
                    words: "1,200 Words",
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuB3QVsizFDEMiYfRlqNZ89SEE9JEQygM3mS5_Dv2cN6QRlchcsYf3w90y-hCrWdDfwOCE8xv5lwUjgTCZ8Cf49ssxkHNgsOQ2RXDZJlJxW5fX6-FwljslA1Xy1MogHXv3Zo0_fzU86bWIMVRmis5rsN92-25SsoCGIzBgVjEYo_4gX7Rm5RyEbpnPcNw5KvKi3BjR26mmibgub_ExDfzzgif-uVWx5zztFrAs8ypLZHfP6IYosDseSJqt7BOedq2L1J6YAkMelfYOmr",
                  ),
                  SizedBox(height: 12),
                  StoryCard(
                    title: "The Whispering Woods",
                    subtitle: "Fantasy | Created: Oct 22, 2023",
                    description:
                        "Elara never intended to enter the Whispering Woods, a place forbidden by village elders. But when her younger brother disappears, she has no choice but to face the ancient magic within...",
                    words: "2,500 Words",
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuD7afjcCSbBjugowwaJI0sLc5bQn949EWnM_MGlFZEBK3u0Ko0biBcNQby8Mr5h9ggePBKejl3eAyYkZhRvo2Ibqe_dmvFz2pbY9F4OPjCutwDetEbpaGHuBR5MXJYIlPTQsZ3ENDfcwzaxSE2IbkhQG0y6e_20nu6nrLztA-VTkGx6X6w9mMpNvA5LuoLeJVxL_WMXTX7bPyugw_l6CCXGZ0H90eTGqVDNduSjKjMIQFXUYAJ_h82u29iypSojtcLrQbLa2VH7UyK8",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
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
