import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._privateConstructor();

  static final AudioPlayerService _instance =
      AudioPlayerService._privateConstructor();

  factory AudioPlayerService() => _instance;

  final AudioPlayer _player = AudioPlayer();

  //Listeners
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<bool> get playingStream => _player.playingStream;

  //Controls
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }

  Future<void> playUrl(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> playFile(String path) async {
    await _player.setFilePath(path);
    await _player.play();
  }

  //Player Listener
  Stream<AudioStatus> get processingStateStream =>
      _player.processingStateStream.map((state) {
        switch (state) {
          case ProcessingState.completed:
            return AudioStatus.completed;
          case ProcessingState.ready:
            return AudioStatus.playing;
          default:
            return AudioStatus.paused;
        }
      });
}

enum AudioStatus { playing, paused, completed }
