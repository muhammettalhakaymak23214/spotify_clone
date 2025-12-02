import 'package:dio/dio.dart';
import 'package:spotify_clone/core/network/queued_token_interceptor.dart';

class DioClient {
  final String _baseUrl = "https://api.spotify.com/v1/";
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    dio.interceptors.add(QueuedTokenInterceptor());
  }
}
