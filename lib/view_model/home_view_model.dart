import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/home_service.dart';
import 'package:spotify_clone/models/home_model.dart';

class HomeViewModel {
  //Services
  final HomeService homeService = HomeService();
  //items
  final ObservableList<PlaylistItem> itemsPlaylist =
      ObservableList<PlaylistItem>();
  final ObservableList<NewReleasesItem> itemsNewReleases =
      ObservableList<NewReleasesItem>();
  final ObservableList<UserTopArtistsItem> itemsUserTopArtists =
      ObservableList<UserTopArtistsItem>();

  HomeViewModel();

  Future<void> fetchUserTopArtists() async {
    final data = await homeService.fetchUserTopArtists();
    runInAction(() {
      if (data != null) {
        itemsUserTopArtists.clear();
        itemsUserTopArtists.addAll(data);
      } else {
        debugPrint("-- fetchUserTopArtists : data null --");
      }
    });
  }

  Future<void> fetchNewReleases() async {
    final data = await homeService.fetchNewReleases();
    runInAction(() {
      if (data != null) {
        itemsNewReleases.clear();
        itemsNewReleases.addAll(data);
      } else {
        debugPrint("-- fetchNewReleases : data null --");
      }
    });
  }

  Future<void> fetchPlaylist() async {
    final data = await homeService.fetchPlaylist();
    runInAction(() {
      if (data != null) {
        itemsPlaylist.clear();
        itemsPlaylist.addAll(data);
      } else {
        debugPrint("-- fetchPlaylist : data null --");
      }
    });
  }
}
