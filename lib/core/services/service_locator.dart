import 'package:get_it/get_it.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<PlayerViewModel>(
    () => PlayerViewModel()..initPlayer(),
  );
}
