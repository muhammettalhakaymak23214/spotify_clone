import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkToneInk,
      child: Column(
        children: [
          _AccountHeaderListTile(),
          Divider(color: AppColors.white),
          _CustomListTile(
            title: _DrawerMenuItem.addAccount.title,
            icon: _DrawerMenuItem.addAccount.icon,
          ),
          _CustomListTile(
            title: _DrawerMenuItem.updates.title,
            icon: _DrawerMenuItem.updates.icon,
          ),
          _CustomListTile(
            title: _DrawerMenuItem.listeningStats.title,
            icon: _DrawerMenuItem.listeningStats.icon,
          ),
          _CustomListTile(
            title: _DrawerMenuItem.recentlyPlayed.title,
            icon: _DrawerMenuItem.recentlyPlayed.icon,
          ),
          _CustomListTile(
            title: _DrawerMenuItem.notifications.title,
            icon: _DrawerMenuItem.notifications.icon,
          ),
          _CustomListTile(
            title: _DrawerMenuItem.settingsPrivacy.title,
            icon: _DrawerMenuItem.settingsPrivacy.icon,
          ),
        ],
      ),
    );
  }
}

class _AccountHeaderListTile extends StatelessWidget {
  const _AccountHeaderListTile();

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = EdgeInsets.only(top: 30, left: 20);
    return ListTile(
      contentPadding: padding,
      leading: Container(
        width: AppSizes.avatarSize,
        height: AppSizes.avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blackPanther,
        ),
        child: Center(
          child: Image.asset(
            AppStrings.profileImagePath,
            fit: BoxFit.fill,
            height: AppSizes.avatarSize,
          ),
        ),
      ),
      title: Text(AppStrings.accountHeader, style: TextStyle(fontSize: 20)),
      subtitle: Text(AppStrings.profileView, style: TextStyle(fontSize: 13)),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({required this.title, required this.icon});
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
      ),
    );
  }
}

enum _DrawerMenuItem {
  addAccount,
  updates,
  listeningStats,
  recentlyPlayed,
  notifications,
  settingsPrivacy,
}

extension _DrawerMenuItemExtension on _DrawerMenuItem {
  String get title {
    switch (this) {
      case _DrawerMenuItem.addAccount:
        return AppStrings.addAccount;
      case _DrawerMenuItem.updates:
        return AppStrings.updates;
      case _DrawerMenuItem.listeningStats:
        return AppStrings.listeningStats;
      case _DrawerMenuItem.recentlyPlayed:
        return AppStrings.recentlyPlayed;
      case _DrawerMenuItem.notifications:
        return AppStrings.notifications;
      case _DrawerMenuItem.settingsPrivacy:
        return AppStrings.settingsPrivacy;
    }
  }

  FaIcon faIcon(icon) {
    return FaIcon(icon, size: AppSizes.size25, color: AppColors.white);
  }

  Icon get icon {
    switch (this) {
      case _DrawerMenuItem.addAccount:
        return faIcon(FontAwesomeIcons.plus);
      case _DrawerMenuItem.updates:
        return faIcon(FontAwesomeIcons.bolt);
      case _DrawerMenuItem.listeningStats:
        return faIcon(FontAwesomeIcons.chartLine);
      case _DrawerMenuItem.recentlyPlayed:
        return faIcon(FontAwesomeIcons.clock);
      case _DrawerMenuItem.notifications:
        return faIcon(FontAwesomeIcons.bullhorn);
      case _DrawerMenuItem.settingsPrivacy:
        return faIcon(FontAwesomeIcons.gear);
    }
  }
}
