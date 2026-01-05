import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';

import 'package:spotify_clone/core/services/audio_player_service.dart';
import 'package:spotify_clone/core/services/navigation_service.dart';
import 'package:spotify_clone/core/services/player_service.dart';
import 'package:spotify_clone/core/services/recently_played_service.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/core/services/shared_preference_service.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/models/recently_played_model.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';

late AudioPlayerService audioHandler;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // WidgetsFlutterBinding.ensureInitialized();

  //Shared Preference Init
  await SharedPreferenceService.init();
  //

  //

  audioHandler = await AudioService.init(
    builder: () => AudioPlayerService(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,

      androidNotificationIcon: 'drawable/ic_launcher_foreground',

      //androidOngoing: false,
      androidNotificationClickStartsActivity: true,

      androidStopForegroundOnPause: true,
      androidResumeOnClick: true,
    ),
  );

  getIt.registerSingleton<AudioHandler>(audioHandler);
  setupLocator();

  final player = getIt<PlayerStore>();
  final String url = MiniPlayerInit().getNowDate();
  final List<PlayTrackItem> playList = await MiniPlayerInit()
      .getRecentlyPlayedTracks(url);
  final playList2 = playList.map(
    (t) => MiniPlayerInit().getTrackWithPreview(t),
  );
  final playlist3 = await Future.wait(playList2);

  player.playFromPlaylist(
    list: playlist3,
    index: 0,
    type: MediaType.playlist,
    id: "0",
  );

  await Future.delayed(const Duration(milliseconds: 500));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterNativeSplash.remove();

  runApp(MyApp());
}

class MiniPlayerInit {
  final RecentlyPlayedService _recentlyPlayedService = RecentlyPlayedService();
  final PlayerService playerService = PlayerService();
  final List<RecentlyPlayedTarckModel> recPlaylist = [];
  String getNowDate() {
    final now = DateTime.now().toUtc();
    final before = now.millisecondsSinceEpoch;
    final url = "me/player/recently-played?limit=50&before=$before";
    return url;
  }

  Future<List<PlayTrackItem>> getRecentlyPlayedTracks(String url) async {
    debugPrint(url);
    if (url != null) {
      final responseTracks = await _recentlyPlayedService.getRecetlyPlayed(
        url: url,
      );

      // recPlaylist.addAll(responseTracks ?? []);
      recPlaylist.addAll(
        (responseTracks ?? []).where(
          (newItem) => !recPlaylist.any((oldItem) => oldItem.id == newItem.id),
        ),
      );
      List<PlayTrackItem> playList = recPlaylist.map((track) {
        return PlayTrackItem(
          id: track.id,
          artistName: track.artistName,
          previewUrl: '',
          trackName: track.name,
          albumImage: track.imageUrl,
        );
      }).toList();
      return playList;
    }
  }

  Future<PlayTrackItem> getTrackWithPreview(PlayTrackItem spotifyTrack) async {
    final previewUrl = await playerService.searchTrack(
      'artist:"${spotifyTrack.artistName!}" track:"${spotifyTrack.trackName}"',
    );

    final track = PlayTrackItem(
      id: spotifyTrack.id,
      trackName: spotifyTrack.trackName,
      artistName: spotifyTrack.artistName,
      albumImage: spotifyTrack.albumImage ?? previewUrl?.last,
      previewUrl:
          previewUrl?.first ??
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    );

    return track;
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print("Genişlik: ${MediaQuery.of(context).size.width}");
    print("Yükseklik: ${MediaQuery.of(context).size.height}");
    return ScreenUtilInit(
      designSize: const Size(411, 914),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Spotify clone',
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.instance.navigatorKey,

          supportedLocales: AppLocalizations.supportedLocales,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          //locale: const Locale('en'),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },

          theme: ThemeData(
            appBarTheme: AppBarThemeData(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.blackPanther,
              actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              titleSpacing: 10,
              titleTextStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            tabBarTheme: TabBarThemeData(
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(fontSize: 10.0),
              unselectedLabelStyle: TextStyle(fontSize: 10.0),
            ),
            listTileTheme: ListTileThemeData(
              subtitleTextStyle: TextStyle(color: Colors.white54),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              iconColor: AppColors.white
              
            ),

            //Yeni düzen
            //Bottom App Bar Theme
            bottomAppBarTheme: BottomAppBarThemeData(
              color: AppColors.bottomNavBarBackground,
              elevation: 0,
              height: 75.h,
              surfaceTintColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            //Scaffold Background Color
            scaffoldBackgroundColor: AppColors.background,
            //Divider Theme
            dividerTheme: DividerThemeData(color: AppColors.white),
            //Icon Theme
            iconTheme: IconThemeData(color: AppColors.white, size: 24.sp),
            //Text Theme
            textTheme: TextTheme(
              //Display
              displayLarge: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                height: 1.1,
                color: AppColors.white,
              ),
              //Headline
              headlineLarge: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                height: 1.2,
                color: AppColors.white,
              ),
              headlineMedium: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: AppColors.white,
              ),
              headlineSmall: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              //Title
              titleLarge: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: AppColors.white,
              ),
              titleMedium: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
                height: 1.4,
                color: AppColors.white,
              ),
              titleSmall: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: AppColors.white,
              ),
              //Body
              bodyLarge: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                height: 1.5,
                color: AppColors.white,
              ),
              bodyMedium: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                height: 1.4,
                color: AppColors.white,
              ),
              bodySmall: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                height: 1.4,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
              //Label
              labelLarge: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                color: AppColors.white,
              ),
              labelMedium: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: AppColors.white,
              ),
              labelSmall: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                color: AppColors.grey,
              ),
            ),
          ),

          home: MainTabView(),
        );
      },
    );
  }
}
