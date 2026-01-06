import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.appBarHeight,
    this.bottomButtonsData,
    this.actionButtonsData,
    this.onTap,
    this.viewModel,
    required this.selectedIndex,
  });

  final Widget? title;
  final Widget? leading;
  final VoidCallback? onTap;
  final double? appBarHeight;
  final List<AppBarButtonData>? bottomButtonsData;
  final List<AppBarButtonData>? actionButtonsData;
  final dynamic viewModel;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: _Constants.appBarBgColor,
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
      preferredSize: _Constants.bottomPreferredSize,
      child: Observer(
        builder: (context) {
          return Container(
            padding: _Constants.bottomContainerPadding,
            height: _Constants.bottomContainerHeight,
            child: ListView(
              padding: _Constants.bottomListPadding,
              scrollDirection: Axis.horizontal,
              children: bottomButtonsData!
                  .map(
                    (data) => Padding(
                      padding: _Constants.bottomButtonMargin,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: data.index == selectedIndex
                              ? _Constants.activeButtonBgColor
                              : _Constants.inactiveButtonBgColor,
                          padding: _Constants.bottomButtonInternalPadding,
                          minimumSize: _Constants.minButtonSize,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: data.onPressed,
                        child: AppText(
                          text: data.text,
                          style: AppTextStyle.labelM,
                          color: _Constants.buttonTextColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: _Constants.titlePadding,
      child: title ?? const SizedBox.shrink(),
    );
  }

  Widget _actions(AppBarButtonData data) {
    return Padding(
      padding: _Constants.actionPadding,
      child: IconButton(
        onPressed: data.onPressed,
        icon: data.icon ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _leading() {
    return Padding(
      padding: _Constants.leadingPadding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: _Constants.avatarSize,
          height: _Constants.avatarSize,
          decoration: _Constants.avatarDecoration,
          child: Center(child: leading ?? const SizedBox.shrink()),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}

class AppBarButtonData {
  AppBarButtonData({
    required this.index,
    this.type = "Boş",
    this.icon, 
    this.text = "Boş",
    required this.onPressed,
  });
  final String text;
  final Widget? icon;
  final VoidCallback onPressed;
  final String type;
  final int index;
}

abstract final class _Constants {
  //Color
  static Color get appBarBgColor => AppColors.background;
  static Color get activeButtonBgColor => Colors.green;
  static Color get inactiveButtonBgColor => AppColors.cardBackground;
  static Color get buttonTextColor => AppColors.white;
  //Size
  static Size get bottomPreferredSize => Size.fromHeight(50.h);
  static double get bottomContainerHeight => 50.h;
  static Size get minButtonSize => Size(0, 30.h);
  static double get avatarSize => 35.sp;
  //Padding
  static EdgeInsetsGeometry get leadingPadding => EdgeInsetsDirectional.only(start: 16.w);
  static EdgeInsetsGeometry get titlePadding => EdgeInsets.only(top: 10.h);
  static EdgeInsetsGeometry get actionPadding => EdgeInsetsDirectional.only(end: 8.w);
  static EdgeInsetsGeometry get bottomContainerPadding => EdgeInsets.symmetric(horizontal: 10.w);
  static EdgeInsetsGeometry get bottomListPadding => EdgeInsets.all(10.w);
  static EdgeInsetsGeometry get bottomButtonMargin => EdgeInsetsDirectional.only(end: 10.w);
  static EdgeInsetsGeometry get bottomButtonInternalPadding => EdgeInsets.symmetric(horizontal: 15.w);
  //Decoration
  static BoxDecoration get avatarDecoration => const BoxDecoration(
        shape: BoxShape.circle,
      );
}