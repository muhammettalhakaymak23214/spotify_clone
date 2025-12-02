import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view_model/library_view_model.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_bottom_sheet.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late LibraryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LibraryViewModel();
    viewModel.fetchAlbum();
    viewModel.fetchArtist();
    viewModel.fetchPlaylist();
    viewModel.fetchPodcast();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 110;
    return Scaffold(
      appBar: CustomAppBar(
        viewModel: viewModel,
        actionButtonsData: [
          AppBarButtonData(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {
              // viewModel.addItem();
            },
          ),
          AppBarButtonData(
            icon: FaIcon(FontAwesomeIcons.plus),
            onPressed: () {
              CustomBottomSheet().customShowModalBottom(context);
            },
          ),
        ],
        bottomButtonsData: [
          AppBarButtonData(
            type: "playlist",
            text: AppStrings.playlist,
            onPressed: () {
              if (!viewModel.isLoadingPlaylist.value) {
                viewModel.items.clear();
                viewModel.fetchPlaylist();
              }
            },
          ),
          AppBarButtonData(
            type: "podcasts",
            text: AppStrings.podcasts,
            onPressed: () {
              if (!viewModel.isLoadingPodcast.value) {
                viewModel.items.clear();
                viewModel.fetchPodcast();
              }
            },
          ),
          AppBarButtonData(
            type: "user",
            text: AppStrings.albums,
            onPressed: () {
              if (!viewModel.isLoadingAlbum.value) {
                viewModel.items.clear();
                viewModel.fetchAlbum();
              }
            },
          ),
          AppBarButtonData(
            type: "artists",
            text: AppStrings.artists,
            onPressed: () {
              if (!viewModel.isLoadingArtist.value) {
                viewModel.items.clear();
                viewModel.fetchArtist();
              }
            },
          ),
        ],
        leading: Image.asset(AppStrings.profileImagePath),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: SizedBox(
          child: Text(
            AppStrings.library,
            style: TextStyle(color: AppColors.white),
          ),
        ),
        appBarHeight: appBarHeight,
      ),
      body: Observer(
        builder: (_) {
          if (viewModel.isLoadingAlbum.value &&
              viewModel.isLoadingArtist.value &&
              viewModel.isLoadingPlaylist.value &&
              viewModel.isLoadingPodcast.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.items.isEmpty) {
            return Center(child: Text("No playlists found"));
          }
          return ListView.builder(
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              final imageUrl =
                  item.imagesUrl != null && item.imagesUrl!.isNotEmpty
                  ? item.imagesUrl
                  : null;
              final subtitle = item.subTitle ?? "";

              return ListTile(
                leading: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: Icon(Icons.music_note),
                      ),
                title: Text(item.title ?? "No Title"),
                subtitle: Text(subtitle),
              );
            },
          );
        },
      ),

    );
  }
}
