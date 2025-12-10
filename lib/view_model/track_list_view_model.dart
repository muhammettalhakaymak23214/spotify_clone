import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/palette_helper.dart';
import 'package:spotify_clone/core/services/player_service.dart';
import 'package:spotify_clone/core/services/track_list_service.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/models/track_list_model.dart';
import 'package:spotify_clone/models/user_model.dart';

class TrackListViewModel {
  //Services
  final TrackListService _trackListService = TrackListService();
  final PlayerService playerService = PlayerService();
  //Observale
  ObservableList<TrackItem> tracks = ObservableList<TrackItem>();
  Observable<UserModel?> user = Observable(null);
  Observable<DetailModel?> detail = Observable(null);
  Observable<String> duration = Observable<String>("");
  Observable<bool> isLoading = Observable<bool>(false);
  Observable<Color> bgColor = Observable<Color>(Colors.black);

  Future<void> updateBackground(String imageUrl) async {
    final color = await PaletteHelper.getBackgroundColor(imageUrl);

    runInAction(() {
      bgColor.value = color;
    });
  }

  void loadDataForType(MediaType type, String id) {
    switch (type) {
      case MediaType.album:
        loadAlbumTracks(id);
        loadDetail(id, "albums");
        break;
      case MediaType.playlist:
        loadPlaylistTracks(id);
        loadDetail(id, "playlists");
        break;
      case MediaType.artist:
        loadArtistTopTracks(id, market: "TR");
        loadUser(id, "artists");
        break;
      case MediaType.show:
        loadPodcastEpisodes(id);
        break;
      default:
        debugPrint("[loadDataForType] Bilinmeyen type : $type");
    }
  }

  Future<void> loadDetail(String id, String type) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final data = await _trackListService.getDetail(id, type);
      runInAction(() {
        detail.value = data;
      });
      if (type == "playlists") {
        loadUser(data.ownerId, "users");
      }
      else if(type == "albums"){
        loadUser(data.ownerId, "artists");
      }
      else if (type == "artists"){
        loadUser(data.ownerId, "artists");
      }
    } catch (e) {
      debugPrint("[loadDetail]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> loadUser(String id, String type) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final data = await _trackListService.getProfileImage(id, type);
      runInAction(() {
        user.value = data;
      });
    } catch (e) {
      debugPrint("[loadUser]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> loadAlbumTracks(String albumId) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final albumTracks = await _trackListService.getAlbumTracks(albumId);
      tracks.clear();
      tracks.addAll(albumTracks);
    } catch (e) {
      debugPrint("[loadAlbumTracks]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> loadPlaylistTracks(String playlistId) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final playlistTracks = await _trackListService.getPlaylistTracks(
        playlistId,
      );
      tracks.clear();
      tracks.addAll(playlistTracks);
    } catch (e) {
      debugPrint("[loadPlaylistTracks]: $e");
    } finally {
      runInAction(() {
        getTotalDuration();
        isLoading.value = false;
      });
    }
  }

  Future<void> loadArtistTopTracks(
    String artistId, {
    String market = 'US',
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final artistTopTracks = await _trackListService.getArtistTopTracks(
        artistId,
        market: market,
      );
      tracks.clear();
      tracks.addAll(artistTopTracks);
    } catch (e) {
      debugPrint("[loadArtistTopTracks]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> loadPodcastEpisodes(String showId) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final podcastEpisodes = await _trackListService.getPodcastEpisodes(
        showId,
      );
      tracks.clear();
      tracks.addAll(podcastEpisodes);
    } catch (e) {
      debugPrint("[loadPodcastEpisodes]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<PlayTrackItem> getTrackWithPreview(TrackItem spotifyTrack) async {
    final previewUrl = await playerService.searchTrack(
      'artist:"${spotifyTrack.artistsName!.join(", ")}" track:"${spotifyTrack.name}"',
    );

    final track = PlayTrackItem(
      id: spotifyTrack.id,
      trackName: spotifyTrack.name,
      artistName: spotifyTrack.artistsName?.join(", "),
      albumImage: spotifyTrack.albumImage ??  previewUrl?.last , 
      previewUrl: previewUrl?.first ?? "",
    );

    return track;
  }

  void getTotalDuration() {
    int totalMs = 0;

    for (var item in tracks) {
      totalMs += item.durationMs!;
    }

    int totalMinutes = totalMs ~/ 60000;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      duration.value = "$hours sa $minutes dk";
    } else {
      duration.value = "$minutes dk";
    }
  }
}
