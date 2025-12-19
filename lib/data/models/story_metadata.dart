class StoryMetadata {
  final String genre;
  final String tone;
  final String language;
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
