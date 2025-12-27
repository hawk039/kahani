import 'package:intl/intl.dart';
import 'package:kahani_app/data/models/story.dart';

class StoryCardViewModel {
  final Story _story;

  StoryCardViewModel(this._story);

  // Expose the raw story model if needed for navigation
  Story get story => _story;

  // All presentation logic is now contained within the ViewModel
  String get title => _story.title;
  
  String get subtitle {
    try {
      final dateTime = DateTime.parse(_story.createdAt);
      final formattedDate = DateFormat.yMMMd().format(dateTime);
      return '${_story.metadata.genre} | Created: $formattedDate';
    } catch (e) {
      // Fallback in case the date format from the backend is ever incorrect
      return '${_story.metadata.genre}';
    }
  }

  String get description {
    final firstParagraph = _story.story.split('\n\n').first;
    return '$firstParagraph...';
  }

  String get wordCount => '${_story.story.split(' ').length} Words';
  
  String get imageUrl => _story.metadata.filename;
}
