import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/view_model/recently_played_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class RecentlyPlayedView extends StatefulWidget {
  const RecentlyPlayedView({super.key});

  @override
  State<RecentlyPlayedView> createState() => _RecentlyPlayedViewState();
}

class _RecentlyPlayedViewState extends State<RecentlyPlayedView> {
  late RecentlyPlayedViewModel viewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;
  final Map<String, bool> _isExpanded = {};

  @override
  void initState() {
    super.initState();
    viewModel = RecentlyPlayedViewModel();
    getRecentlyPlayedTracks();

    _scrollController.addListener(() {
      final isBottom =
          _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      if (_isAtBottom != isBottom) {
        setState(() {
          _isAtBottom = isBottom;
        });
      }
    });
  }

  void getRecentlyPlayedTracks() async {
    viewModel.getNowDate();
    await viewModel.getRecentlyPlayedTracks();
    if (mounted) {
      final locale = Localizations.localeOf(context).languageCode;
      viewModel.grupla(locale);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: _Constants.scrollDuration,
      curve: Curves.slowMiddle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var bottomHeight = 180.h + MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _Constants.appBarBgColor,
        surfaceTintColor: _Constants.appBarBgColor,
        centerTitle: true,
        title: AppText(
          text: l10n.recentlyPlayedViewRecentlyPlayed,
          style: AppTextStyle.titleL,
        ),
      ),
      body: Observer(
        builder: (context) {
          final currentLocale = Localizations.localeOf(context).languageCode;
          viewModel.grupla(currentLocale);

          return ListView(
            controller: _scrollController,
            children: viewModel.groupedByDate.keys.map((date) {
              bool isExpanded = _isExpanded[date] ?? true;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _Constants.headerPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(text: date, style: AppTextStyle.h2),
                        IconButton(
                          icon: AnimatedRotation(
                            turns: isExpanded
                                ? _Constants.turnsOpen
                                : _Constants.turnsClosed,
                            duration: _Constants.animationDuration,
                            child: AppIcon(
                              icon: Icons.arrow_drop_down,
                              size: AppIconSize.large,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded[date] = !isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Padding(
                      padding: _Constants.dividerPadding,
                      child: Divider(color: _Constants.dividerColor),
                    ),
                    secondChild: Column(
                      children: viewModel.groupedByDate[date]!.map((track) {
                        return ListTile(
                          title: AppText(
                            text: track.name ?? "",
                            style: AppTextStyle.bodyL,
                          ),
                          leading: ClipRRect(
                            borderRadius: _Constants.imageRadius,
                            child: Image.network(
                              track.imageUrl ?? "",
                              width: _Constants.imageSize,
                              height: _Constants.imageSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                          subtitle: AppText(
                            text: track.artistName ?? "",
                            style: AppTextStyle.bodyM,

                            color: _Constants.subtitleColor,
                          ),
                        );
                      }).toList(),
                    ),
                    duration: _Constants.animationDuration,
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),

      floatingActionButton: _isAtBottom
          ? Padding(
              padding: EdgeInsets.only(
                right: 5.w,
                bottom: bottomHeight,
                left: 5.w,
              ),
              child: InkWell(
                onTap: _scrollToTop,
                child: Container(
                  height: _Constants.fabSize,
                  width: _Constants.fabSize,
                  decoration: BoxDecoration(
                    color: _Constants.fabColor,
                    borderRadius: _Constants.fabRadius,
                  ),
                  child: AppIcon(
                    icon: Icons.arrow_upward_outlined,
                    color: Colors.white,
                    size: AppIconSize.large,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

abstract final class _Constants {
  //Colors
  static const Color appBarBgColor = AppColors.background;
  static const Color dividerColor = AppColors.grey;
  static const Color subtitleColor = AppColors.grey;
  static const Color fabColor = AppColors.green;
  //Padding & Margin
  static final EdgeInsets headerPadding = EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 10.h,
  );
  static final EdgeInsets dividerPadding = EdgeInsets.symmetric(
    horizontal: 20.w,
  );

  //Sizes & Radius
  static final double fabSize = 40.w;
  static final double imageSize = 50.w;
  static final BorderRadius imageRadius = BorderRadius.circular(10.r);
  static final BorderRadius fabRadius = BorderRadius.circular(50.r);
  //Animation Values
  static const double turnsOpen = 0.5;
  static const double turnsClosed = 0.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration scrollDuration = Duration(milliseconds: 300);
}
