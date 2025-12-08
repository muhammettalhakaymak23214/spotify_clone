import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class IPlayerService {
  Future<List<String?>?> searchTrack(String query);
}

class PlayerService implements IPlayerService {
  final String baseUrl = "https://api.deezer.com";

  late final Dio _dio;

  PlayerService() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  Future<List<String?>?> searchTrack(String query) async {
    try {
      final encodedQuery = Uri.encodeQueryComponent(query);
      final response = await _dio.get(
        "/search",
        queryParameters: {"q": encodedQuery},
      );

      if (response.statusCode == HttpStatus.ok && response.data != null) {
        final dataList = response.data['data'] as List;

        if (dataList.isEmpty) return null;

        final List<String?> previewUrlAndImage = [];
        previewUrlAndImage.add(dataList[0]['preview'] as String?);
        previewUrlAndImage.add(dataList[0]['album']["cover_big"] as String?);

        if (previewUrlAndImage.isEmpty) {
          return null;
        }

        return previewUrlAndImage;
      }

      debugPrint("Deezer API hata: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Deezer Search Error: $e");
      return null;
    }
  }
}
