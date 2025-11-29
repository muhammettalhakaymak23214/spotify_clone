import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/network/token_manager.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _clientId = '2fd827b6a9814e198eb7aff43e976b7d';
  final String _clientSecret = '978cb5c004854d25b18be6dd3f201137';
  final String _refreshToken =
      'AQCJiiyzRebLpPG_TJ6oeg5s1phiUB1EJYer5rUfrMBxM_HmX9j7swVILYMhEGPwYHXnQqDLFsyE4AEaBQnni57kJqLI9WW3JstXaGCijiYQqqo-sFWUsUpg2tZTqkf5sWM';

  Future<String?> refreshAccessToken() async {
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_clientId:$_clientSecret'));

    try {
      final response = await _dio.post(
        'https://accounts.spotify.com/api/token',
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {'grant_type': 'refresh_token', 'refresh_token': _refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken = data['access_token'];
        TokenManager().saveToken(newAccessToken);
        return newAccessToken;
      } else {
        debugPrint('Token yenilenemedi: ${response.data}');
        return null;
      }
    } catch (error) {
      debugPrint('Hata: $error');
      return null;
    }
  }
}
