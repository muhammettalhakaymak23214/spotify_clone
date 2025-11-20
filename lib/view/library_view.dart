import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_bottom_sheet.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionButtonsData: [
          AppBarButtonData(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {},
          ),
          AppBarButtonData(
            icon: FaIcon(FontAwesomeIcons.plus),
            onPressed: () {
              CustomBottomSheet().customShowModalBottom(context);
            },
          ),
        ],
        bottomButtonsData: [
          AppBarButtonData(text: AppStrings.playlist, onPressed: () {}),
          AppBarButtonData(text: AppStrings.podcasts, onPressed: () {}),
          AppBarButtonData(text: AppStrings.albums, onPressed: () {}),
          AppBarButtonData(text: AppStrings.artists, onPressed: () {}),
        ],
        leading: Image.asset("assets/png/profile_photo.png"),
        title: SizedBox(
          child: Text("Kitaplığın", style: TextStyle(color: AppColors.white)),
        ),
        //Text(title ?? "", style: TextStyle(color: AppColors.white),
        appBarHeight: 110,
      ),
      body: ListView(
        children: [
          Container(color: Colors.amber, height: 100),
          SizedBox(height: 20),
          Container(color: Colors.amber, height: 100),
          SizedBox(height: 20),
          Container(color: Colors.amber, height: 100),
          SizedBox(height: 20),
          Container(color: Colors.amber, height: 100),
          SizedBox(height: 20),
          Container(color: Colors.amber, height: 100),
          SizedBox(height: 20),
          Container(color: Colors.amber, height: 100),
        ],
      ),
    );
  }
}