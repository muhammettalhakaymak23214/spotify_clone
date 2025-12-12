import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/core/helpers/song_data_manager.dart';

class DownloadedSongsViewModel {
  ObservableList<Map<String, dynamic>> songs =
      ObservableList<Map<String, dynamic>>();

  DownloadedSongsViewModel();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('downloaded_songs');

    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);

      runInAction(() {
        songs.clear();
        songs.addAll(
          jsonData.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
      });
      debugPrint("[loadSongs] : End");
    }
  }
}
