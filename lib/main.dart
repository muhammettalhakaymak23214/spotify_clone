import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/view/main_tab_view.dart';

void main() {
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
        scaffoldBackgroundColor:AppColors.darkToneInk    , //const Color.fromARGB(100, 18, 18, 18),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomAppBarTheme: BottomAppBarThemeData(
          height: 70,
          color: Colors.transparent,
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
