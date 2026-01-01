import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<PlayerStore>(
    () => PlayerStore(getIt<AudioHandler>()),
  );
}
