import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Future<void> _generateStory() async {
    final homeProvider = context.read<HomeProvider>();
    Uint8List? imageBytes = homeProvider.selectedImage;

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

    // --- BUG FIX ---
    // Set the image bytes in the provider right before generation.
    // This ensures the UI has access to the image data for the new story card.
    homeProvider.setSelectedImage(imageBytes);

    final story = await homeProvider.generateStory(imageBytes: imageBytes);

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
      padding: EdgeInsets.all(16.w),
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
                  SizedBox(height: 20.h),
                  Text("Select Genre", style: theme.textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  SelectableChipList(options: genres, chipType: ChipType.genre),
                  SizedBox(height: 20.h),
                  Text("Choose a Tone", style: theme.textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  SelectableChipList(options: tones, chipType: ChipType.tone),
                  SizedBox(height: 20.h),
                  Text("Select Language", style: theme.textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  SelectableChipList(options: languages, chipType: ChipType.language),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: homeProvider.isGeneratingStory ? null : _generateStory,
              icon: homeProvider.isGeneratingStory
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : Icon(Icons.auto_awesome, color: AppTheme.textLight, size: 24.r),
              label: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Text(
                  "Generate Story",
                  style: TextStyle(color: AppTheme.textLight, fontSize: 16.sp),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
