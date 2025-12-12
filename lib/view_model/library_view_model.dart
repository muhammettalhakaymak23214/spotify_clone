import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/core/helpers/song_data_manager.dart';
import 'package:spotify_clone/core/services/library_service.dart';
import 'package:spotify_clone/core/services/player_service.dart';
import 'package:spotify_clone/models/library_model.dart';
import 'package:spotify_clone/models/player_model.dart';

class LibraryViewModel {
  //Services
  final LibraryService libraryService = LibraryService();
  final PlayerService playerService = PlayerService(); //-------------
  //items
  final ObservableList<LibraryItem> items = ObservableList<LibraryItem>();
  //isLoadings
  final Observable<bool> isLoadingArtist = Observable(false);
  final Observable<bool> isLoadingPlaylist = Observable(false);
  final Observable<bool> isLoadingAlbum = Observable(false);
  final Observable<bool> isLoadingPodcast = Observable(false);
  final Observable<bool> isDownloaded = Observable(false);



  ObservableList<Map<String, dynamic>> songs =
      ObservableList<Map<String, dynamic>>();

  LibraryViewModel();

  Future<void> delete(var id) async {
    debugPrint("[delete] : Start");
    await SongDataManager().deleteSongById(id);
    songs.clear();
    songs.addAll(await SongDataManager().loadSongsFromPrefs());
    runInAction(() {});
    debugPrint("[delete] : End");
  }

  Future<void> loadSongs() async {
    debugPrint("[loadSongs] : Start");
    runInAction(() {
      isDownloaded.value = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('downloaded_songs');

    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);

      runInAction(() {
        //isDownloaded.value = true;
        songs.clear();
        songs.addAll(
          jsonData.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
      });
      debugPrint("[loadSongs] : End");
    }
  }

  //******************************** */
  Future<void> fetchPodcast() async {
    if (isLoadingPodcast.value) {
      return;
    }
    runInAction(() {
      isLoadingPodcast.value = true;
    });
    final data = await libraryService.fetchPodcast();
    runInAction(() {
      if (data != null) {
        items.addAll(data);
      } else {
        debugPrint("-- fetchPodcast : data null --");
      }
    });
    runInAction(() {
      isDownloaded.value = false;
      isLoadingPodcast.value = false;
    });
  }

  Future<void> fetchPlaylist() async {
    if (isLoadingPlaylist.value) {
      return;
    }
    runInAction(() {
      isLoadingPlaylist.value = true;
    });
    final data = await libraryService.fetchPlaylists();
    runInAction(() {
      if (data != null) {
        items.addAll(data);
      } else {
        debugPrint("-- fetchPlaylist : data null --");
      }
    });
    runInAction(() {
      isDownloaded.value = false;
      isLoadingPlaylist.value = false;
    });
  }

  Future<void> fetchArtist() async {
    if (isLoadingArtist.value) {
      return;
    }
    runInAction(() {
      isLoadingArtist.value = true;
    });
    final data = await libraryService.fetchArtist();
    runInAction(() {
      if (data != null) {
        items.addAll(data);
      } else {
        debugPrint("-- fetchArtis : data null --");
      }
    });
    runInAction(() {
      isDownloaded.value = false;
      isLoadingArtist.value = false;
    });
  }

  Future<void> fetchAlbum() async {
    if (isLoadingAlbum.value) {
      return;
    }
    runInAction(() {
      isLoadingAlbum.value = true;
    });
    final data = await libraryService.fetchAlbum();
    runInAction(() {
      if (data != null) {
        items.addAll(data);
      } else {
        debugPrint("-- fetchAlbum : data null --");
      }
    });
    runInAction(() {
      isDownloaded.value = false;
      isLoadingAlbum.value = false;
    });
  }
}
