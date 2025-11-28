import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/services/recently_played_service.dart';
import 'package:spotify_clone/core/services/search_result_service.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

class SearchDetailViewModel {
  //Services
  final RecentlyPlayedService recentlyPlayedService = RecentlyPlayedService();
  final SearchResultService searchResultService = SearchResultService();
  //items
  final ObservableList<RecentlyPlayedItem> itemsRecentlyPlayed =
      ObservableList<RecentlyPlayedItem>();
  final ObservableList<SearchResultItem> searchResults =
      ObservableList<SearchResultItem>();
  final Observable<String> query = Observable("");
  final Observable<bool> isSearching = Observable(false);
  //dio
  final Dio dio = Dio();
  //token
  final String token;

  SearchDetailViewModel({required this.token});

  Future<void> fetchRecentlyPlayed() async {
    try {
      final data = await recentlyPlayedService.fetchRecentlyPlayed(
        token,
        AppStrings.apiRecentlyPlayed,
      );
      runInAction(() {
        if (data != null) {
          itemsRecentlyPlayed
            ..clear()
            ..addAll(data.recentlyPlayedItems ?? []);
        } else {
          debugPrint("-- FetchRecentlyPlayed : data null --");
        }
      });
    } catch (error, stack) {
      debugPrint("fetchRecentlyPlayed error: $error");
      debugPrint("Stack trace: $stack");
    }
  }

  Future<void> search(String value) async {
    runInAction(() {
      query.value = value;
      isSearching.value = true;
    });
    if (value.isEmpty) {
      runInAction(() {
        searchResults.clear();
        isSearching.value = false;
      });
      return;
    }
    try {
      final data = await searchResultService.fetchSearchResult(
        token: token,
        query: query.value,
      );
      runInAction(() {
        if (data != null) {
          searchResults
            ..clear()
            ..addAll(data.searchResultItems ?? []);
        } else {
          debugPrint("-- search : data null --");
        }
        isSearching.value = false;
      });
    } catch (error,stack) {
      debugPrint("search error: $error");
      debugPrint("Stack trace: $stack");
    }
  }
}
