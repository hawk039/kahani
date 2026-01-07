import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/generate_story_result.dart';
import '../../../data/models/story.dart';
import '../../../data/repositories/home_repository.dart';

enum SortBy { newest, oldest }

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repo;
  final Box<Story> _storiesBox;

  // --- State ---
  List<Story> stories = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  int _page = 1;

  // --- Filter and Sort State ---
  String _searchQuery = '';
  SortBy _sortBy = SortBy.newest;
  String? _filterGenre;

  // --- Navigation State ---
  int _selectedIndex = 1; // Add this for navigation

  // --- Other existing states ---
  String? _selectedGenre;
  String? _selectedTone;
  String? _selectedLanguage;
  Uint8List? _selectedImage;
  String? _selectedSampleUrl;
  List<String> sampleImages = [];
  int _currentPage = 1;
  bool _isFetchingImages = false;
  bool _isGeneratingStory = false;
  String? _generationError;

  HomeProvider({HomeRepository? repo, Box<Story>? storiesBox})
      : _repo = repo ?? HomeRepository(),
        _storiesBox = storiesBox ?? Hive.box<Story>('storiesBox');

  // --- Getters ---
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String? get selectedGenre => _selectedGenre;
  String? get selectedTone => _selectedTone;
  String? get selectedLanguage => _selectedLanguage;
  Uint8List? get selectedImage => _selectedImage;
  String? get selectedSampleUrl => _selectedSampleUrl;
  bool get isGeneratingStory => _isGeneratingStory;
  String? get generationError => _generationError;
  String? get filterGenre => _filterGenre;
  SortBy get sortBy => _sortBy;
  int get selectedIndex => _selectedIndex; // Add this getter

  List<Story> get filteredStories {
    List<Story> filtered = List.from(stories);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((story) {
        final titleMatch = story.title.toLowerCase().contains(_searchQuery.toLowerCase());
        final storyMatch = story.story.toLowerCase().contains(_searchQuery.toLowerCase());
        return titleMatch || storyMatch;
      }).toList();
    }

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

  // --- UI Actions & State Management ---
  void setTabIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<Uint8List?> downloadImage(String url) async {
    return await _repo.downloadImageAsBytes(url);
  }

  Future<void> fetchStories({bool isInitial = false}) async {
    if (!isInitial && (_isFetchingMore || !_hasMore)) return;

    if (isInitial) {
      _page = 1;
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    } else {
      _isFetchingMore = true;
      notifyListeners();
    }

    final newStories = await _repo.getMyStories(page: _page, limit: 10);

    if (isInitial) {
      stories.clear();
      await _storiesBox.clear();
    }

    if (newStories.isNotEmpty) {
      stories.addAll(newStories);
      for (var story in newStories) {
        await _storiesBox.put(story.id, story);
      }
      _page++;
    } else {
      _hasMore = false;
    }

    if (isInitial) {
      _isLoading = false;
    } else {
      _isFetchingMore = false;
    }
    notifyListeners();
  }

  Future<void> _saveStory(Story story) async {
    await _storiesBox.put(story.id, story);
  }

  void updateStoryInList(Story updatedStory) {
    final index = stories.indexWhere((s) => s.id == updatedStory.id);
    if (index != -1) {
      stories[index] = updatedStory;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedGenre(String? genre) { _selectedGenre = genre; notifyListeners(); }
  void setSelectedTone(String? tone) { _selectedTone = tone; notifyListeners(); }
  void setSelectedLanguage(String? language) { _selectedLanguage = language; notifyListeners(); }
  void setSortBy(SortBy sortBy) { _sortBy = sortBy; notifyListeners(); }

  void setFilterGenre(String? genre) {
    _filterGenre = (_filterGenre == genre) ? null : genre;
    notifyListeners();
  }
  
  void clearGenerationError() {
    _generationError = null;
    notifyListeners();
  }

  // --- Image & Story Generation ---
  void setActiveLocalImage() {
    if (_selectedSampleUrl != null) {
      _selectedSampleUrl = null;
      notifyListeners();
    }
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
    notifyListeners();
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
       // Switch to stories tab after generation
      setTabIndex(1);
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
