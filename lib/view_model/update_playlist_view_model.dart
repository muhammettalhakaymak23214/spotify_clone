import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/update_playlist_service.dart';
import 'package:spotify_clone/models/playlist_model.dart';
import 'package:spotify_clone/models/track_model.dart';

class UpdatePlaylistViewModel {
  //Services
  final UpdatePlaylistService _updatePlaylistService = UpdatePlaylistService();
  //Observable
  ObservableList<TrackModel> tracks = ObservableList<TrackModel>();
  ObservableList<TrackModel> playlistInTracks = ObservableList<TrackModel>();
  Observable<PlaylistModel?> playlistDetail = Observable<PlaylistModel?>(null);
  Observable<String> playlistCoverImage = Observable<String>("");
  Observable<String> playlistName = Observable<String>("");
  Observable<String> playlistDesciription = Observable<String>("");
  Observable<bool> playlistIscollaborative = Observable<bool>(true);
  Observable<bool> isLoading = Observable<bool>(false);
  //Variables
  bool isPressedAdd = false;
  bool isPressedRemove = false;
  int offset = 0;
  int count = 0;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<void> deletePlaylist({required String playlistId}) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      await _updatePlaylistService.deletePlaylist(playlistId: playlistId);
    } catch (e) {
      debugPrint("[deletePlaylist]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> getPlaylistTracks({required String playlistId}) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final responseTracks = await _updatePlaylistService.getPlaylistTracks(
        playlistId: playlistId,
      );
      playlistInTracks.clear();
      playlistInTracks.addAll(responseTracks);
    } catch (e) {
      debugPrint("[getPlaylistTracks: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> getPlaylistDetail({required String playlistId}) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final data = await _updatePlaylistService.getPlaylistDetail(
        playlistId: playlistId,
      );
      runInAction(() {
        playlistCoverImage.value = data?.playlistCoverImage ?? "";
        playlistName.value = data?.playlistName ?? "";
        playlistDesciription.value = data?.playlistDesciription ?? "";
        playlistIscollaborative.value = data?.collaborative ?? true;
      });
    } catch (e) {
      debugPrint("[getPlaylistDetail]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> deleteTracksToPlaylist({
    required String playlistId,
    required String trackUri,
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
     
      
      await _updatePlaylistService.deleteTracksToPlaylist(
        playlistId: playlistId,
        trackUri: trackUri,
      );
    } catch (e) {
      debugPrint("[deleteTracksToPlaylist]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> addTracksToPlaylist({
    required String playlistId,
    required List<String> trackUris,
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {

      
      await _updatePlaylistService.addTracksToPlaylist(
        playlistId: playlistId,
        trackUris: trackUris,
      );
    } catch (e) {
      debugPrint("[addTracksToPlaylist]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> getUserTopTracks({
    required int consumedCount,
    required int limit,
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    final offset = tracks.length + consumedCount;
    try {
      final responseTracks = await _updatePlaylistService.getUserTopTracks(
        limit: limit,
        offset: offset,
      );
      tracks.addAll(responseTracks);
    } catch (e) {
      debugPrint("[getUserTopTracks]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> updatePlaylistCover({
    required String playlistId,
    required File imageFile,
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      await _updatePlaylistService.updatePlaylistCoverImage(
        playlistId: playlistId,
        imageFile: imageFile,
      );
    } catch (e) {
      debugPrint("[updatePlaylistCover]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> deletePlaylistCoverImage({required String playlistId}) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      await _updatePlaylistService.deletePlaylistCoverImage(
        playlistId: playlistId,
      );
    } catch (e) {
      debugPrint("[deleteTracksToPlaylist]: $e");
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<bool> changePlaylistCollaborative({
    required String playlistId,
    required bool playlistIsCollaborative,
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final isSuccesfull = await _updatePlaylistService
          .changePlaylistCollaborative(
            playlistId: playlistId,
            playlistIsCollaborative: playlistIsCollaborative,
          );
      return isSuccesfull;
    } catch (e) {
      debugPrint("[changePlaylistVisibility]: $e");
      return false;
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }

  Future<bool> changePlaylistNameAndDesciription({
    required String playlistId,
    required String name,
    required String desciription,
  }) async {
    runInAction(() {
      isLoading.value = true;
    });
    try {
      final isSuccesfull = await _updatePlaylistService
          .changePlaylistNameAndDesciription(
            playlistId: playlistId,
            name: name,
            desciription: desciription,
          );
      return isSuccesfull;
    } catch (e) {
      debugPrint("[changePlaylistNameAndDesciription]: $e");
      return false;
    } finally {
      runInAction(() {
        isLoading.value = false;
      });
    }
  }
}
