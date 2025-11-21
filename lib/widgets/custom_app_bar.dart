import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
   CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.appBarHeight,
    this.bottomButtonsData,
    this.actionButtonsData,
  });

  final Widget? title;
  final Image? leading;
  final double? appBarHeight;
  final List<AppBarButtonData>? bottomButtonsData;
  final List<AppBarButtonData>? actionButtonsData;

  final Size minSize = Size(0, 30);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColors.darkToneInk,
      leading: _leading(),
      actions: (actionButtonsData != null && actionButtonsData!.isNotEmpty)
          ? actionButtonsData!.map((data) => _actions(data)).toList()
          : null,
      title: _title(),
      bottom: (bottomButtonsData != null && bottomButtonsData!.isNotEmpty)
          ? _bottom(context)
          : null,
    );
  }

  PreferredSize _bottom(BuildContext context) {
    return PreferredSize(
            preferredSize: AppSizes.bottomPreferredSize,
            child: Container(
              padding: AppPaddings.horizontal10,
              height: AppSizes.size50,
              child: ListView(
                padding: AppPaddings.all10,
                scrollDirection: Axis.horizontal,
                children: bottomButtonsData!
                    .map(
                      (data) => Padding(
                        padding: AppPaddings.right10,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blackPanther,
                            padding: AppPaddings.horizontal10,
                            minimumSize: minSize,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: data.onPressed,
                          child: Text(
                            data.text,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }

  Padding _title() {
    return Padding(padding: AppPaddings.top10, child: title ?? SizedBox());
  }

  Padding _actions(AppBarButtonData data) {
    return Padding(
      padding: AppPaddings.actionsPadding,
      child: IconButton(
        color: AppColors.white,
        onPressed: data.onPressed,
        icon: data.icon ?? FaIcon(FontAwesomeIcons.adn),
      ),
    );
  }

  Padding _leading() {
    return Padding(
      padding: AppPaddings.leadingPadding,
      child: Container(
        width: AppSizes.avatarSize2,
        height: AppSizes.avatarSize2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blackPanther,
        ),
        child: Center(child: leading ?? SizedBox.shrink()),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}

class AppBarButtonData {
  AppBarButtonData({this.icon, this.text = "Boş", required this.onPressed});

  final String text;
  final Icon? icon;
  final VoidCallback onPressed;
}
