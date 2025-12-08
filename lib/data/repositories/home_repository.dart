import 'package:dio/dio.dart';
import 'dart:developer';
import '../../core/config/api_keys.dart';

class HomeRepository {
  final Dio _dio = Dio();

  /// Fetches a list of scenery photos from Unsplash.
  Future<List<String>> fetchSampleImages(int page) async {
    try {
      final response = await _dio.get(
        'https://api.unsplash.com/search/photos', // Use the search endpoint
        queryParameters: {
          'query': 'scenery', // Search for scenery
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
        // The list of photos is in the 'results' key
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
}
