import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/view/main_tab_view.dart';


void main() async {

    WidgetsFlutterBinding.ensureInitialized(); 

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor:
            AppColors.darkToneInk, 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarThemeData(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.blackPanther,
          actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          titleSpacing: 10,
          titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        bottomAppBarTheme: BottomAppBarThemeData(
          height: 70,
          color: const Color.fromARGB(140, 0, 0, 0),
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
        ),
      ),

      home: MainTabView(),
    );
  }
}
