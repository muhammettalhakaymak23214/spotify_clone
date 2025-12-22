import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/enums/endpoint.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/playlist_model.dart';
import 'package:spotify_clone/models/track_model.dart';

abstract class IUpdatePlaylistService {}

class UpdatePlaylistService extends BaseService
    implements IUpdatePlaylistService {
  UpdatePlaylistService() : super();

  final List<TrackModel> emtyList = [];

  Future<List<TrackModel>> getPlaylistTracks({
    required String playlistId,
  }) async {
    try {
      final response = await dio.get("playlists/$playlistId/tracks");

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data["items"];
        if (items is List) {
          return items
              .map((e) => TrackModel.addedToPlaylistFromJson(e))
              .toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "addTracksToPlaylist");
    }
    return emtyList;
  }

  Future<PlaylistModel?> getPlaylistDetail({required String playlistId}) async {
    try {
      final response = await dio.get("playlists/$playlistId");

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;

        return PlaylistModel.fromJson(data);
      }
    } on DioException catch (exception) {
      logError(exception, "addTracksToPlaylist");
    }
    return null;
  }

  Future<bool> deletePlaylist({required String playlistId}) async {
    try {
      final response = await dio.delete("playlists/$playlistId/followers");

      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } on DioException catch (exception) {
      logError(exception, "deletePlaylist");
    }
    return false;
  }

  Future<bool> changePlaylistCollaborative({required String playlistId , required bool playlistIsCollaborative}) async {
    try {
      final data = {"collaborative" : playlistIsCollaborative};
      debugPrint("---------------------------------------------------------");
      final response = await dio.put("playlists/$playlistId" , data: data);

      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } on DioException catch (exception) {
      logError(exception, "changePlaylistVisibility");
    }
    return false;
  }

  Future<bool> changePlaylistNameAndDesciription({required String playlistId , required String name , required String desciription}) async {
    try {
      final data = {"name" : name , "description" : desciription};
      debugPrint("---------------------------------------------------------");
      final response = await dio.put("playlists/$playlistId" , data: data);

      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } on DioException catch (exception) {
      logError(exception, "changePlaylistNameAndDesciription");
    }
    return false;
  }

  Future<bool> deleteTracksToPlaylist({
    required String playlistId,
    required String trackUri,
    //int? position,
  }) async {
    try {
      final response = await dio.delete(
        'playlists/$playlistId/tracks',
        data: {
          "tracks": [
            {"uri": trackUri},
          ],
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } on DioException catch (exception) {
      logError(exception, "deleteTracksToPlaylist");
    }
    return false;
  }

  Future<bool> addTracksToPlaylist({
    required String playlistId,
    required List<String> trackUris,
    //int? position,
  }) async {
    try {
      final response = await dio.post(
        'playlists/$playlistId/tracks',
        data: {'uris': trackUris},
      );

      if (response.statusCode == HttpStatus.created) {
        return true;
      }
    } on DioException catch (exception) {
      logError(exception, "addTracksToPlaylist");
    }
    return false;
  }

  Future<List<TrackModel>> getUserTopTracks({
    int offset = 0,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        "me/top/tracks?limit=$limit&offset=$offset",
      );

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => TrackModel.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "getUserTopTracks");
    }
    return emtyList;
  }

  Future<bool> updatePlaylistCoverImage({
    required String playlistId,
    required File imageFile,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();

      if (bytes.lengthInBytes > 256 * 1024) {
        throw Exception("Image must be smaller than 256KB");
      }
      final base64Image = base64Encode(bytes);
      debugPrint(base64Image);
      debugPrint("Base64 image length: ${base64Image.length}");

      final response = await dio.put(
        "playlists/$playlistId/images",
        data: base64Image,
        options: Options(
          headers: {'Content-Type': 'image/jpeg'},
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == HttpStatus.accepted) {
        return true;
      }
    } on DioException catch (exception) {
      logError(exception, "getUserTopTracks");
    }
    return false;
  }

  Future<bool> deletePlaylistCoverImage({required String playlistId}) async {
    try {
      final response = await dio.delete('playlists/$playlistId/images');

      if (response.statusCode == HttpStatus.ok) {
        print("Cover image deleted successfully!");
        return true;
      } else {
        print(
          "Failed to delete cover image. Status code: ${response.statusCode}",
        );
      }
    } on DioException catch (exception) {
      logError(exception, "deletePlaylistCoverImage");
    }
    return false;
  }
}
