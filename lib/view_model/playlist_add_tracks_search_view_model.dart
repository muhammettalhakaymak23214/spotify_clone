import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/search_detail/search_detail_service.dart';
import 'package:spotify_clone/core/services/update_playlist_service.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

class PlaylistAddTracksSearchViewModel {
  //Services
  final SearchDetailService searchDetailService = SearchDetailService();
  final UpdatePlaylistService _updatePlaylistService = UpdatePlaylistService();
  //Observable
  ObservableList<RecentlyPlayedItem> itemsRecentlyPlayed =
      ObservableList<RecentlyPlayedItem>();
  ObservableList<SearchResultItem>? searchResults =
      ObservableList<SearchResultItem>();
  final Observable<String> query = Observable("");
  final Observable<bool> isSearching = Observable(false);
  //Variables
  int offSet = 0;

  Future<void> addTracksToPlaylist({
    required String playlistId,
    required List<String> trackUris,
  }) async {
    try {
      await _updatePlaylistService.addTracksToPlaylist(
        playlistId: playlistId,
        trackUris: trackUris,
      );
    } catch (e) {
      debugPrint("[addTracksToPlaylist]: $e");
    } finally {}
  }

  void _changeSearching(bool isSearchingTorF) {
    runInAction(() {
      isSearching.value = isSearchingTorF;
    });
  }

  Future<void> fetchRecentlyPlayed() async {
    final data = await searchDetailService.fetchRecentlyPlayed();
    runInAction(() {
      if (data != null) {
        // itemsRecentlyPlayed.clear();
        itemsRecentlyPlayed.addAll(data);
      } else {
        debugPrint("-- FetchRecentlyPlayed : data null --");
      }
    });
  }

  Future<void> search(String value, int limit) async {
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
      limit,
      offSet,
      query.value,
    );
    if (result != null) {
      runInAction(() {
        searchResults?.addAll(result);
        // searchResults = result.asObservable();
      });
      _changeSearching(false);
    }
  }
}
