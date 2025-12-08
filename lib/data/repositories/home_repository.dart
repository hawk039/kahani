import 'package:dio/dio.dart';
import 'dart:developer';

class HomeRepository {
  final Dio _dio = Dio();
  // IMPORTANT: Replace this with your actual key, preferably from a config file.
  final String _unsplashAccessKey = "YOUR_UNSPLASH_ACCESS_KEY";

  /// Fetches a list of random photos from Unsplash.
  Future<List<String>> fetchSampleImages(int page) async {
    try {
      final response = await _dio.get(
        'https://api.unsplash.com/photos',
        queryParameters: {
          'page': page,
          'per_page': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Client-ID $_unsplashAccessKey',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> photos = response.data;
        return photos.map((photo) => photo['urls']['regular'] as String).toList();
      } else {
        log('Failed to load images: ${response.statusCode}');
        return []; // Return empty list on failure
      }
    } on DioException catch (e) {
      log('Error fetching images: ${e.message}');
      return []; // Return empty list on error
    } catch (e) {
      log('An unexpected error occurred: ${e.toString()}');
      return [];
    }
  }
}
