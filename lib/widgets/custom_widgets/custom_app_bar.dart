import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    this.onTap,
    this.viewModel, required this.selectedIndex,
  });

  final Widget? title;
  final Image? leading;
  final VoidCallback? onTap;
  final double? appBarHeight;
  final List<AppBarButtonData>? bottomButtonsData;
  final List<AppBarButtonData>? actionButtonsData;
  final dynamic viewModel;
  final int selectedIndex;

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
      child: Observer(
        builder: (context) {
          return Container(
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
                          backgroundColor: data.index == selectedIndex ? Colors.green   : AppColors.blackPanther,
                          //backgroundColor: AppColors.blackPanther,

                          padding: AppPaddings.horizontal10,
                          minimumSize: minSize,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed:
                        (){
                          debugPrint("selectedIndex : $selectedIndex");
                          debugPrint("data index : ${data.index}");
                          
                          data.onPressed();
                        },
                        // data.onPressed,

                        child: Text(
                          // index.toString(),
                          data.text,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.white),
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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSizes.avatarSize2,
          height: AppSizes.avatarSize2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
         //   color: AppColors.blackPanther,
          ),
          child: Center(child: leading ?? SizedBox.shrink()),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}

class AppBarButtonData {
  AppBarButtonData( {required this.index,
    this.type = "Boş",
    this.icon,
    this.text = "Boş",
    required this.onPressed,
  });
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;
  final String type;
  final int index;
}
