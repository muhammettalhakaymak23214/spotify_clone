import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

abstract class IRecentlyPlayedService {
  Future<List<RecentlyPlayedItem>?> fetchRecentlyPlayed();
}

class RecentlyPlayedService extends BaseService
    implements IRecentlyPlayedService {
  RecentlyPlayedService() : super();

  @override
  Future<List<RecentlyPlayedItem>?> fetchRecentlyPlayed() async {
    try {
      final response = await dio.get("me/player/recently-played");

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => RecentlyPlayedItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "RecentlyPlayedService");
    }
    return null;
  }
}


