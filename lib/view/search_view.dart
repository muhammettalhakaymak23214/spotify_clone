import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/network/token_manager.dart';
import 'package:spotify_clone/models/catogory_model.dart';
import 'package:spotify_clone/view/search_detail_view.dart';
import 'package:spotify_clone/view_model/search_view_model.dart';

class SearchView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchView({super.key, required this.scaffoldKey});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final EdgeInsetsGeometry paddingH10V5 = EdgeInsetsGeometry.symmetric(
    horizontal: 10,
    vertical: 5,
  );
  final double expandedHeight = 130;

  late SearchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchViewModel(token: AppStrings.token);
    viewModel.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _SliverAppBar(
              expandedHeight: expandedHeight,
              widget: widget,
              paddingH10V5: paddingH10V5,
            ),
          ];
        },

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection(),
            Expanded(
              child: Observer(
                builder: (_) {
                  if (viewModel.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildCategoryGrid();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _titleSection() {
    return Padding(
      padding: AppPaddings.all10,
      child: Text(
        AppStrings.searchViewTitle,
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppSizes.fontSize16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 150, left: 10, right: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: viewModel.itemsCategory.length,
      itemBuilder: (context, index) {
        final item = viewModel.itemsCategory[index];
        return _CategoryCard(item);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem item;
  const _CategoryCard(this.item);

  final double containerHeight = 50;
  final double imageSize = 90;

  @override
  Widget build(BuildContext context) {
    final color = categoryColors[item.name] ?? AppColors.grey;

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: -15,
            bottom: -20,
            child: Transform.rotate(
              angle: 0.50,
              child: Image.network(
                item.imageUrl ?? "",
                width: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Text(
              item.name ?? "",
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSizes.fontSize16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final Map<String, Color> categoryColors = {
  "Made For You": Color(0xFF6111C4),
  "Pop": Color(0xFFC026D2),
  "New Releases": Color(0xFFE41E63),
  "Hip-Hop": Color(0xFF0A6F5D),
  "Rock": Color(0xFF0A6F5D),
  "K-pop": Color(0xFF4971FF),
  "Indie": Color(0xFFE60026),
  "Dance/Electronic": Color(0xFFFF7900),
  "Mood": Color(0xFF6A4C93),
  "Charts": Color(0xFF456F75),
  "Party": Color(0xFFFF5A36),
  "Sleep": Color(0xFF007AFE),
  "Chill": Color(0xFF8E44AE),
  "At Home": Color(0xFF3E2C62),
  "EQUAL": Color(0xFFAE27CC),
  "Trending": Color(0xFF6111C4),
  "Workout": Color(0xFFC026D2),
  "Discover": Color(0xFF6111C4),
  "Country": Color(0xFFC026D2),
  "R&B": Color(0xFF6111C4),
};

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({
    super.key,
    required this.expandedHeight,
    required this.widget,
    required this.paddingH10V5,
  });

  final double expandedHeight;
  final SearchView widget;
  final EdgeInsetsGeometry paddingH10V5;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: false,
      pinned: true,
      expandedHeight: expandedHeight,
      backgroundColor: AppColors.black,
      leading: Padding(
        padding: AppPaddings.leadingPadding,
        child: GestureDetector(
          onTap: () async{
            TokenManager().invalidateToken();
            print("-------------------------------------------");
            final token = await TokenManager().getToken();
print("Token: $token");
            print("-------------------------------------------");
            //---------------------------------------------------------------------------------------------------------
            widget.scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            width: AppSizes.avatarSize2,
            height: AppSizes.avatarSize2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blackPanther,
            ),
            child: Center(child: Image.asset(AppStrings.profileImagePath)),
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
                MaterialPageRoute(builder: (context) => SearchDetailView()),
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
    );
  }
}
