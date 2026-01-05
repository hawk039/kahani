import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kahani_app/data/models/api_result.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/data/repositories/home_repository.dart';

class StoryDetailViewModel extends ChangeNotifier {
  final HomeRepository _repo = HomeRepository();
  Story story;
  late final TextEditingController storyTextController;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  // --- For API State ---
  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StoryDetailViewModel(this.story) {
    storyTextController = TextEditingController(text: story.story);
  }

  String get title => story.title;
  String get imageUrl => story.metadata.filename;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    if (!_isEditing) {
      storyTextController.text = story.story;
    }
    notifyListeners();
  }

  Future<bool> saveStory() async {
    if (!_isEditing || _isSaving) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    final updatedStory = story.copyWith(
      story: storyTextController.text,
      // The title could also be made editable in the future.
      // title: titleController.text,
    );

    final ApiResult result = await _repo.updateStory(updatedStory);

    if (result.success) {
      // --- Data is now synced with the server ---
      story = updatedStory; // Update local state
      final box = Hive.box<Story>('storiesBox');
      await box.put(story.id, story); // Update local cache

      _isEditing = false;
      _isSaving = false;
      notifyListeners();
      return true;
    } else {
      // If the API call fails, do not update the UI.
      _errorMessage = result.error ?? "Failed to save story.";
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    storyTextController.dispose();
    super.dispose();
  }
}
