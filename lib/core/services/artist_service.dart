import 'package:dio/dio.dart';
import 'package:spotify_clone/models/library_model.dart';


class ArtistService {
  final Dio dio = Dio();

  Future<LibraryModel?> fetchArtist(String token, String apiUrl) async {
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        return LibraryModel.fromArtistJson(response.data);
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



