import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/search_detail/search_detail_service.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

class SearchDetailViewModel {
  //Services
  final SearchDetailService searchDetailService = SearchDetailService();
  //items
  ObservableList<RecentlyPlayedItem> itemsRecentlyPlayed =
      ObservableList<RecentlyPlayedItem>();
  ObservableList<SearchResultItem>? searchResults =
      ObservableList<SearchResultItem>();
  final Observable<String> query = Observable("");
  final Observable<bool> isSearching = Observable(false);

  SearchDetailViewModel();

  void _changeSearching(bool isSearchingTorF) {
    runInAction(() {
      isSearching.value = isSearchingTorF;
    });
  }

  Future<void> fetchRecentlyPlayed() async {
    final data = await searchDetailService.fetchRecentlyPlayed();
    runInAction(() {
      if (data != null) {
        
          itemsRecentlyPlayed.clear();
  itemsRecentlyPlayed.addAll(data);
      } else {
        debugPrint("-- FetchRecentlyPlayed : data null --");
      }
    });
  }

  Future<void> search(String value) async {
    runInAction(() {
      query.value = value;
    });
    _changeSearching(true);
    if (value.isEmpty) {
      _changeSearching(false);
      return;
    }
    var result = await searchDetailService.fetchSearchResult(
      "track",
      10,
      0,
      query.value,
    );
    if (result != null) {
      runInAction(() {
        searchResults = result.asObservable();
      });
      _changeSearching(false);
    }
  }
}
