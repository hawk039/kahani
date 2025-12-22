import 'package:hive/hive.dart';

part 'story_metadata.g.dart'; // Part directive for generated code

@HiveType(typeId: 1) // Unique typeId for this model
class StoryMetadata {
  @HiveField(0) // Index 0
  final String genre;

  @HiveField(1) // Index 1
  final String tone;

  @HiveField(2) // Index 2
  final String language;

  @HiveField(3) // Index 3
  final String filename;

  StoryMetadata({
    required this.genre,
    required this.tone,
    required this.language,
    required this.filename,
  });

  factory StoryMetadata.fromJson(Map<String, dynamic> json) {
    return StoryMetadata(
      genre: json['genre'] ?? 'Unknown',
      tone: json['tone'] ?? 'Unknown',
      language: json['language'] ?? 'Unknown',
      filename: json['filename'] ?? '',
    );
  }
}
