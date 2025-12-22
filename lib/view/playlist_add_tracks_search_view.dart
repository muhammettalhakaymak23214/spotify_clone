import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view_model/playlist_add_tracks_search_view_model.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';

class PlaylistAddTracksSearchView extends StatefulWidget {
  const PlaylistAddTracksSearchView({super.key, required this.playlistId});

  final String playlistId;

  @override
  State<PlaylistAddTracksSearchView> createState() =>
      _PlaylistAddTracksSearchViewState();
}

class _PlaylistAddTracksSearchViewState
    extends State<PlaylistAddTracksSearchView> {
  //Controller
  final TextEditingController _controller = TextEditingController();
  //ViewModel
  late PlaylistAddTracksSearchViewModel viewModel;
  late UpdatePlaylistViewModel viewModel2;
  
  @override
  void initState() {
    super.initState();
    viewModel = PlaylistAddTracksSearchViewModel();
    viewModel2 = UpdatePlaylistViewModel();
    viewModel.fetchRecentlyPlayed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          cursorColor: AppColors.white,
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: AppStrings.searchBar,
            hintStyle: TextStyle(color: AppColors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            viewModel.searchResults?.clear();
            viewModel.search(value, 10);
          },
        ),
      ),
      body: Observer(
        builder: (_) {
          if (viewModel.query.value.isEmpty) {
            return _recentlyPlayedList();
          }
          return _searchResultsList();
        },
      ),
    );
  }

  Widget _recentlyPlayedList() {
    return ListView.builder(
      itemCount: viewModel.itemsRecentlyPlayed.length,
      itemBuilder: (context, index) {
        final items = viewModel.itemsRecentlyPlayed[index];
        return ListTile(
          leading: Image.network(items.imageUrl ?? ""),
          title: Text(
            items.name ?? "",
            style: TextStyle(color: AppColors.white),
          ),
          subtitle: Text(
            items.artistName ?? "",
            style: TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            onPressed: () async {
              List<String> trackUris = [];
              debugPrint(items.id);
              trackUris.add("spotify:track:${items.id}");
              await viewModel2.addTracksToPlaylist(
                playlistId: widget.playlistId,
                trackUris: trackUris,
              );
              viewModel.itemsRecentlyPlayed.removeAt(index);
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.add, color: AppColors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _searchResultsList() {
    if (viewModel.isSearching.value) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: viewModel.searchResults!.length,
      itemBuilder: (context, index) {
        final item = viewModel.searchResults![index];
        return ListTile(
          leading: Image.network(item.imageUrl ?? ""),
          title: Text(
            item.name ?? "",
            style: TextStyle(color: AppColors.white),
          ),
          subtitle: Text(
            item.artistName ?? "",
            style: TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            onPressed: () async {
              //
              List<String> trackUris = [];
              debugPrint(item.id);
              trackUris.add("spotify:track:${item.id}");
              await viewModel2.addTracksToPlaylist(
                playlistId: widget.playlistId,
                trackUris: trackUris,
              );
              viewModel.searchResults?.removeAt(index);
              viewModel.offSet++;
              debugPrint("${viewModel.offSet}");
              await viewModel.search(_controller.text, 1);
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.add, color: AppColors.white),
            ),
          ),
        );
      },
    );
  }
}
