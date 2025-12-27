import 'package:hive/hive.dart';

part 'story_metadata.g.dart';

@HiveType(typeId: 1)
class StoryMetadata {
  @HiveField(0)
  final String genre;

  @HiveField(1)
  final String tone;

  @HiveField(2)
  final String language;

  // This field will now hold the full URL
  @HiveField(3)
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
      // MODIFIED: Assign the 'image_url' from JSON to our 'filename' field
      filename: json['image_url'] ?? '', 
    );
  }
}
