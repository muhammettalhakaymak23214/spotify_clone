import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/network/token_manager.dart';
import 'package:spotify_clone/models/catogory_model.dart';
import 'package:spotify_clone/view/search_detail_view.dart';
import 'package:spotify_clone/view_model/search_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class SearchView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchView({super.key, required this.scaffoldKey});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late SearchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchViewModel();
    viewModel.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _SliverAppBar(
              scaffoldKey: widget.scaffoldKey,
              innerBoxIsScrolled: innerBoxIsScrolled,
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
            SizedBox(height: 100.h,)
          ],
        ),
      ),
    );
  }

  Widget _titleSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.titleSectionPadding,
      child: AppText(
        text: l10n.searchViewTitle,
        style: AppTextStyle.titleM,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: _Constants.gridPadding,
      gridDelegate: _Constants.gridDelegate,
      itemCount: viewModel.itemsCategory.length,
      itemBuilder: (context, index) {
        final item = viewModel.itemsCategory[index];
        return _CategoryCard(item: item);
      },
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool innerBoxIsScrolled;
  const _SliverAppBar({
    required this.scaffoldKey,
    required this.innerBoxIsScrolled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverAppBar(
      floating: true,
      snap: false,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0, 
      forceElevated: innerBoxIsScrolled,
      expandedHeight: _Constants.appBarExpandedHeight,
      backgroundColor: AppColors.black,
      leadingWidth: _Constants.leadingWidth,
      leading: Padding(
        padding: _Constants.leadingPadding,
        child: GestureDetector(
          onTap: () async {
            await TokenManager().invalidateToken();
            scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            decoration: _Constants.profileImageDecoration,
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  AppStrings.profileImagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      title: AppText(
        text: l10n.bottomNavigatorSearch,
        style: AppTextStyle.titleL,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      actions: [
        Padding(
          padding: _Constants.actionPadding,
          child: IconButton(
            onPressed: () {},
            icon: AppIcon(
              icon: FontAwesomeIcons.camera,
              color: AppColors.white,
              size: AppIconSize.medium,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: _Constants.searchBarPreferredSize,
        child: Padding(
          padding: _Constants.searchBarPadding,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchDetailView()),
              );
            },
            child: Container(
              height: _Constants.searchBarHeight,
              decoration: _Constants.searchBarDecoration,
              child: Row(
                children: [
                  Padding(
                    padding: _Constants.searchIconPadding,
                    child: AppIcon(
                      icon: Icons.search,
                      color: AppColors.black,
                      size: AppIconSize.large,
                    ),
                  ),
                  AppText(
                    text: l10n.searchViewSearchBarText,
                    style: AppTextStyle.bodyM,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
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

class _CategoryCard extends StatelessWidget {
  final CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = categoryColors[item.name] ?? AppColors.grey;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: _Constants.cardBorderRadius,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: _Constants.imagePositionRight,
            bottom: _Constants.imagePositionBottom,
            child: Transform.rotate(
              angle: _Constants.imageRotationAngle,
              child: Image.network(
                item.imageUrl ?? "",
                width: _Constants.categoryImageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: _Constants.categoryTitlePosition,
            left: _Constants.categoryTitlePosition,
            child: AppText(
              text: item.name ?? "",
              style: AppTextStyle.titleS,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

final Map<String, Color> categoryColors = {
  "Made For You": const Color(0xFF6111C4),
  "Pop": const Color(0xFFC026D2),
  "New Releases": const Color(0xFFE41E63),
  "Hip-Hop": const Color(0xFF0A6F5D),
  "Rock": const Color(0xFF0A6F5D),
  "K-pop": const Color(0xFF4971FF),
  "Indie": const Color(0xFFE60026),
  "Dance/Electronic": const Color(0xFFFF7900),
  "Mood": const Color(0xFF6A4C93),
  "Charts": const Color(0xFF456F75),
  "Party": const Color(0xFFFF5A36),
  "Sleep": const Color(0xFF007AFE),
  "Chill": const Color(0xFF8E44AE),
  "At Home": const Color(0xFF3E2C62),
  "EQUAL": const Color(0xFFAE27CC),
  "Trending": const Color(0xFF6111C4),
  "Workout": const Color(0xFFC026D2),
  "Discover": const Color(0xFF6111C4),
  "Country": const Color(0xFFC026D2),
  "R&B": const Color(0xFF6111C4),
};

abstract final class _Constants {
  // Size
  static double get appBarExpandedHeight => 120.h;
  static double get searchBarHeight => 46.h;
  static Size get searchBarPreferredSize => Size.fromHeight(56.h);
  static double get categoryImageSize => 90.w;
  static double get leadingWidth => 55.w;

  // Grid
  static SliverGridDelegate get gridDelegate => const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      );

  // Position & Rotation
  static double get imageRotationAngle => 0.50;
  static double get imagePositionRight => -15.w;
  static double get imagePositionBottom => -20.h;
  static double get categoryTitlePosition => 12.w;

  // Padding
  static EdgeInsetsGeometry get titleSectionPadding => EdgeInsets.all(12.w);
  static EdgeInsetsGeometry get gridPadding => EdgeInsets.only(bottom: 100.h, left: 12.w, right: 12.w);
  static EdgeInsetsGeometry get leadingPadding => EdgeInsetsDirectional.only(start: 12.w);
  static EdgeInsetsGeometry get actionPadding => EdgeInsetsDirectional.only(end: 10.w);
  static EdgeInsetsGeometry get searchBarPadding => EdgeInsetsDirectional.fromSTEB(12.w, 0, 12.w, 10.h);
  static EdgeInsetsGeometry get searchIconPadding => EdgeInsets.symmetric(horizontal: 10.w);

  // Decoration
  static BorderRadius get cardBorderRadius => BorderRadius.circular(10.r);
  static BoxDecoration get searchBarDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      );
  static BoxDecoration get profileImageDecoration => BoxDecoration(
        shape: BoxShape.circle,
       // color: AppColors.blackPanther,
      );
}