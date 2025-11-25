import 'package:dio/dio.dart';
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
        print('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching playlist: $e');
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
        print('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching playlist: $e');
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
        print('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching playlist: $e');
      return null;
    }
  }
}
