import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/models/home_model.dart';
import 'package:spotify_clone/view_model/home_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
    viewModel.fetchPlaylist();
    viewModel.fetchNewReleases();
    viewModel.fetchUserTopArtists();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: _Constants.appBarSelectedIndex,
        leading: Image.asset(
          _Constants.profilePhotoImagePath,
          width: _Constants.profileImageSize,
          height: _Constants.profileImageSize,
        ),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterButton(l10n.filterAll),
              _buildFilterButton(l10n.filterMusic),
              _buildFilterButton(l10n.filterPodcasts),
            ],
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _observerSection<PlaylistItem>(l10n.homeViewYourPlaylists, viewModel.itemsPlaylist),
          _observerSection<NewReleasesItem>(l10n.homeViewNewReleases, viewModel.itemsNewReleases),
          _observerSection<UserTopArtistsItem>(l10n.homeViewYourFavoriteArtists, viewModel.itemsUserTopArtists),
          SizedBox(height: _Constants.bottomSpaceHeight),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Padding(
      padding: _Constants.filterButtonPadding,
      child: SizedBox(
        height: _Constants.filterButtonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _Constants.filterButtonBgColor,
            padding: _Constants.filterButtonInternalPadding,
            minimumSize: _Constants.filterButtonMinSize,
            shape: const StadiumBorder(),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {},
          child: AppText(
            text: text,
            style: AppTextStyle.labelM,
            color: _Constants.filterButtonTextColor,
          ),
        ),
      ),
    );
  }

  Widget _observerSection<T>(String title, List<T> items) {
    return Observer(
      builder: (context) {
        return _HorizontalMediaSection<T>(
          viewModel: viewModel,
          items: items,
          itemCount: items.length,
          sectionTitle: title,
        );
      },
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
          padding: _Constants.sectionTitlePadding,
          child: AppText(
            text: sectionTitle,
            style: AppTextStyle.titleL,
            fontWeight: FontWeight.bold,
            color: _Constants.sectionTitleColor,
          ),
        ),
        SizedBox(
          height: _Constants.sectionListHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            padding: _Constants.sectionListPadding,
            itemBuilder: (context, index) {
              final item = items[index] as HomeItem;
              final imageUrl = (item.imagesUrl != null && item.imagesUrl!.isNotEmpty)
                  ? item.imagesUrl
                  : null;

              return Container(
                width: _Constants.cardWidth,
                margin: _Constants.cardMargin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: _Constants.cardImageDecoration,
                      width: _Constants.cardImageSize,
                      height: _Constants.cardImageSize,
                      child: imageUrl == null
                          ? Center(
                              child: AppIcon(
                                icon: Icons.music_note,
                                size: AppIconSize.huge,
                                color: _Constants.fallbackIconColor,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: _Constants.cardBorderRadius,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Padding(
                      padding: _Constants.cardTitlePadding,
                      child: AppText(
                        text: item.title ?? "",
                        maxLines: 1,
                        style: AppTextStyle.bodyM,
                        fontWeight: FontWeight.bold,
                        color: _Constants.cardTitleColor,
                      ),
                    ),
                    AppText(
                      text: item.subTitle ?? "",
                      maxLines: 1,
                      style: AppTextStyle.bodyS,
                      color: _Constants.cardSubTitleColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

abstract final class _Constants {
  //Path
  static String get profilePhotoImagePath => AppStrings.profilePhotoImage;
  //Index
  static int get appBarSelectedIndex => 10;
  //Size
  static double get profileImageSize => 35.w;
  static double get filterButtonHeight => 30.h;
  static Size get filterButtonMinSize => Size(0, 30.h);
  static double get sectionListHeight => 230.h;
  static double get cardWidth => 155.w;
  static double get cardImageSize => 155.w;
  static double get bottomSpaceHeight => 10.h;
  //Color
  static Color get filterButtonBgColor => AppColors.cardBackground;
  static Color get filterButtonTextColor => AppColors.white;
  static Color get sectionTitleColor => AppColors.white;
  static Color get cardTitleColor => AppColors.white;
  static Color get cardSubTitleColor => Colors.grey;
  static Color get fallbackIconColor => AppColors.white;
  static Color get cardImagePlaceholderColor => Colors.grey;
  //Padding
  static EdgeInsets get filterButtonPadding => EdgeInsets.only(right: 8.w);
  static EdgeInsets get filterButtonInternalPadding => EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets get sectionTitlePadding => EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h);
  static EdgeInsets get sectionListPadding => EdgeInsets.only(left: 20.w);
  static EdgeInsets get cardMargin => EdgeInsets.only(right: 15.w);
  static EdgeInsets get cardTitlePadding => EdgeInsets.only(top: 6.h);
  //Decoration
  static BorderRadius get cardBorderRadius => BorderRadius.circular(8.r);
  static BoxDecoration get cardImageDecoration => BoxDecoration(
        color: cardImagePlaceholderColor,
        borderRadius: cardBorderRadius,
      );
}