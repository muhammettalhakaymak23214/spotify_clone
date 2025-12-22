import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/services/base_service.dart';

abstract class ICreatePlaylistService {}

class CreatePlaylistService extends BaseService
    implements ICreatePlaylistService {
  CreatePlaylistService() : super();

  final String defaultDescription = "Yeni oluşturulan çalma listesi";

  Future<String> createPlaylist(String userId, String name) async {
    try {
      final response = await dio.post(
        'users/$userId/playlists',
        data: {
          'name': name,
          'description': defaultDescription,
          'public': false,
        },
      );

      if (response.statusCode == HttpStatus.created) {
        final String _id = response.data["id"];
        return _id;
      }
    } on DioException catch (exception) {
      logError(exception, "createPlaylist");
    }
    return "null";
  }
}
