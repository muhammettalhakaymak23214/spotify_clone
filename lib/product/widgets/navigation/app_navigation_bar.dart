import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/product/widgets/bottom_sheets/create_bottom_sheet.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.tabController.index;
    widget.tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted && currentIndex != widget.tabController.index) {
      setState(() => currentIndex = widget.tabController.index);
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: _MainTab.values.map((tab) {
          final isSelected = currentIndex == tab.index;

          return Expanded(
            child: _BottomNavItem(
              tab: tab,
              isSelected: isSelected,
              onTap: () {
                if (tab == _MainTab.create) {
                  CreateBottomSheet().customShowModalBottom(context);
                } else {
                  widget.tabController.animateTo(tab.index);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final _MainTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected && tab != _MainTab.create
        ? AppColors.green
        : AppColors.grey;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedScale(
        scale: isSelected ? _Constants.selectedScale : _Constants.unselectedScale,
        duration: _Constants.animationDuration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tab.getIcon(color, _Constants.iconSize),
            Padding(
              padding: _Constants.itemPadding,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AppText(
                  text: tab.title(context),
                  style: AppTextStyle.labelS,
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _MainTab { home, search, library, premium, create }

extension _MainTabExtension on _MainTab {

  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      _MainTab.home => l10n.bottomNavigatorHome,
      _MainTab.search => l10n.bottomNavigatorSearch,
      _MainTab.library => l10n.bottomNavigatorLibrary,
      _MainTab.premium => l10n.bottomNavigatorPremium,
      _MainTab.create => l10n.bottomNavigatorCreate,
    };
  }

  Widget getIcon(Color color, double size) {
    final iconData = switch (this) {
      _MainTab.home => FontAwesomeIcons.house,
      _MainTab.search => FontAwesomeIcons.magnifyingGlass,
      _MainTab.library => FontAwesomeIcons.bookBookmark,
      _MainTab.premium => FontAwesomeIcons.spotify,
      _MainTab.create => FontAwesomeIcons.plus,
    };
    return FaIcon(iconData, size: size, color: color);
  }
}

abstract final class _Constants {
  //Size
  static double get iconSize => 22.sp;
  //Padding
  static EdgeInsets get itemPadding => EdgeInsets.only(left: 2.w, right: 2.w, top: 4.h);
  // Durations
  static const Duration animationDuration = Duration(milliseconds: 150);
  // Scales
  static const double selectedScale = 1.05;
  static const double unselectedScale = 1.0;
}
