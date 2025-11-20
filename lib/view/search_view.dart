import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/view/search_detail_view.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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
              expandedHeight: 130,
              backgroundColor: Colors.black,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Container(
                  width: AppSizes.avatarSize2,
                  height: AppSizes.avatarSize2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blackPanther,
                  ),
                  child: Center(
                    child: Image.asset("assets/png/profile_photo.png"),
                  ),
                ),
              ),
              title: Text("Ara"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.camera),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.search,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Ne dinlemek istiyorsun?",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
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
