import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kahani_app/presentation%20/home/widget/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/utils/theme.dart';
import '../common _widgets/selectable_chips_list.dart';
import 'home_view_model.dart';

class CreateStoryDialogContent extends StatefulWidget {
  const CreateStoryDialogContent({super.key});

  @override
  State<CreateStoryDialogContent> createState() => _CreateStoryDialogContentState();
}

class _CreateStoryDialogContentState extends State<CreateStoryDialogContent> {
  final List<String> genres = const [
    "Fantasy", "Horror", "Sci-Fi", "Romance", "Adventure",
  ];

  final List<String> tones = const [
    "Funny", "Dark", "Emotional", "Epic", "Dramatic",
  ];

  final List<String> languages = const [
    "English", "Spanish", "French", "German", "Hindi", "Japanese", "Mandarin", "Russian",
  ];

  // This method now handles the pre-generation logic.
  Future<void> _generateStory() async {
    // Use context.read inside a method, as it's a one-time action.
    final homeProvider = context.read<HomeProvider>();
    Uint8List? imageBytes = homeProvider.selectedImage;

    // If a sample URL is selected, download the image data just-in-time.
    if (homeProvider.selectedSampleUrl != null && imageBytes == null) {
      try {
        final response = await Dio().get<Uint8List>(
          homeProvider.selectedSampleUrl!,
          options: Options(responseType: ResponseType.bytes),
        );
        imageBytes = response.data;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to download sample image.")),
          );
        }
        return;
      }
    }

    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    // Now call the provider with the definitive image bytes.
    final story = await homeProvider.generateStory(imageBytes: imageBytes);

    // If the story was generated successfully, close the dialog.
    if (story != null && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final theme = Theme.of(context);

    if (homeProvider.generationError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(homeProvider.generationError!),
            backgroundColor: AppTheme.secondary,
          ),
        );
        homeProvider.clearGenerationError();
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalImagePicker(
                    sampleImages: homeProvider.sampleImages,
                    selectedImageBytes: homeProvider.selectedImage,
                    selectedSampleUrl: homeProvider.selectedSampleUrl,
                    onUploadTap: homeProvider.pickImage,
                    onSampleSelected: homeProvider.selectSample,
                    onScrolledToEnd: homeProvider.fetchSampleImages,
                  ),
                  const SizedBox(height: 20),
                  Text("Select Genre", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SelectableChipList(options: genres, chipType: ChipType.genre),
                  const SizedBox(height: 20),
                  Text("Choose a Tone", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SelectableChipList(options: tones, chipType: ChipType.tone),
                  const SizedBox(height: 20),
                  Text("Select Language", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SelectableChipList(options: languages, chipType: ChipType.language),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: homeProvider.isGeneratingStory ? null : _generateStory,
              icon: homeProvider.isGeneratingStory
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const Icon(Icons.auto_awesome, color: AppTheme.textLight),
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
    );
  }
}
