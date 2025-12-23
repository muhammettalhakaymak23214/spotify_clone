import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/recently_played_model.dart';

abstract class IRecentlyPlayedService {
  Future<List<RecentlyPlayedTarckModel>?> getRecetlyPlayed({
    required String url,
  });
}

class RecentlyPlayedService extends BaseService
    implements IRecentlyPlayedService {
  RecentlyPlayedService() : super();

  @override
  Future<List<RecentlyPlayedTarckModel>?> getRecetlyPlayed({
    required String url,
  }) async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];

        if (items is List) {
          debugPrint("${items.length}");
          return items
              .map((e) => RecentlyPlayedTarckModel.fromJson(e))
              .toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "getRecetlyPlayed");
    }
    return null;
  }
}
