import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/theme.dart';

class HorizontalImagePicker extends StatefulWidget {
  final List<String> sampleImages;
  final Uint8List? selectedImageBytes;
  final String? selectedSampleUrl;
  final VoidCallback onUploadTap;
  final Function(String) onSampleSelected;
  final VoidCallback onScrolledToEnd;
  final VoidCallback onLocalImageSelected;

  const HorizontalImagePicker({
    super.key,
    required this.sampleImages,
    required this.selectedImageBytes,
    required this.selectedSampleUrl,
    required this.onUploadTap,
    required this.onSampleSelected,
    required this.onScrolledToEnd,
    required this.onLocalImageSelected,
  });

  @override
  State<HorizontalImagePicker> createState() => _HorizontalImagePickerState();
}

class _HorizontalImagePickerState extends State<HorizontalImagePicker> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.onScrolledToEnd();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocalImageSelected =
        widget.selectedImageBytes != null && widget.selectedSampleUrl == null;

    return SizedBox(
      height: 120.h,
      child: Row(
        children: [
          // Upload Button
          GestureDetector(
            onTap: widget.onUploadTap,
            child: Container(
              width: 100.w,
              height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppTheme.textMutedDark,
                  width: 2,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: AppTheme.textMutedDark),
                  Text("Upload", style: TextStyle(color: AppTheme.textMutedDark)),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Image List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.sampleImages.length +
                  (widget.selectedImageBytes != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (widget.selectedImageBytes != null && index == 0) {
                  return GestureDetector(
                    onTap: widget.onLocalImageSelected,
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: isLocalImageSelected
                            ? Border.all(color: AppTheme.secondary, width: 3)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.memory(
                          widget.selectedImageBytes!,
                          fit: BoxFit.cover,
                          width: 100.w,
                        ),
                      ),
                    ),
                  );
                }

                final imageIndex =
                    widget.selectedImageBytes != null ? index - 1 : index;
                final imageUrl = widget.sampleImages[imageIndex];
                final isSelected = widget.selectedSampleUrl == imageUrl;

                return GestureDetector(
                  onTap: () => widget.onSampleSelected(imageUrl),
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? Border.all(color: AppTheme.secondary, width: 3)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: 100.w,
                        placeholder: (context, url) =>
                            Container(color: AppTheme.borderDarker),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
