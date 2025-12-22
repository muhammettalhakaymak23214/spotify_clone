import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view/create_playlist_view.dart';

class CreateBottomSheet {
  Future<dynamic> customShowModalBottom(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: AppPaddings.bottom130,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: AppSizes.bottomSheetHeight,
          decoration: BoxDecoration(
            color: AppColors.darkToneInk,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CustomListTile(
                title: AppStrings.title1,
                subTitle: AppStrings.subtitle1,
                icon: Icons.music_note_outlined,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePlaylistView(),
                    ),
                  );
                },
              ),
              _CustomListTile(
                title: AppStrings.title2,
                subTitle: AppStrings.subtitle2,
                icon: Icons.person_2_outlined,
                onPressed: () {},
              ),
              _CustomListTile(
                title: AppStrings.title3,
                subTitle: AppStrings.subtitle3,
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
        width: AppSizes.avatarSize,
        height: AppSizes.avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blackPanther,
        ),
        child: Center(child: Icon(icon, color: AppColors.noghreiSilver)),
      ),
      title: Padding(padding: AppPaddings.bottom10, child: Text(title)),
      subtitle: Text(subTitle),
      contentPadding: AppPaddings.all10,
      onTap: onPressed,
    );
  }
}
