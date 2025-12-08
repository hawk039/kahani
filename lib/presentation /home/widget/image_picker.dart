import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kahani_app/core/utils/theme.dart';

class HorizontalImagePicker extends StatefulWidget {
  final List<String> sampleImages;
  final Uint8List? selectedImageBytes;
  final String? selectedSampleUrl;
  final VoidCallback onUploadTap;
  final Function(String url) onSampleSelected;
  final VoidCallback onScrolledToEnd;

  const HorizontalImagePicker({
    super.key,
    required this.sampleImages,
    required this.onUploadTap,
    required this.onSampleSelected,
    required this.onScrolledToEnd,
    this.selectedImageBytes,
    this.selectedSampleUrl,
  });

  @override
  State<HorizontalImagePicker> createState() => _HorizontalImagePickerState();
}

class _HorizontalImagePickerState extends State<HorizontalImagePicker> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      widget.onScrolledToEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine if the upload button should be highlighted
    final isUploadSelected = widget.selectedImageBytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose an Image",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: widget.sampleImages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Upload Button Card
                return GestureDetector(
                  onTap: widget.onUploadTap,
                  child: Container(
                    width: 100,
                    height: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        // Highlight if an image is uploaded
                        color: isUploadSelected ? AppTheme.secondary : AppTheme.borderDarker,
                        width: 2,
                      ),
                      color: AppTheme.borderDarker,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined, size: 32),
                        SizedBox(height: 6),
                        Text("Upload", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }

              // Sample Image Cards
              final imgUrl = widget.sampleImages[index - 1];
              // Highlight if this specific sample URL is selected
              final isSelected = imgUrl == widget.selectedSampleUrl;

              return GestureDetector(
                onTap: () => widget.onSampleSelected(imgUrl),
                child: Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.secondary : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imgUrl),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
