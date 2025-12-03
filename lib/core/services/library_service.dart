import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/constants/api_endpoints.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/library_model.dart';

abstract class ILibraryService {
  Future<List<AlbumItem>?> fetchAlbum();
  Future<List<ArtistItem>?> fetchArtist();
  Future<List<PlaylistItem>?> fetchPlaylists();
  Future<List<PodcastItem>?> fetchPodcast();
}

class LibraryService extends BaseService implements ILibraryService {
  LibraryService() : super();

  @override
  Future<List<AlbumItem>?> fetchAlbum() async {
    try {
      final response = await dio.get(Endpoint.album.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => AlbumItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchAlbum");
    }
    return null;
  }

  @override
  Future<List<ArtistItem>?> fetchArtist() async {
    try {
      final response = await dio.get(Endpoint.artist.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['artists']['items'];
        if (items is List) {
          return items.map((e) => ArtistItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchArtist");
    }
    return null;
  }

  @override
  Future<List<PlaylistItem>?> fetchPlaylists() async {
    try {
      final response = await dio.get(Endpoint.playlist.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => PlaylistItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchPlaylists");
    }
    return null;
  }

  @override
  Future<List<PodcastItem>?> fetchPodcast() async {
    try {
      final response = await dio.get(Endpoint.podcast.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => PodcastItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "fetchPodcast");
    }
    return null;
  }
}
