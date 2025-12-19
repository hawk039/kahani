import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/generate_story_result.dart';
import '../../../data/models/story.dart';
import '../../../data/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repo = HomeRepository();
  final Dio _dio = Dio();

  // --- State ---
  String? _selectedGenre;
  String? _selectedTone;
  String? _selectedLanguage;
  Uint8List? _selectedImage;
  String? _selectedSampleUrl;
  List<String> sampleImages = [];
  List<Story> stories = [];
  // Set<int> expandedStoryIds = {}; // REMOVED - No longer needed
  int _currentPage = 1;
  bool _isFetchingImages = false;
  bool _isGeneratingStory = false;
  String? _generationError;

  // --- Getters ---
  String? get selectedGenre => _selectedGenre;
  String? get selectedTone => _selectedTone;
  String? get selectedLanguage => _selectedLanguage;
  Uint8List? get selectedImage => _selectedImage;
  String? get selectedSampleUrl => _selectedSampleUrl;
  bool get isGeneratingStory => _isGeneratingStory;
  String? get generationError => _generationError;

  // --- UI Actions ---
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
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

  void clearGenerationError() {
    _generationError = null;
  }

  // REMOVED - No longer needed
  // void toggleStoryExpanded(int storyId) { ... }

  // --- API Calls ---
  Future<void> fetchSampleImages() async {
    if (_isFetchingImages) return;
    _isFetchingImages = true;

    final newImageUrls = await _repo.fetchSampleImages(_currentPage);
    if (newImageUrls.isNotEmpty) {
      sampleImages.addAll(newImageUrls);
      _currentPage++;
      notifyListeners();
    }

    _isFetchingImages = false;
  }

  Future<Story?> generateStory({required Uint8List imageBytes}) async {
    if (_selectedGenre == null || _selectedTone == null || _selectedLanguage == null) {
      _generationError = "Please select all options before generating.";
      notifyListeners();
      return null;
    }

    _isGeneratingStory = true;
    _generationError = null;
    notifyListeners();

    final result = await _repo.generateStory(
      genre: _selectedGenre!,
      tone: _selectedTone!,
      language: _selectedLanguage!,
      imageBytes: imageBytes,
    );

    if (result.ok) {
      stories.insert(0, result.story!); 
      _isGeneratingStory = false;
      notifyListeners();
      return result.story;
    } else {
      _generationError = result.error;
      _isGeneratingStory = false;
      notifyListeners();
      return null;
    }
  }

  void resetSelections() {
    _selectedGenre = null;
    _selectedTone = null;
    _selectedLanguage = null;
    _selectedImage = null;
    _selectedSampleUrl = null;
    // expandedStoryIds.clear(); // REMOVED
    notifyListeners();
  }
}
