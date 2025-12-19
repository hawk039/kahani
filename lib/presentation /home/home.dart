import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kahani_app/presentation%20/home/widget/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/utils/theme.dart';
import '../common _widgets/selectable_chips_list.dart';
import 'home_view_model.dart';

class CreateStoryDialogContent extends StatelessWidget {
  const CreateStoryDialogContent({super.key});

  final List<String> genres = const [
    "Fantasy",
    "Horror",
    "Sci-Fi",
    "Romance",
    "Adventure",
  ];

  final List<String> tones = const [
    "Funny",
    "Dark",
    "Emotional",
    "Epic",
    "Dramatic",
  ];

  final List<String> languages = const [
    "English",
    "Spanish",
    "French",
    "German",
    "Hindi",
    "Japanese",
    "Mandarin",
    "Russian",
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final theme = Theme.of(context);

    // Listen for generation errors and show a snackbar
    if (homeProvider.generationError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(homeProvider.generationError!),
            backgroundColor: AppTheme.secondary,
          ),
        );
        homeProvider.clearGenerationError(); // Clear the error after showing
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HorizontalImagePicker(
                      sampleImages: homeProvider.sampleImages,
                      selectedImageBytes: homeProvider.selectedImage,
                      selectedSampleUrl: homeProvider.selectedSampleUrl,
                      onUploadTap: () =>
                          context.read<HomeProvider>().pickImage(),
                      onSampleSelected: (url) =>
                          context.read<HomeProvider>().selectSample(url),
                      onScrolledToEnd: () =>
                          context.read<HomeProvider>().fetchSampleImages(),
                    ),
                    const SizedBox(height: 20),

                    Text("Select Genre", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SelectableChipList(
                      options: genres,
                      chipType: ChipType.genre,
                    ),
                    const SizedBox(height: 20),

                    Text("Choose a Tone", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SelectableChipList(options: tones, chipType: ChipType.tone),
                    const SizedBox(height: 20),

                    Text("Select Language", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SelectableChipList(
                      options: languages,
                      chipType: ChipType.language,
                    ),

                    const Spacer(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: homeProvider.isGeneratingStory
                            ? null // Disable button while loading
                            : () async {
                                final story = await context
                                    .read<HomeProvider>()
                                    .generateStory();
                                if (story != null) {
                                  // TODO: Navigate to a new screen to show the story
                                  print(story);
                                }
                              },
                        icon: homeProvider.isGeneratingStory
                            ? const CupertinoActivityIndicator(color: Colors.white)
                            : const Icon(
                                Icons.auto_awesome,
                                color: AppTheme.textLight,
                              ),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "Generate Story",
                            style: TextStyle(color: AppTheme.textLight),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
