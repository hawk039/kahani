import 'package:flutter/material.dart';
import 'package:kahani_app/data/models/story.dart';

class StoryDetailViewModel extends ChangeNotifier {
  final Story story;

  StoryDetailViewModel(this.story);

  // Reverted to the clean URL
  String get imageUrl => story.metadata.filename;

  // TODO: Add logic for Edit, Regenerate, Share, and Save actions here.
}
