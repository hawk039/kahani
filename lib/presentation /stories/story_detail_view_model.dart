import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kahani_app/data/models/story.dart';

class StoryDetailViewModel extends ChangeNotifier {
  final Story story;
  late final TextEditingController storyTextController;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  StoryDetailViewModel(this.story) {
    storyTextController = TextEditingController(text: story.story);
  }

  String get title => story.title;
  String get imageUrl => story.metadata.filename;

  void toggleEditing() {
    _isEditing = !_isEditing;
    if (!_isEditing) {
      // If cancelling edit, revert changes
      storyTextController.text = story.story;
    }
    notifyListeners();
  }

  Future<void> saveStory() async {
    if (!_isEditing) return;

    final box = Hive.box<Story>('storiesBox');
    final updatedStory = story.copyWith(story: storyTextController.text);
    await box.put(story.id, updatedStory);
    _isEditing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    storyTextController.dispose();
    super.dispose();
  }
}
