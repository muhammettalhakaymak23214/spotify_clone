import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/services/home_service.dart';
import 'package:spotify_clone/models/home_model.dart';

class HomeViewModel {
  //Services
  final HomeService homeService = HomeService();
  //items
  final ObservableList<HomeItem> itemsPlaylist = ObservableList<HomeItem>();
  final ObservableList<HomeItem> itemsNewReleases = ObservableList<HomeItem>();
  final ObservableList<HomeItem> itemsUserTopArtists = ObservableList<HomeItem>();
  //dio
  final Dio dio = Dio();
  //token
  final String token;

  HomeViewModel({required this.token});


  Future<void> fetchUserTopArtists() async {
    try {
      final userTopArtists = await homeService.fetchUserTopArtists(
        token,
        AppStrings.apiUrlUserTopArtists,
      );
      runInAction(() {
        if (userTopArtists != null) {
          itemsUserTopArtists.addAll(userTopArtists.homeItem ?? []);
        }
      });
    } catch (e) {
     debugPrint("$e");
    } finally {}
  }

  Future<void> fetchNewReleases() async {
    try {
      final newReleases = await homeService.fetchNewReleases(
        token,
        AppStrings.apiUrlNewReleases,
      );
      runInAction(() {
        if (newReleases != null) {
          itemsNewReleases.addAll(newReleases.homeItem ?? []);
        }
      });
    } catch (e) {
      debugPrint("$e");
    } finally {}
  }

  Future<void> fetchPlaylist() async {
    try {
      final playlist = await homeService.fetchPlaylists(
        token,
        AppStrings.apiUrlPlaylist,
      );
      runInAction(() {
        if (playlist != null) {
          itemsPlaylist.addAll(playlist.homeItem ?? []);
        }
      });
    } catch (e) {
      debugPrint("$e");
    } finally {}
  }
}
