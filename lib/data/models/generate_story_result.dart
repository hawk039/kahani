import '../models/story.dart';

class GenerateStoryResult {
  final bool ok;
  final String? error;
  final Story? story; // Changed from String? to Story?
  final int? statusCode;

  GenerateStoryResult({
    required this.ok,
    this.error,
    this.story, // Changed
    this.statusCode,
  });
}
