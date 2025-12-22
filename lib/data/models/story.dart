import 'package:hive/hive.dart';
import 'story_metadata.dart';

part 'story.g.dart'; // Part directive for generated code

@HiveType(typeId: 0) // Unique typeId for this model
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
