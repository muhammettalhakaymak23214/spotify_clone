import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/constants/api_endpoints.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/home_model.dart';

abstract class IHomeService {
  Future<List<UserTopArtistsItem>?> fetchUserTopArtists();
  Future<List<NewReleasesItem>?> fetchNewReleases();
  Future<List<PlaylistItem>?> fetchPlaylist();
}

class HomeService extends BaseService implements IHomeService {
  HomeService() : super();

  @override
  Future<List<UserTopArtistsItem>?> fetchUserTopArtists() async {
    try {
      final response = await dio.get(Endpoint.userTopArtists.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => UserTopArtistsItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchUserTopArtists");
    }
    return null;
  }

  @override
  Future<List<NewReleasesItem>?> fetchNewReleases() async {
    try {
      final response = await dio.get(Endpoint.newReleases.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['albums']['items'];
        if (items is List) {
          return items.map((e) => NewReleasesItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchNewReleasesItem");
    }
    return null;
  }

  @override
  Future<List<PlaylistItem>?> fetchPlaylist() async {
    try {
      final response = await dio.get(Endpoint.playlist.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => PlaylistItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchPlaylist");
    }
    return null;
  }
}
