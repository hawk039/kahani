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

  Future<Uint8List?> downloadImageAsBytes(String url) async {
    try {
      final response = await Dio().get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      log('Failed to download sample image: $e');
      return null;
    }
  }

  Future<List<String>> fetchSampleImages(int page) async {
    try {
      final response = await _unsplashDio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {'query': 'scenery', 'page': page, 'per_page': 10},
        options: Options(
          headers: {'Authorization': 'Client-ID ${ApiKeys.unsplashAccessKey}'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> photos = response.data['results'];
        return photos
            .map((photo) => photo['urls']['regular'] as String)
            .toList();
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

  Future<List<Story>> getMyStories({required int page, required int limit}) async {
    try {
      final box = Hive.box('authBox');
      final String? token = box.get('token');

      if (token == null || token.isEmpty) {
        log('Authentication token not found.');
        return [];
      }

      final response = await _kahaniDio.get(
        '/generate-story/my-stories',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data["data"] is List) {
        final List<dynamic> data = response.data["data"];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        log('Failed to load stories: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('Error fetching stories: ${_getErrorMessage(e)}');
      return [];
    } catch (e) {
      log('An unexpected error occurred: ${e.toString()}');
      return [];
    }
  }

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
        return GenerateStoryResult(
          ok: false,
          error: 'Not authenticated',
          statusCode: 401,
        );
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
            // Set the correct content type for file uploads
            'Content-Type': 'multipart/form-data',
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
      return GenerateStoryResult(
        ok: false,
        error: 'An unexpected error occurred.',
      );
    }
  }
}