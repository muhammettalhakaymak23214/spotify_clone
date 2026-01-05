import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/navigation_service.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surfaceVariant,
      child: ListView(
        padding: _Constants.paddingListView,
        children: [
          const _AccountHeaderListTile(),
          const Divider(),
          ..._DrawerMenuItem.values.map(
            (item) => _CustomListTile(
              title: item.title(context),
              icon: item.buildIcon(context),
              onTap: () => item.onTap(context),
            ),
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
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      contentPadding: _Constants.paddingAccountHeader,
      leading: Container(
        width: _Constants.avatarContainerSize.w,
        height: _Constants.avatarContainerSize.h,
        decoration: _Constants.boxDecoration,
        child: Center(
          child: Image.asset(
            AppStrings.profileImagePath,
            fit: BoxFit.cover,
            height: _Constants.avatarSize.h,
            width: _Constants.avatarSize.w,
          ),
        ),
      ),
      title: AppText(text: AppStrings.accountHeader, style: AppTextStyle.h3),
      subtitle: AppText(
        text: l10n.drawerProfileView,
        style: AppTextStyle.bodyS,
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final Widget icon;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: _Constants.paddingListTile,
      onTap: onTap,
      leading: icon,
      title: AppText(text: title, style: AppTextStyle.bodyL),
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
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case _DrawerMenuItem.addAccount:
        return l10n.drawerAddAccount;
      case _DrawerMenuItem.updates:
        return l10n.drawerUpdates;
      case _DrawerMenuItem.listeningStats:
        return l10n.drawerListeningStats;
      case _DrawerMenuItem.recentlyPlayed:
        return l10n.drawerRecentlyPlayed;
      case _DrawerMenuItem.notifications:
        return l10n.drawerNotifications;
      case _DrawerMenuItem.settingsPrivacy:
        return l10n.drawerSettingsPrivacy;
    }
  }

  FaIcon _faIcon(IconData iconData, BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return FaIcon(iconData, size: iconTheme.size, color: iconTheme.color);
  }

  Widget buildIcon(BuildContext context) {
    switch (this) {
      case _DrawerMenuItem.addAccount:
        return _faIcon(FontAwesomeIcons.plus, context);
      case _DrawerMenuItem.updates:
        return _faIcon(FontAwesomeIcons.bolt, context);
      case _DrawerMenuItem.listeningStats:
        return _faIcon(FontAwesomeIcons.chartLine, context);
      case _DrawerMenuItem.recentlyPlayed:
        return _faIcon(FontAwesomeIcons.clock, context);
      case _DrawerMenuItem.notifications:
        return _faIcon(FontAwesomeIcons.bullhorn, context);
      case _DrawerMenuItem.settingsPrivacy:
        return _faIcon(FontAwesomeIcons.gear, context);
    }
  }

  void onTap(BuildContext context) {
    switch (this) {
      case _DrawerMenuItem.recentlyPlayed:
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!context.mounted) return;
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 200), () {
            NavigationService.instance.pushAndRemoveUntil(
              const MainTabView(initialIndex: 4),
              routeName: '/main_recently_played',
            );
          });
        });
        break;
      default:
        debugPrint("$this");
        break;
    }
  }
}

abstract final class _Constants {
  //Padding
  static EdgeInsets get paddingAccountHeader =>
      EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w);
  static EdgeInsets get paddingListTile =>
      EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get paddingListView => EdgeInsets.zero;
  //Size
  static double get avatarContainerSize => 40;
  static double get avatarSize => 35;
  //Decoration
  static BoxDecoration get boxDecoration =>
      BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceVariant);
}
