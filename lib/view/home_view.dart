import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

   final String imagePath = "assets/png/profile_photo.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: Image.asset(imagePath),
         title: Row(
           children: [
            Padding(
               padding: AppPaddings.right10,
               child: SizedBox(
                height: 30,
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blackPanther,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              minimumSize: Size(0, 30), 
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                  onPressed: () {
                   
                 }, child: Text(AppStrings.all, style: TextStyle(color: AppColors.white),)),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(right: 10),
               child: SizedBox(
                height: 30,
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blackPanther,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              minimumSize: Size(0, 30), 
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                  onPressed: () {
                   
                 }, child: Text(AppStrings.music,  style: TextStyle(color: AppColors.white),)),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(right: 10),
               child: SizedBox(
                height: 30,
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blackPanther,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              minimumSize: Size(0, 30), 
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                  onPressed: () {
                   
                 }, child: Text(AppStrings.podcasts,  style: TextStyle(color: AppColors.white),)),
               ),
             ),
           ],
         ),
      // appBarHeight: 110,
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