import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/palette_helper.dart';
import 'package:spotify_clone/core/helpers/song_data_manager.dart';
import 'package:spotify_clone/core/services/audio_player_service.dart';
import 'package:spotify_clone/models/player_model.dart';

class PlayerViewModel {
  //Services
  final AudioPlayerService audioPlayerService = AudioPlayerService();
  //Observable
  Observable<Color> bgColor = Observable<Color>(Colors.black);
  Observable<int> currentIndex = Observable<int>(0);
  ObservableList<PlayTrackItem> playlist = ObservableList<PlayTrackItem>();
  Observable<bool> otoNext = Observable<bool>(false);
  Observable<bool> otoMode = Observable<bool>(false);
  Observable<bool> otoLoop = Observable<bool>(false);
  //Media Type
  late MediaType currentType;

  //init Player

  void initPlayer() {
    _readOtoNext();
    _readOtoLoop();
    _readOtoMode();
    _bindAudioPlayerEvents();
  }

  //Player Listener
  void _bindAudioPlayerEvents() {
    debugPrint("[bindAudioPlayerEvents] : Start");
    audioPlayerService.processingStateStream.listen((status) {
      if (status == AudioStatus.completed) {
        debugPrint("[Audio] Track completed");
        if (otoNext.value) {
          if (otoMode.value) {
            indexNextRandom();
          } else {
            indexNext();
          }
        } else if (otoLoop.value) {
          startSong(currentType);
        }
      }
    });
    debugPrint("[bindAudioPlayerEvents] : End");
  }

  //Listeners
  Stream<Duration?> get durationStream => audioPlayerService.durationStream;
  Stream<Duration> get positionStream => audioPlayerService.positionStream;
  Stream<bool> get playingStream => audioPlayerService.playingStream;

  void playFromPlaylist({
    required List<PlayTrackItem> list,
    required int index,
    required MediaType type,
  }) {
    runInAction(() {
      currentType = type;
      playlist
        ..clear()
        ..addAll(list);
      currentIndex.value = index;
      selectAlbumUrlOrPath(type);
      startSong(type);
    });
  }

  //Controls
  void playerPlay() {
    debugPrint("[playerPlay] : Play");
    audioPlayerService.play();
  }

  void playerPause() {
    debugPrint("[playerPause] : Pause");
    audioPlayerService.pause();
  }

  void stopSong() {
    audioPlayerService.stop();
  }

  void seek(Duration position) {
    audioPlayerService.seek(position);
  }

  //Oto Lopp
  void _readOtoLoop() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool("otoLoop") ?? false;
    runInAction(() {
      otoLoop.value = savedValue;
    });
  }

  Future<void> setOtoLoop() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("otoLoop", !otoLoop.value);
    await prefs.setBool("otoNext", false);
    runInAction(() {
      otoLoop.value = !otoLoop.value;
      otoNext.value = false;
    });
  }

  //Oto Next
  void _readOtoNext() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool("otoNext") ?? false;
    runInAction(() {
      otoNext.value = savedValue;
    });
  }

  Future<void> setOtoNext(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("otoNext", !otoNext.value);
    await prefs.setBool("otoLoop", false);
    runInAction(() {
      otoNext.value = value;
      otoLoop.value = false;
    });
  }

  //Oto Mode
  void _readOtoMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool("otoMode") ?? false;
    runInAction(() {
      otoMode.value = savedValue;
    });
  }

  Future<void> setOtoMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("otoMode", !otoMode.value);
    runInAction(() {
      otoMode.value = value;
    });
  }

  //Start Song
  void startSong(type) async {
    debugPrint("[startSong] : Start");
    final track = playlist[currentIndex.value];
    runInAction(() {});
    if (type == MediaType.downloaded &&
        track.previewPath != null &&
        track.previewPath!.isNotEmpty) {
      audioPlayerService.playFile(track.previewPath!);
    } else if (track.previewUrl != null && track.previewUrl!.isNotEmpty) {
      audioPlayerService.playUrl(track.previewUrl!);
    }
    debugPrint("[startSong] : End");
  }

  //Update Song
  void _songUpdate() {
    debugPrint("[songUpdate] : Start");
    selectAlbumUrlOrPath(currentType);
    startSong(currentType);
    debugPrint("[songUpdate] : End");
  }

  //Index Update
  void indexNextRandom() {
    debugPrint("[indexNextRandom] : Start");
    var random = Random();
    int randomNumber = 1 + random.nextInt(20);
    runInAction(() {
      currentIndex.value =
          (currentIndex.value + randomNumber) % playlist.length;
      _songUpdate();
    });
    debugPrint("[indexNextRandom] : End");
  }

  void indexNext() {
    debugPrint("[indexNext] : Start");
    runInAction(() {
      currentIndex.value = (currentIndex.value + 1) % playlist.length;
    });
    _songUpdate();
    debugPrint("[indexNext] : End");
  }

  void indexPrevious() {
    debugPrint("[indexPrevious] : Start");
    runInAction(() {
      currentIndex.value =
          (currentIndex.value - 1 + playlist.length) % playlist.length;
      _songUpdate();
    });
    debugPrint("[indexPrevious] : End");
  }

  void indexDeleteAndUpdate() {
    debugPrint("[indexDeleteAndUpdate] : Start");
    runInAction(() {
      currentIndex.value = (currentIndex.value) % playlist.length;
      _songUpdate();
    });
    debugPrint("[indexDeleteAndUpdate] : End");
  }

  //Background Color
  Future<void> _updateBackground(String imageUrl, {bool isPath = false}) async {
    debugPrint("[updateBackground] : Start");
    final color = await PaletteHelper.getBackgroundColor(
      imageUrl,
      isPath: isPath,
    );
    runInAction(() {
      bgColor.value = color;
    });
    debugPrint("[updateBackground] : End");
  }

  void selectAlbumUrlOrPath(MediaType type) {
    debugPrint("[selectAlbumUrlOrPath] : Start");
    if (type == MediaType.downloaded) {
      _updateBackground(playlist[currentIndex.value].albumImagePath ?? "");
    } else {
      _updateBackground(
        playlist[currentIndex.value].albumImage ?? "",
        isPath: true,
      );
    }
    debugPrint("[selectAlbumUrlOrPath] : End");
  }

  Future<bool> isDownloaded(String id) async {
    final bool isDowloaded = await SongDataManager().songExistsByFilePath(id);
    return isDowloaded;
  }
}
