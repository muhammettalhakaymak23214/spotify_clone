import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view_model/search_detail_view_model.dart';

class SearchDetailView extends StatefulWidget {
  const SearchDetailView({super.key});

  @override
  State<SearchDetailView> createState() => _SearchDetailViewState();
}

class _SearchDetailViewState extends State<SearchDetailView> {
  final TextEditingController _controller = TextEditingController();
  late SearchDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchDetailViewModel();
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
          onChanged: (value) => viewModel.search(value),
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
            onPressed: () {},
            icon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.close, color: AppColors.white),
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
        );
      },
    );
  }
}
