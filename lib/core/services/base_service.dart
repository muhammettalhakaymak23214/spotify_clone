import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/core/network/token_manager.dart';

class BaseService {
  
  final Dio dio;
  
  BaseService()
    : dio = Dio(BaseOptions(baseUrl: 'https://api.spotify.com/v1/'));

 Future<Options> authHeader() async {
    final token = await TokenManager().getToken();
    return Options(
      headers: {
        "Authorization": "Bearer $token", 
        "Content-Type": "application/json",
      },
    );
  }

  void logError(dynamic error, String serviceName) {
    if (kDebugMode) {
      print("[$serviceName] Error: $error");
    }
  }

}
