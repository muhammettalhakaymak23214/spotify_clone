import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/enums/endpoint.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/recently_played_model.dart';

abstract class IRecentlyPlayedService {
  Future<List<RecentlyPlayedTarckModel>?> fetchRecentlyPlayed();

}

class RecentlyPlayedService extends BaseService
    implements IRecentlyPlayedService {
  RecentlyPlayedService() : super();

  @override
  Future<List<RecentlyPlayedTarckModel>?> fetchRecentlyPlayed() async {
    try {
      final response = await dio.get(Endpoint.recentlyPlayed.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => RecentlyPlayedTarckModel.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "RecentlyPlayedService");
    }
    return null;
  }
 
}