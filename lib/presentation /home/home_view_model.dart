import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  // --- Repository ---
  final HomeRepository _repo = HomeRepository();

  // --- Private fields ---
  String? _selectedGenre;
  String? _selectedTone;
  String? _selectedLanguage; // Added language
  Uint8List? _selectedImage;
  String? _selectedSampleUrl;

  List<String> sampleImages = [];
  int _currentPage = 1;
  bool _isFetching = false;

  // --- Getters ---
  String? get selectedGenre => _selectedGenre;
  String? get selectedTone => _selectedTone;
  String? get selectedLanguage => _selectedLanguage; // Added language getter
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

  void setSelectedLanguage(String? language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setSelectedImage(Uint8List? imageBytes) {
    _selectedImage = imageBytes;
    _selectedSampleUrl = null;
    notifyListeners();
  }

  void setSelectedSample(String? sampleUrl) {
    _selectedSampleUrl = sampleUrl;
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      _selectedImage = await imageFile.readAsBytes();
      _selectedSampleUrl = null;
      notifyListeners();
    }
  }

  void selectSample(String url) {
    _selectedSampleUrl = url;
    _selectedImage = null;
    notifyListeners();
  }

  // --- Data Fetching ---
  Future<void> fetchSampleImages() async {
    if (_isFetching) return;

    _isFetching = true;

    final newImageUrls = await _repo.fetchSampleImages(_currentPage);
    if (newImageUrls.isNotEmpty) {
      sampleImages.addAll(newImageUrls);
      _currentPage++;
      notifyListeners();
    }

    _isFetching = false;
  }

  // --- Reset ---
  void resetSelections() {
    _selectedGenre = null;
    _selectedTone = null;
    _selectedLanguage = null; // Reset language
    _selectedImage = null;
    _selectedSampleUrl = null;
    notifyListeners();
  }
}
