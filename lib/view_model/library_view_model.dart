import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/library_service.dart';
import 'package:spotify_clone/models/library_model.dart';

class LibraryViewModel {
  //Services
  final LibraryService libraryService = LibraryService();
  //items
  final ObservableList<LibraryItem> items = ObservableList<LibraryItem>();
  //isLoadings
  final Observable<bool> isLoadingArtist = Observable(false);
  final Observable<bool> isLoadingPlaylist = Observable(false);
  final Observable<bool> isLoadingAlbum = Observable(false);
  final Observable<bool> isLoadingPodcast = Observable(false);

  LibraryViewModel();

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
      isLoadingAlbum.value = false;
    });
  }
}
