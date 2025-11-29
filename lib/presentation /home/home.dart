import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kahani_app/core/utils/theme.dart';
import 'package:kahani_app/presentation%20/home/widget/image_picker.dart';
import 'package:provider/provider.dart';

import '../common _widgets/selectable_chips_list.dart';
import 'home_view_model.dart';

class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({super.key});

  // temp static values — replace later with real API list
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Uint8List?
    selectedImage; // TODO: Replace with state from your state management
    String? selectedGenre; // TODO: Replace with provider/bloc state
    String? selectedTone; // TODO: Replace with provider/bloc state
    bool isLoading = false; // TODO: Replace with your management flag

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Story", style: AppTheme.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- IMAGE PICKER ----------------
              HorizontalImagePicker(
                sampleImages: context.read<HomeProvider>().sampleImages,
                onUploadTap: () => context.read<HomeProvider>().pickImage(),
                onSampleSelected: (url) =>
                    context.read<HomeProvider>().selectSample(url),
              ),

              const SizedBox(height: 20),

              /// ---------------- GENRE CHIPS ----------------
              Text("Select Genre", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              SelectableChipList(
                options: genres,
                chipType: ChipType.genre, // 🔥 required
              ),
              const SizedBox(height: 20),

              /// ---------------- TONE CHIPS ----------------
              Text("Choose a Tone", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              SelectableChipList(
                options: tones,
                chipType: ChipType.tone, // 🔥 required
              ),

              const Spacer(),

              /// ---------------- GENERATE BUTTON ----------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Trigger story generation event
                    // Conditions:
                    // - If selectedImage == null => show error Snackbar
                    // - Use genre + tone
                  },
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.textLight,
                  ),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Generate Story",
                      style: TextStyle(
                        color: AppTheme.textLight, // Typed text color
                      ),
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
  }
}
