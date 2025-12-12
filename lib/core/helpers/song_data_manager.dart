import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/core/services/file_manager_service.dart';

class SongDataManager {
  Future<void> saveSongsToPrefs(List<Map<String, dynamic>> songs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(songs);
    await prefs.setString('downloaded_songs', jsonString);
  }

  Future<List<Map<String, dynamic>>> loadSongsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('downloaded_songs');
    if (jsonString == null) return [];
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> clearSongsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('downloaded_songs');
    debugPrint("İndirilen şarkılar listesi silindi.");
    FileManagerService().clearAllFiles();
  }

  Future<void> deleteSongById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('downloaded_songs');

    if (jsonString == null) return;

    final songs = List<Map<String, dynamic>>.from(jsonDecode(jsonString));

    final index = songs.indexWhere((song) => song["id"] == id);

    if (index == -1) {
      debugPrint("Silinecek şarkı bulunamadı. ID: $id");
      return;
    }

    final song = songs[index];
    if (song["albumCoverPath"] != null) {
      await FileManagerService().deleteFile(song["albumCoverPath"]);
    }

    if (song["filePath"] != null) {
      await FileManagerService().deleteFile(song["filePath"]);
    }

    songs.removeAt(index);

    await prefs.setString("downloaded_songs", jsonEncode(songs));

    debugPrint("Şarkı başarıyla silindi → $id");
  }

  Future<bool> songExistsByFilePath(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('downloaded_songs');

    if (jsonString == null) return false;

    final songs = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    debugPrint("_________________________________");
    debugPrint(id);
    debugPrint("_________________________________");
    return songs.any((song) => "${song["id"]}" == id);
  }
}
