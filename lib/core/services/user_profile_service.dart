import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/enums/endpoint.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/user_profile_model.dart';

abstract class IUserProfileService {}

class UserProfileService extends BaseService implements IUserProfileService {
  UserProfileService() : super();

  Future<UserProfileModel?> getUserProfile() async {
    try {
      final response = await dio.get(Endpoint.me.path);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;
        return UserProfileModel.fromJson(data);
      }
    } on DioException catch (exception) {
      logError(exception, "getUserProfile");
    }
    return null;
  }

  Future<String> getTotalPlaylist() async {
    try {
      final response = await dio.get(Endpoint.playlist.path);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data['total'];
        return "$data";
      }
    } on DioException catch (exception) {
      logError(exception, "getTotalPlaylist");
    }
    return "";
  }
}
