import 'package:dio/dio.dart';

import '../config/env.dart';
import '../models/news_response_model.dart';
import 'api_exception.dart';

class NewsApiService {
  late final Dio _dio;

  NewsApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
  }

  Future<NewsResponseModel> getTopHeadlines({
    String country = 'id',
    String category = 'general',
  }) async {
    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'country': country,
          'category': category,
          'apikey': Env.apiKey,
        },
      );

      return NewsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<NewsResponseModel> searchNews(String query) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {'q': query, 'apikey': Env.apiKey},
      );

      return NewsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return ApiException(
            message: 'Permintaan API tidak valid.',
            statusCode: statusCode,
          );
        case 401:
          return ApiException(
            message: 'API Key tidak valid.',
            statusCode: statusCode,
          );
        case 403:
          return ApiException(
            message: 'Akses API ditolak. Periksa akun dan API Key.',
            statusCode: statusCode,
          );
        case 429:
          return ApiException(
            message: 'Batas permintaan API telah tercapai.',
            statusCode: statusCode,
          );
        case 500:
          return ApiException(
            message: 'Server GNews sedang bermasalah.',
            statusCode: statusCode,
          );
        default:
          return ApiException(
            message: 'Terjadi kesalahan pada server.',
            statusCode: statusCode,
          );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiException(
          message: 'Koneksi terlalu lama. Silakan coba lagi.',
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Tidak dapat terhubung. Periksa internet kamu.',
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Permintaan dibatalkan.');

      default:
        return ApiException(message: 'Terjadi kesalahan yang tidak diketahui.');
    }
  }
}
