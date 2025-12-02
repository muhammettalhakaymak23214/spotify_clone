import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/core/network/dio_client.dart';

abstract class BaseService {
  final Dio dio = DioClient().dio;

  void logError(dynamic error, String serviceName) {
    if (kDebugMode) {
      print("[$serviceName] Error: $error");
    }
  }
}
