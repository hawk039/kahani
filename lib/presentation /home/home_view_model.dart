import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  // --- Private fields ---
  String? _selectedGenre;
  String? _selectedTone;
  Uint8List? _selectedImage;
  String? _selectedSampleUrl; // For sample image selection

  List<String> sampleImages = [
    "https://lh3.googleusercontent.com/aida-public/AB6AXuD7afjcCSbBjugowwaJI0sLc5bQn949EWnM_MGlFZEBK3u0Ko0biBcNQby8Mr5h9ggePBKejl3eAyYkZhRvo2Ibqe_dmvFz2pbY9F4OPjCutwDetEbpaGHuBR5MXJYIlPTQsZ3ENDfcwzaxSE2IbkhQG0y6e_20nu6nrLztA-VTkGx6X6w9mMpNvA5LuoLeJVxL_WMXTX7bPyugw_l6CCXGZ0H90eTGqVDNduSjKjMIQFXUYAJ_h82u29iypSojtcLrQbLa2VH7UyK8",
    "https://lh3.googleusercontent.com/aida-public/AB6AXuB3QVsizFDEMiYfRlqNZ89SEE9JEQygM3mS5_Dv2cN6QRlchcsYf3w90y-hCrWdDfwOCE8xv5lwUjgTCZ8Cf49ssxkHNgsOQ2RXDZJlJxW5fX6-FwljslA1Xy1MogHXv3Zo0_fzU86bWIMVRmis5rsN92-25SsoCGIzBgVjEYo_4gX7Rm5RyEbpnPcNw5KvKi3BjR26mmibgub_ExDfzzgif-uVWx5zztFrAs8ypLZHfP6IYosDseSJqt7BOedq2L1J6YAkMelfYOmr",
    "https://lh3.googleusercontent.com/aida-public/AB6AXuD7afjcCSbBjugowwaJI0sLc5bQn949EWnM_MGlFZEBK3u0Ko0biBcNQby8Mr5h9ggePBKejl3eAyYkZhRvo2Ibqe_dmvFz2pbY9F4OPjCutwDetEbpaGHuBR5MXJYIlPTQsZ3ENDfcwzaxSE2IbkhQG0y6e_20nu6nrLztA-VTkGx6X6w9mMpNvA5LuoLeJVxL_WMXTX7bPyugw_l6CCXGZ0H90eTGqVDNduSjKjMIQFXUYAJ_h82u29iypSojtcLrQbLa2VH7UyK8",
    "https://lh3.googleusercontent.com/aida-public/AB6AXuB3QVsizFDEMiYfRlqNZ89SEE9JEQygM3mS5_Dv2cN6QRlchcsYf3w90y-hCrWdDfwOCE8xv5lwUjgTCZ8Cf49ssxkHNgsOQ2RXDZJlJxW5fX6-FwljslA1Xy1MogHXv3Zo0_fzU86bWIMVRmis5rsN92-25SsoCGIzBgVjEYo_4gX7Rm5RyEbpnPcNw5KvKi3BjR26mmibgub_ExDfzzgif-uVWx5zztFrAs8ypLZHfP6IYosDseSJqt7BOedq2L1J6YAkMelfYOmr",
  ];

  // --- Getters ---
  String? get selectedGenre => _selectedGenre;

  String? get selectedTone => _selectedTone;

  Uint8List? get selectedImage => _selectedImage;

  String? get selectedSampleUrl => _selectedSampleUrl;

  // --- Setters / Update functions ---
  void setSelectedGenre(String? genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void setSelectedTone(String? tone) {
    _selectedTone = tone;
    notifyListeners();
  }

  void setSelectedImage(Uint8List? imageBytes) {
    _selectedImage = imageBytes;
    _selectedSampleUrl = null; // Reset sample if uploading new image
    notifyListeners();
  }

  void setSelectedSample(String? sampleUrl) {
    _selectedSampleUrl = sampleUrl;
    _selectedImage = null; // Reset uploaded image if sample selected
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      _selectedImage = await imageFile.readAsBytes();
      _selectedSampleUrl = null; // reset sample selection
      notifyListeners();
    }
  }

  void selectSample(String url) {
    _selectedSampleUrl = url;
    _selectedImage = null; // reset uploaded image
    notifyListeners();
  }

  // --- Optional: Reset all selections ---
  void resetSelections() {
    _selectedGenre = null;
    _selectedTone = null;
    _selectedImage = null;
    _selectedSampleUrl = null;
    notifyListeners();
  }
}
