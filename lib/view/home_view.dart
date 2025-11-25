import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/models/home_model.dart';
import 'package:spotify_clone/view_model/home_view_model.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String imagePath = "assets/png/profile_photo.png";
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(token: AppStrings.token);
    viewModel.fetchPlaylist();
    viewModel.fetchNewReleases();
    viewModel.fetchUserTopArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Image.asset(imagePath),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: Row(
          children: [
            Padding(
              padding: AppPaddings.right10,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blackPanther,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: Text(
                    AppStrings.all,
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blackPanther,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: Text(
                    AppStrings.music,
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blackPanther,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: Text(
                    AppStrings.podcasts,
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        // appBarHeight: 110,
      ),
      body: ListView(
        children: [
           SizedBox(height: 500,),
          Observer(
            builder: (context) {
              return _HorizontalMediaSection<HomeItem>(
                viewModel: viewModel,
                items: viewModel.itemsPlaylist,
                itemCount: viewModel.itemsPlaylist.length,
                sectionTitle: "Çalma Listelerin",
              );
            },
          ),
          SizedBox(height: 10),
          Observer(
            builder: (context) {
              return _HorizontalMediaSection<HomeItem>(
                viewModel: viewModel,
                items: viewModel.itemsNewReleases,
                itemCount: viewModel.itemsNewReleases.length,
                sectionTitle: "Yeni Çıkanlar",
              );
            },
          ),
                    SizedBox(height: 10),
          Observer(
            builder: (context) {
              return _HorizontalMediaSection<HomeItem>(
                viewModel: viewModel,
                items: viewModel.itemsUserTopArtists,
                itemCount: viewModel.itemsUserTopArtists.length,
                sectionTitle: "Sevdiğin Sanatçılar",
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HorizontalMediaSection<T> extends StatelessWidget {
  const _HorizontalMediaSection({
    super.key,
    required this.viewModel,
    required this.sectionTitle,
    required this.itemCount,
    required this.items,
  });

  final HomeViewModel viewModel;
  final String sectionTitle;
  final int itemCount;
  final List<T> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,

            itemBuilder: (context, index) {
              final item = items[index] as HomeItem;
              final imageUrl =
                  item.imagesUrl != null && item.imagesUrl!.isNotEmpty
                  ? item.imagesUrl
                  : null;
              final subtitle = item.subTitle ?? "";
              final title = item.title ?? "";
              return Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: SizedBox(
                  width: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network("$imageUrl", fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          subtitle,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


