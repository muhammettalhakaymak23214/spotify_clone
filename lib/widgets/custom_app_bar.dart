import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.appBarHeight,
    this.bottomButtonsData, this.actionButtonsData,
  });

  final Widget? title;
  final Image? leading;
  final double? appBarHeight;
  final List<AppBarButtonData>? bottomButtonsData;
  final List<AppBarButtonData>? actionButtonsData;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColors.darkToneInk,

      leading: Padding(
        padding: const EdgeInsets.only(left: 15, right: 5),
        child: Container(
            width: AppSizes.avatarSize2,
            height: AppSizes.avatarSize2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blackPanther,
            ),
            child: Center(child: leading ?? SizedBox.shrink()),
          ),
      ),

      actions: (actionButtonsData != null && actionButtonsData!.isNotEmpty) ? actionButtonsData!.map((data) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child:  IconButton(
          color: Colors.white,
          onPressed: data.onPressed, icon: data.icon ?? FaIcon(FontAwesomeIcons.adn)
        )
      )).toList() : null,

      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: title ?? SizedBox(),
      ),

      bottom: (bottomButtonsData != null && bottomButtonsData!.isNotEmpty)
          ? PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                //color: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 50,
                child: ListView(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  children: bottomButtonsData!
                      .map(
                        (data) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blackPanther,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              minimumSize: Size(0, 30), 
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: data.onPressed,
                            child: Text(data.text , style: TextStyle(color: AppColors.white),),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}

class AppBarButtonData {
  AppBarButtonData({this.icon, this.text = "null", required this.onPressed});

  final String text;
  final Icon? icon;
  final VoidCallback onPressed;
}


