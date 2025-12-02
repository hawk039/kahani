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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      sampleImages: context.read<HomeProvider>().sampleImages,
                      onUploadTap: () =>
                          context.read<HomeProvider>().pickImage(),
                      onSampleSelected: (url) =>
                          context.read<HomeProvider>().selectSample(url),
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

                    const Spacer(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: generate story
                        },
                        icon: Icon(
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
