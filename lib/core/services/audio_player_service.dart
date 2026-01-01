import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/palette_helper.dart';
import 'package:spotify_clone/core/services/shared_preference_service.dart';
import 'package:spotify_clone/models/player_model.dart';

class AudioPlayerService extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  late MediaType currentType;
  List<PlayTrackItem> urls = [];
  int _currentIndex = 0;
  bool isPlaying = false;

  //Listen
  AudioPlayerService() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _player.processingStateStream.listen((status) async {
      bool otoMode = SharedPreferenceService.getOtoMode();
      bool otoNext = SharedPreferenceService.getOtoNext();
      bool otoLoop = SharedPreferenceService.getOtoLoop();
      debugPrint(
        "Oto Loop Value : [$otoLoop] | Oto Next Value : [$otoNext] | Oto Mode Value : [$otoMode]",
      );
      if (status == ProcessingState.completed) {
        debugPrint("Status = ProcessingState.completed");
        if (otoNext) {
          if (otoMode) {
            debugPrint("Random Running...");
            skipToNextRandom();
          } else {
            debugPrint("Next Running...");
            skipToNext();
          }
        } else if (otoLoop) {
          debugPrint("Oto Loop Running...");
          await _player.seek(Duration.zero);
          await _player.play();
        }
      }
    });
  }

  //Set Playlist
  Future<void> setPlaylist(
    List<PlayTrackItem> playTrackItemUrlList,
    int startIndex,
    MediaType type,
    String id,
    bool isPlay,
  ) async {
    debugPrint("[AudioPlayerService] : setPlaylist");
    currentType = type;
    urls = playTrackItemUrlList;
    _currentIndex = startIndex;
    isPlaying = isPlay;
    await _playCurrent();
  }

  //Play Current
  Future<void> _playCurrent() async {
    debugPrint("[AudioPlayerService] : _playCurrent");
    final url = urls[_currentIndex];
    late Duration? duration;
    late Color color;
    late Uri? artUri;
    late String id;
    late String image;
    if (currentType != MediaType.downloaded) {
      color = await PaletteHelper.getBackgroundColor(
        urls[_currentIndex].albumImage ?? "",
        isUrl: true,
      );
      id = url.previewUrl!;
      image = url.albumImage!;
      duration = await _player.setUrl(url.previewUrl!);
      artUri = Uri.parse(url.albumImage!);
    } else {
      color = await PaletteHelper.getBackgroundColor(
        urls[_currentIndex].albumImagePath ?? "",
        isUrl: false,
      );
      duration = await _player.setUrl(url.previewPath!);
      id = url.previewPath!;
      image = url.albumImagePath!;
      artUri = Uri.file(url.albumImagePath!);
    }
    mediaItem.add(
      MediaItem(
        id: id,
        title: url.trackName!,
        duration: duration,
        artist: url.artistName,
        album: image,
        artUri: artUri,
        genre: url.id,      
        extras: {'color': color.toARGB32()},
      ),
    );
    if (isPlaying) {
      await play();
    }
  }

  //Play
  @override
  Future<void> play() {
    debugPrint("[AudioPlayerService] : Play");
    isPlaying = true;
    return _player.play();
  }

  //Pause
  @override
  Future<void> pause() {
    debugPrint("[AudioPlayerService] : Pause");
    isPlaying = false;
    return _player.pause();
  }

  //Stop
  @override
  Future<void> stop() async {
    debugPrint("[AudioPlayerService] : stop");
    //await _player.stop();
    //mediaItem.add(null);
    /*
    queue.add([]);
    playbackState.add(
      PlaybackState(
        processingState: AudioProcessingState.idle,
        playing: false,
        controls: [],
      ),
    );*/
  //  await super.stop();
  }

  //On Task Removed
  @override
  Future<void> onTaskRemoved() async {
    debugPrint("[AudioPlayerService] : onTaskRemoved");
    await pause();
  }

  //Skip To Next And Delete
  Future<int> skipToNextAndDelete() async {
    debugPrint("[AudioPlayerService] : skipToNextAndDelete");
    _currentIndex = (_currentIndex) % urls.length;
    await _playCurrent();
    return _currentIndex;
  }

  //Skip To Next
  @override
  Future<int> skipToNext() async {
    debugPrint("[AudioPlayerService] : SkipToNext");
    _currentIndex = (_currentIndex + 1) % urls.length;
    await _playCurrent();
    return _currentIndex;
  }

  //Skip To Next Random
  Future<void> skipToNextRandom() async {
    debugPrint("[AudioPlayerService] : skipToNextRandom");
    var random = Random();
    int newIndex;
    do {
      newIndex = random.nextInt(urls.length);
    } while (newIndex == _currentIndex);
    _currentIndex = newIndex;
    await _playCurrent();
  }

  //Skip To Previous
  @override
  Future<void> skipToPrevious() async {
    debugPrint("[AudioPlayerService] : skipToPrevious");
    _currentIndex = ((_currentIndex - 1) + urls.length) % urls.length;
    await _playCurrent();
  }

  //Seek
  @override
  Future<void> seek(Duration position) async {
    debugPrint("[AudioPlayerService] : seek");
    await _player.seek(position);
  }

  //Transform Event
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      processingState: _mapProcessingState(_player.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  //Map Processing State
  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }
}
