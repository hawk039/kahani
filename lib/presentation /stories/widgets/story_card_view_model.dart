import 'package:kahani_app/data/models/story.dart';

class StoryCardViewModel {
  final Story _story;

  StoryCardViewModel(this._story);

  // Expose the raw story model if needed for navigation
  Story get story => _story;

  // All presentation logic is now contained within the ViewModel
  String get title => "A tale of ${_story.metadata.genre}";
  String get subtitle => '${_story.metadata.genre} | Created: ${_story.createdAt}';
  String get description {
    final firstParagraph = _story.story.split('\n\n').first;
    return '$firstParagraph...';
  }
  String get wordCount => '${_story.story.split(' ').length} Words';
  
  // Reverted to the clean URL
  String get imageUrl => _story.metadata.filename;
}
