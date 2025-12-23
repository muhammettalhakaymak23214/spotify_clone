import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/recently_played_service.dart';
import 'package:spotify_clone/models/recently_played_model.dart';

class RecentlyPlayedViewModel {
  //Services
  final RecentlyPlayedService _recentlyPlayedService = RecentlyPlayedService();
  //Observable
  ObservableList<RecentlyPlayedTarckModel> recentlyPlayedList =
      ObservableList<RecentlyPlayedTarckModel>();
  ObservableMap<String, List<RecentlyPlayedTarckModel>> groupedByDate =
      ObservableMap<String, List<RecentlyPlayedTarckModel>>();
  //Variables
  String? url;

  void getNowDate() {
    final now = DateTime.now().toUtc();
    final before = now.millisecondsSinceEpoch;
    url = "me/player/recently-played?limit=50&before=$before";
  }

  Future<void> getRecentlyPlayedTracks() async {
    try {
      debugPrint(url);
      if (url != null) {
        final responseTracks = await _recentlyPlayedService.getRecetlyPlayed(
          url: url!,
        );
        recentlyPlayedList.clear();
        recentlyPlayedList.addAll(responseTracks ?? []);
      }
    } catch (e) {
      debugPrint("[getRecentlyPlayedTracks] : $e");
    } finally {}
  }

  void grupla() {
    for (var track in recentlyPlayedList) {
      if (track.playedAt != null) {
        final date = DateTime.parse(track.playedAt!);
        final dateKey =
            "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}";
        groupedByDate.putIfAbsent(dateKey, () => []);
        runInAction(() {
          groupedByDate[dateKey]?.add(track);
        });
      }
    }
  }

  String _monthName(int month) {
    const months = [
      "Ocak",
      "Şubat",
      "Mart",
      "Nisan",
      "Mayıs",
      "Haziran",
      "Temmuz",
      "Auğustos",
      "Eylül",
      "Ekim",
      "Kasım",
      "Aralık",
    ];
    return months[month - 1];
  }
}
