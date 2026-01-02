import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/song_data_manager.dart';
import 'package:spotify_clone/core/services/audio_player_service.dart';
import 'package:spotify_clone/core/services/shared_preference_service.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/models/progress_bar_state.dart';

class PlayerStore {
  //Audio Handler
  final AudioHandler audioHandler;
  //Observable
  Observable<Color> bgColor = Observable<Color>(Colors.black);
  Observable<int> currentIndex = Observable<int>(0);
  ObservableList<PlayTrackItem> playlist = ObservableList<PlayTrackItem>();
  Observable<bool> otoNext = Observable<bool>(false);
  Observable<bool> otoMode = Observable<bool>(false);
  Observable<bool> otoLoop = Observable<bool>(false);
  //Media Type
  late MediaType currentType;
  //Constructor
  PlayerStore(this.audioHandler);

  void playFromPlaylist({
    required List<PlayTrackItem> list,
    required int index,
    required MediaType type,
    required String id,
  }) async {
    runInAction(() {
      currentType = type;
      playlist
        ..clear()
        ..addAll(list);
      debugPrint("playlist sarki adedi : [${playlist.length}]");
      currentIndex.value = index;
      debugPrint("playlist sarki indexi : [$index]");
    });

    const fallbackUrl =
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
    if (type != MediaType.downloaded) {
      final urls = list
          .map(
            (e) => (e.previewUrl != null && e.previewUrl!.isNotEmpty)
                ? e.previewUrl!
                : fallbackUrl,
          )
          .toList();
    } else if (type == MediaType.downloaded) {
      final urls = list
          .map(
            (e) => (e.previewPath != null && e.previewPath!.isNotEmpty)
                ? e.previewPath!
                : fallbackUrl,
          )
          .toList();
    }

    await (audioHandler as AudioPlayerService).setPlaylist(
      list,
      index,
      type,
      id,
      false,
    );
  }

  //Is Downloaded
  Future<bool> isDownloaded(String id) async {
    final bool isDowloaded = await SongDataManager().songExistsByFilePath(id);
    return isDowloaded;
  }

  //Index Delete And Update
  Future<void> indexDeleteAndUpdate() async {
    await (audioHandler as AudioPlayerService).skipToNextAndDelete();
  }

  //Play
  void playerPlay() {
    audioHandler.play();
  }

  //Pause
  void playerPause() {
    audioHandler.pause();
  }

  //Stop
  void stopSong() {
    audioHandler.stop();
  }

  //Index Next
  void indexNext() {
    audioHandler.skipToNext();
  }

  //Index Previous
  void indexPrevious() {
    audioHandler.skipToPrevious();
  }

  //Seek
  void seek(Duration position) {
    audioHandler.seek(position);
  }

  //Set Oto Loop
  Future<bool> setOtoLoop() async {
    return await SharedPreferenceService.setOtoLoop();
  }

  //Set Oto Mode
  Future<bool> setOtoMode() async {
    return await SharedPreferenceService.setOtoMode();
  }

  //Set Oto Next
  Future<bool> setOtoNext() async {
    return await SharedPreferenceService.setOtoNext();
  }

  //Get Oto Next
  void getOtoNext() {
    runInAction(() {
      otoNext.value = SharedPreferenceService.getOtoNext();
    });
  }

  //Get Oto Mode
  void getOtoMode() {
    runInAction(() {
      otoMode.value = SharedPreferenceService.getOtoMode();
    });
  }

  //Get Oto Loop
  void getOtoLoop() {
    runInAction(() {
      otoLoop.value = SharedPreferenceService.getOtoLoop();
    });
  }

  //Playing Stream
  Stream<bool> get playingStream =>
      audioHandler.playbackState.map((state) => state.playing);

  //Duration Stream
  Stream<Duration?> get durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration);

  //Position Stream
  Stream<Duration> get positionStream => AudioService.position;

  Stream<ProgressBarState> get progressBarStream =>
    Rx.combineLatest2<Duration, Duration?, ProgressBarState>(
      positionStream,
      durationStream,
      (position, duration) => ProgressBarState(
        position: position,              
        total: duration ?? Duration.zero, 
      ),
    ).startWith(ProgressBarState(position: Duration.zero, total: Duration.zero));
}
