import 'story_metadata.dart';

class Story {
  final int id;
  final String createdAt;
  final String story;
  final StoryMetadata metadata;
  final String user;

  Story({
    required this.id,
    required this.createdAt,
    required this.story,
    required this.metadata,
    required this.user,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      createdAt: json['createdAt'],
      story: json['story'],
      metadata: StoryMetadata.fromJson(json['metadata']),
      user: json['user'],
    );
  }
}
