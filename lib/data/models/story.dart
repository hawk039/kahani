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
  final String title;

  Story({
    required this.id,
    required this.createdAt,
    required this.story,
    required this.metadata,
    required this.title,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      createdAt: json['createdAt'],
      story: json['story'],
      metadata: StoryMetadata.fromJson(json['metadata']),
      title: json['title'] ?? 'Untitled Story',
    );
  }

  Story copyWith({
    int? id,
    String? createdAt,
    String? story,
    StoryMetadata? metadata,
    String? title,
  }) {
    return Story(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      story: story ?? this.story,
      metadata: metadata ?? this.metadata,
      title: title ?? this.title,
    );
  }
}
