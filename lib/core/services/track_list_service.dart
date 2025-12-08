import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/track_list_model.dart';
import 'package:spotify_clone/models/user_model.dart';

abstract class ITrackListService {
  Future<List<TrackItem>> getAlbumTracks(String albumId);
  Future<List<TrackItem>> getPlaylistTracks(String playlistId);
  Future<List<TrackItem>> getArtistTopTracks(
    String artistId, {
    String market = 'US',
  });
  Future<List<TrackItem>> getPodcastEpisodes(String showId);
  Future<UserModel?> getProfileImage(String id , String type);
}

class TrackListService extends BaseService implements ITrackListService {
  TrackListService() : super();

  @override
  Future<List<TrackItem>> getAlbumTracks(String albumId) async {
    final response = await dio.get('albums/$albumId/tracks?limit=50');
    final items = response.data['items'] as List<dynamic>;
    final tracks = TrackItem.listFromJson(items);

    return tracks;
  }

  Future<DetailModel> getDetail(String playlistId , String type ) async {
    final response = await dio.get('$type/$playlistId');
    final data = response.data;
    return DetailModel.fromJson(data);
  }

  @override
  Future<List<TrackItem>> getPlaylistTracks(String playlistId) async {
    final response = await dio.get('playlists/$playlistId');
    final items = response.data["tracks"]['items'] as List<dynamic>;
    return TrackItem.listFromJson(items);
  }

  @override
  Future<List<TrackItem>> getArtistTopTracks(
    String artistId, {
    String market = 'US',
  }) async {
    final response = await dio.get(
      'artists/$artistId/top-tracks',
      queryParameters: {'market': market},
    );
    final items = response.data['tracks'] as List<dynamic>;
    return TrackItem.listFromJson(items);
  }

  @override
  Future<List<TrackItem>> getPodcastEpisodes(String showId) async {
    final response = await dio.get('shows/$showId/episodes?limit=50');
    final items = response.data['items'] as List<dynamic>;
    return TrackItem.listFromJson(items);
  }
  
  @override
  Future<UserModel?> getProfileImage(String id , String type) async {
    final response = await dio.get('$type/$id');
    final user = response.data;
    return UserModel.fromJson(user);
  }
}
