import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view/search_detail_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final double expandedHeight = 130;
  final EdgeInsetsGeometry paddingH10V5 = EdgeInsetsGeometry.symmetric(horizontal: 10 ,vertical: 5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: false,
              pinned: true,
              expandedHeight: expandedHeight,
              backgroundColor: AppColors.black,
              leading: Padding(
                padding: AppPaddings.leadingPadding,
                child: Container(
                  width: AppSizes.avatarSize2,
                  height: AppSizes.avatarSize2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blackPanther,
                  ),
                  child: Center(
                    child: Image.asset(AppStrings.profileImagePath),
                  ),
                ),
              ),
              title: Text(AppStrings.search),
              actions: [
                Padding(
                  padding: AppPaddings.right10,
                  child: IconButton(
                    color: AppColors.white,
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.camera),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Padding(
                  padding: paddingH10V5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchDetailView(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: AppPaddings.all10,
                            child: Icon(
                              Icons.search,
                              color: AppColors.black,
                              size: AppSizes.size30,
                            ),
                          ),
                          Padding(
                            padding: AppPaddings.left10,
                            child: Text(
                              AppStrings.searchBarTitle,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: AppSizes.fontSize16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },

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
      ),
    );
  }

}
