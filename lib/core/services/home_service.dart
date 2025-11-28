import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/models/home_model.dart';

class HomeService {
  final Dio dio = Dio();

    Future<HomeModel?> fetchUserTopArtists(String token, String apiUrl) async {
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        return HomeModel.fromUserTopArtists(response.data);
      } else {
        debugPrint('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching UserTopArtist: $e');
      return null;
    }
  }

  Future<HomeModel?> fetchNewReleases(String token, String apiUrl) async {
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        return HomeModel.fromNewReleases(response.data);
      } else {
        debugPrint('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching fetchNewReleases: $e');
      return null;
    }
  }

  Future<HomeModel?> fetchPlaylists(String token, String apiUrl) async {
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        return HomeModel.fromPlaylistJson(response.data);
      } else {
        debugPrint('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching playlist: $e');
      return null;
    }
  }
}
