import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/widgets/custom_bottom_sheet.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _MainTab.values.map((tab) {
          if (tab == _MainTab.create) {
            return GestureDetector(
              onTap: () => CustomBottomSheet().customShowModalBottom(context),
              child: Column(
                children: [
                  tab.icon,
                  SizedBox(height: 4),
                  Text(
                    tab.title,
                    style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSize),
                  ),
                ],
              ),
            );
          } else {
            return GestureDetector(
              child: Column(
                children: [
                  tab.icon,
                  SizedBox(height: 4),
                  Text(
                    tab.title,
                    style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSize),
                  ),
                ],
              ),
              onTap: () => tabController.index = _MainTab.values.indexOf(tab),
            );
          }
        }).toList(),
      ),
    );
  }
}

enum _MainTab { home, search, library, premium, create }

extension _MainTabExtension on _MainTab {
  String get title {
    switch (this) {
      case _MainTab.home:
        return "Ana Sayfa";
      case _MainTab.search:
        return "Ara";
      case _MainTab.library:
        return "Kitaplığın";
      case _MainTab.premium:
        return "Premium";
      case _MainTab.create:
        return "Oluştur";
    }
  }

  FaIcon faIcon(icon) {
    return FaIcon(icon, size: AppSizes.iconSize, color: AppColors.white);
  }

  Icon get icon {
    switch (this) {
      case _MainTab.home:
        return faIcon(FontAwesomeIcons.house);
      case _MainTab.search:
        return faIcon(FontAwesomeIcons.magnifyingGlass);
      case _MainTab.library:
        return faIcon(FontAwesomeIcons.bookBookmark);
      case _MainTab.premium:
        return faIcon(FontAwesomeIcons.spotify);
      case _MainTab.create:
        return faIcon(FontAwesomeIcons.plus);
    }
  }
}
