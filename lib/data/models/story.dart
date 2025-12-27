import 'package:hive/hive.dart';
import 'story_metadata.dart';

part 'story.g.dart';

@HiveType(typeId: 0)
class Story {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String createdAt;

  @HiveField(2)
  final String story;

  @HiveField(3)
  final StoryMetadata metadata;

  @HiveField(4)
  final String user;

  @HiveField(5) // New field
  final String title;

  Story({
    required this.id,
    required this.createdAt,
    required this.story,
    required this.metadata,
    required this.user,
    required this.title, // Added to constructor
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      createdAt: json['createdAt'],
      story: json['story'],
      metadata: StoryMetadata.fromJson(json['metadata']),
      user: json['user'],
      title: json['title'] ?? 'Untitled Story', // Added parsing for the new title
    );
  }
}
