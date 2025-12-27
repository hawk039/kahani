import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/generate_story_result.dart';
import '../../../data/models/story.dart';
import '../../../data/repositories/home_repository.dart';

// New: An enum to define the available sort orders.
enum SortBy {
  newest,
  oldest,
}

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repo;
  final Box<Story> _storiesBox;

  // --- State ---
  String? _selectedGenre;
  String? _selectedTone;
  String? _selectedLanguage;
  Uint8List? _selectedImage;
  String? _selectedSampleUrl;
  List<String> sampleImages = [];
  List<Story> stories = [];
  int _currentPage = 1;
  bool _isFetchingImages = false;
  bool _isGeneratingStory = false;
  String? _generationError;

  // --- NEW: Filter State ---
  SortBy _sortBy = SortBy.newest;
  String? _filterGenre;

  HomeProvider({HomeRepository? repo, Box<Story>? storiesBox})
      : _repo = repo ?? HomeRepository(),
        _storiesBox = storiesBox ?? Hive.box<Story>('storiesBox') {
    loadStories();
  }

  // --- Getters ---
  String? get selectedGenre => _selectedGenre;
  String? get selectedTone => _selectedTone;
  String? get selectedLanguage => _selectedLanguage;
  Uint8List? get selectedImage => _selectedImage;
  String? get selectedSampleUrl => _selectedSampleUrl;
  bool get isGeneratingStory => _isGeneratingStory;
  String? get generationError => _generationError;

  // NEW: Getter for the filtered and sorted list of stories.
  List<Story> get filteredStories {
    List<Story> filtered = List.from(stories);

    if (_filterGenre != null) {
      filtered = filtered.where((story) => story.metadata.genre == _filterGenre).toList();
    }

    switch (_sortBy) {
      case SortBy.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortBy.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return filtered;
  }

  String? get filterGenre => _filterGenre;
  SortBy get sortBy => _sortBy;

  void loadStories() {
    stories = _storiesBox.values.toList().cast<Story>();
    stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> _saveStory(Story story) async {
    await _storiesBox.put(story.id, story);
  }

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

  // --- NEW: Filter Methods ---
  void setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void setFilterGenre(String? genre) {
    if (_filterGenre == genre) {
      _filterGenre = null;
    } else {
      _filterGenre = genre;
    }
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
      final newStory = result.story!;
      stories.insert(0, newStory);
      await _saveStory(newStory);
      _isGeneratingStory = false;
      notifyListeners();
      return newStory;
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
    notifyListeners();
  }
}
