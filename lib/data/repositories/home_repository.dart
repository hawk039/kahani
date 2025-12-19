import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../../core/config/api_keys.dart';
import '../models/generate_story_result.dart';
import '../models/story.dart';
import '../network/api_client.dart';

class HomeRepository {
  final Dio _unsplashDio = Dio();
  final Dio _kahaniDio = ApiClient.dio;

  String _getErrorMessage(DioException e) {
    if (e.response?.data is Map) {
      return e.response!.data['detail'] ?? 'Something went wrong';
    }
    return e.response?.data?.toString() ?? 'Something went wrong';
  }

  Future<List<String>> fetchSampleImages(int page) async {
    try {
      final response = await _unsplashDio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {
          'query': 'scenery',
          'page': page,
          'per_page': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Client-ID ${ApiKeys.unsplashAccessKey}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> photos = response.data['results'];
        return photos.map((photo) => photo['urls']['regular'] as String).toList();
      } else {
        log('Failed to load images: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('Error fetching images: ${e.message}');
      return [];
    } catch (e) {
      log('An unexpected error occurred: ${e.toString()}');
      return [];
    }
  }

  // This method is removed as the endpoint does not exist.
  // Future<List<Story>> fetchAllStories() async { ... }

  Future<GenerateStoryResult> generateStory({
    required String genre,
    required String tone,
    required String language,
    required Uint8List imageBytes,
  }) async {
    try {
      final box = Hive.box('authBox');
      final String? token = box.get('token');

      if (token == null || token.isEmpty) {
        return GenerateStoryResult(ok: false, error: 'Not authenticated', statusCode: 401);
      }

      final formData = FormData.fromMap({
        'genre': genre,
        'tone': tone,
        'language': language,
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: 'story_image.jpg',
        ),
      });

      final response = await _kahaniDio.post(
        '/generate-story/generate',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          // Increase timeout for this specific request
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final story = Story.fromJson(response.data);
      return GenerateStoryResult(
        ok: true,
        story: story,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return GenerateStoryResult(
        ok: false,
        error: _getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      log(e.toString());
      return GenerateStoryResult(ok: false, error: 'An unexpected error occurred.');
    }
  }
}
