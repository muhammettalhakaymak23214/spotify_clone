import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/navigation_service.dart';
import 'package:spotify_clone/view/create_playlist_view.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class CreateBottomSheet {
  Future<dynamic> customShowModalBottom(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: _Constants.showModalBottomSheetBgColor,
      context: context,
      builder: (context) => Padding(
        padding: _Constants.sheetOuterPadding,
        child: Container(
          width: _Constants.sheetWidth,
          height: _Constants.sheetHeight,
          decoration: BoxDecoration(
            color: _Constants.bgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(_Constants.borderRadius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CustomListTile(
                title: l10n.createPlaylistTitle,
                subTitle: l10n.createPlaylistSubtitle,
                icon: Icons.music_note_outlined,
                onPressed: () {
                  Navigator.pop(context); 
                  NavigationService.instance.push(
                    const CreatePlaylistView(),
                    routeName: '/create-playlist',
                  );
                },
              ),
              _CustomListTile(
                title: l10n.createCollaborativeTitle,
                subTitle: l10n.createCollaborativeSubtitle,
                icon: Icons.person_2_outlined,
                onPressed: () {},
              ),
              _CustomListTile(
                title: l10n.createBlendTitle,
                subTitle: l10n.createBlendSubtitle,
                icon: Icons.circle,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: _Constants.avatarContainerSize,
        height: _Constants.avatarContainerSize,
        decoration: _Constants.containerDecoration,
        child: Center(child: Icon(icon, size: _Constants.iconSize)),
      ),
      title: Padding(
        padding: _Constants.paddingListTileTitle,
        child: AppText(text: title, style: AppTextStyle.bodyM),
      ),
      subtitle: AppText(text: subTitle, style: AppTextStyle.bodyS),
      contentPadding: _Constants.paddingListTileContentPadding,
      onTap: onPressed,
    );
  }
}

abstract final class _Constants {
  //Size
  static double get iconSize => 22.sp;
  static double get avatarContainerSize => 48.w;
  static double get sheetHeight => 310.h;
  static double get sheetWidth => 0.95.sw;
  static double get borderRadius => 20.r;
  //Decoration
  static BoxDecoration get containerDecoration => const BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.cardBackground,
  );
  //Padding
  static EdgeInsets get paddingListTileTitle => EdgeInsets.only(bottom: 4.0);
  static EdgeInsets get paddingListTileContentPadding => EdgeInsets.all(12.0);
  static EdgeInsets get sheetOuterPadding => EdgeInsets.only(bottom: 130.h);
  //Color
  static const Color showModalBottomSheetBgColor = AppColors.transparent;
  static const Color bgColor = AppColors.background;
}
