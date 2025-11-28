import 'package:flutter/material.dart';
import 'package:kahani_app/presentation%20/stories/widgets/filter_chip_widget.dart';
import 'package:kahani_app/presentation%20/stories/widgets/story_card.dart';

import '../../core/utils/theme.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              color: AppTheme.darkTheme.primaryColor,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                style: const TextStyle(
                  color: AppTheme.textLight, // Typed text color
                ),
                cursorColor: AppTheme.textLight, // Cursor color
                decoration: InputDecoration(
                  hintText: "Search your stories...",
                  prefixIcon: Icon(Icons.search, color: AppTheme.textMutedDark),
                  filled: true,
                  fillColor: AppTheme.borderDarker,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.secondary),
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
        onPressed: () {},
        backgroundColor: AppTheme.secondary,
        shape: const CircleBorder(), // 🔥 makes it a perfect circle
        child: const Icon(Icons.auto_awesome, color: AppTheme.textLight),
      ),
    );
  }
}
