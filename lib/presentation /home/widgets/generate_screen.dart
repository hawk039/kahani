import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme.dart';
import '../../common _widgets/selectable_chips_list.dart';
import '../home_view_model.dart';
import 'image_picker.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final List<String> genres = const [
    "Fantasy", "Horror", "Sci-Fi", "Romance", "Adventure",
  ];

  final List<String> tones = const [
    "Funny", "Dark", "Emotional", "Epic", "Dramatic",
  ];

  final List<String> languages = const [
    "English", "Spanish", "French", "German", "Hindi", "Japanese", "Mandarin", "Russian",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      if (homeProvider.sampleImages.isEmpty) {
        homeProvider.fetchSampleImages();
      }
    });
  }

  Future<void> _generateStory() async {
    final homeProvider = context.read<HomeProvider>();
    Uint8List? imageBytes;

    if (homeProvider.selectedSampleUrl != null) {
      imageBytes = await homeProvider.downloadImage(homeProvider.selectedSampleUrl!);
      if (imageBytes == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to download sample image.")),
        );
        return;
      }
    } else {
      imageBytes = homeProvider.selectedImage;
    }

    if (imageBytes == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    // The generateStory method in the provider now handles navigation.
    final story = await homeProvider.generateStory(imageBytes: imageBytes!);

    // FIX: Remove the SnackBar and just clean the state.
    if (story != null && mounted) {
      homeProvider.resetSelections();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final theme = Theme.of(context);

    if (homeProvider.generationError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(homeProvider.generationError!),
              backgroundColor: AppTheme.secondary,
            ),
          );
          homeProvider.clearGenerationError();
        }
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Center(
                child: Text(
                  "imagine your story",
                  style: AppTheme.heading.copyWith(fontSize: 24.sp),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              onLocalImageSelected: homeProvider.setActiveLocalImage,
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
                     SizedBox(height: 16.h), // Padding at the bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
