import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/recently_played_service.dart';
import 'package:spotify_clone/models/recently_played_model.dart';

class RecentlyPlayedViewModel {

  final RecentlyPlayedService _recentlyPlayedService = RecentlyPlayedService();

 
  ObservableList<RecentlyPlayedTarckModel> recentlyPlayedList =
      ObservableList<RecentlyPlayedTarckModel>();

  ObservableMap<String, List<RecentlyPlayedTarckModel>> groupedByDate =
      ObservableMap<String, List<RecentlyPlayedTarckModel>>();

  
  String? url;


  void getNowDate() {
    final now = DateTime.now().toUtc();
    final before = now.millisecondsSinceEpoch;
    url = "me/player/recently-played?limit=50&before=$before";
  }


  Future<void> getRecentlyPlayedTracks() async {
    try {
      if (url != null) {
        final responseTracks = await _recentlyPlayedService.getRecetlyPlayed(
          url: url!,
        );
        
        runInAction(() {
          recentlyPlayedList.clear();
          recentlyPlayedList.addAll(responseTracks ?? []);
        });
      }
    } catch (e) {
      debugPrint("[getRecentlyPlayedTracks] Error: $e");
    }
  }


  void grupla(String locale) {
   
    runInAction(() {
      groupedByDate.clear();
    });

   
    final Map<String, List<RecentlyPlayedTarckModel>> tempGrouped = {};

    for (var track in recentlyPlayedList) {
      if (track.playedAt != null) {
        final date = DateTime.parse(track.playedAt!).toLocal();
        
        
        final String dateKey = DateFormat('d MMMM y', locale).format(date);

        if (!tempGrouped.containsKey(dateKey)) {
          tempGrouped[dateKey] = [];
        }
        tempGrouped[dateKey]!.add(track);
      }
    }

    runInAction(() {
      groupedByDate.addAll(tempGrouped);
    });
  }
}