import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/view/playlist_image_change_view.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/alerts/playlist_change_collaborative_alert.dart';
import 'package:spotify_clone/widgets/alerts/playlist_delete_alert.dart';

class UpdatePlaylistBottomSheet {
  Future<dynamic> updatePlaylistBottomSheet(
    BuildContext context, {
    required UpdatePlaylistViewModel viewModel,
    required String playlistId,
  }) {
    TextEditingController controllerPlaylistName = TextEditingController();

    TextEditingController controllerPlaylistDesciription =
        TextEditingController();

    final l10n = AppLocalizations.of(context)!;
    final double systemNavigationBarHeight = MediaQuery.of(context).viewPadding.bottom;

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: _Constants.backgroundColor,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: (MediaQuery.of(context).viewInsets.bottom) > systemNavigationBarHeight
              ? (MediaQuery.of(context).viewInsets.bottom) - systemNavigationBarHeight
              : (MediaQuery.of(context).viewInsets.bottom),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: _Constants.sheetHeight + systemNavigationBarHeight,
            decoration: BoxDecoration(
              color: _Constants.backgroundColor,
              borderRadius: _Constants.radius20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
     
                Padding(
                  padding: _Constants.paddingH20V10,
                  child: SizedBox(
                    height: _Constants.h50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: AppText(
                            text: l10n.bsUpdatePlaylistViewCancel,
                            //textSize: TextSize.medium,//////////////////////////////////////////////////
                            //textWeight: TextWeight.bold,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        AppText(
                          text: l10n.bsUpdatePlaylistViewNameAndDesciription,
                          style: AppTextStyle.titleL,
                          //textSize: TextSize.large,
                         // textWeight: TextWeight.bold,////////////////////////////////////////////////
                        ),
                        GestureDetector(
                          child: AppText(
                            text: l10n.updatePlaylistViewSave,
                          //  textSize: TextSize.medium,///////////////////////////////////////////////////////////////
                            //textWeight: TextWeight.bold,
                            color: _Constants.greenColor,
                          ),
                          onTap: () async {
                            await viewModel.changePlaylistNameAndDesciription(
                              playlistId: playlistId,
                              name: controllerPlaylistName.text,
                              desciription: controllerPlaylistDesciription.text,
                            );
                            await viewModel.getPlaylistDetail(playlistId: playlistId);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
             
                Padding(
                  padding: _Constants.paddingH10V10,
                  child: Container(
                    height: _Constants.h150,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        viewModel.playlistCoverImage.value.isNotEmpty
                            ? Container(
                                height: _Constants.w150,
                                width: _Constants.w150,
                                decoration: BoxDecoration(
                                  borderRadius: _Constants.radius10,
                                  color: _Constants.cardColor,
                                ),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: _Constants.w150,
                                      width: _Constants.w150,
                                      child: ClipRRect(
                                        borderRadius: _Constants.radius10,
                                        child: Image.network(
                                          viewModel.playlistCoverImage.value,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: _Constants.pos5,
                                      bottom: _Constants.pos5,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PlaylistImageChangeView(
                                                playlistCoverImageUrl:
                                                    viewModel.playlistCoverImage.value,
                                                viewModel: viewModel,
                                                playlistId: playlistId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: _Constants.w30,
                                          width: _Constants.w30,
                                          decoration: BoxDecoration(
                                            color: _Constants.blackOpacity,
                                            borderRadius: _Constants.radius50,
                                          ),
                                          child: AppIcon(icon: Icons.edit , size: AppIconSize.tiny,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlaylistImageChangeView(
                                        playlistCoverImageUrl:
                                            viewModel.playlistCoverImage.value,
                                        viewModel: viewModel,
                                        playlistId: playlistId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: _Constants.h150,
                                  width: _Constants.w150,
                                  decoration: BoxDecoration(
                                    borderRadius: _Constants.radius10,
                                    color: _Constants.cardColor,
                                  ),
                                  child: AppIcon(
                                    icon: Icons.mode_edit_outline_outlined,
                                    size: AppIconSize.huge,
                                    color: _Constants.greyColor,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: _Constants.h150,
                          width: _Constants.w180,
                          child: Column(
                            children: [
                              Container(
                                width: _Constants.w180,
                                height: _Constants.h40,
                                decoration: BoxDecoration(
                                  borderRadius: _Constants.radius5,
                                  color: _Constants.darkGreyColor,
                                ),
                                child: Padding(
                                  padding: _Constants.paddingH10V4,
                                  child: TextField(
                                    style: TextStyle(color: _Constants.whiteColor),
                                    onTap: () {},
                                    controller: controllerPlaylistName,
                                    decoration: InputDecoration(
                                      hintText: viewModel.playlistName.value,
                                      hintStyle: TextStyle(color: _Constants.greyColor),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: _Constants.h30),
                              Container(
                                width: _Constants.w180,
                                height: _Constants.h80,
                                decoration: BoxDecoration(
                                  borderRadius: _Constants.radius5,
                                  color: _Constants.darkGreyColor,
                                ),
                                child: Padding(
                                  padding: _Constants.paddingH10V4,
                                  child: TextField(
                                    style: TextStyle(color: _Constants.whiteColor),
                                    minLines: 2,
                                    maxLines: 2,
                                    onTap: () {},
                                    controller: controllerPlaylistDesciription,
                                    decoration: InputDecoration(
                                      hintText: viewModel.playlistDesciription.value,
                                      hintStyle: TextStyle(color: _Constants.greyColor),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Observer(
                  builder: (context) {
                    final bool iscollaborative =
                        viewModel.playlistIscollaborative.value;
                    return GestureDetector(
                      child: Padding(
                        padding: _Constants.paddingActionRow,
                        child: Row(
                          children: [
                            AppIcon(
                              icon: iscollaborative ? Icons.lock : Icons.public_outlined,
                              color: _Constants.greyColor,
                              //iconSize: IconSize.medium,
                            ),
                            SizedBox(width: _Constants.w5),
                            AppText(
                              text: iscollaborative
                                  ? l10n.bsUpdatePlaylistViewMakePrivate
                                  : l10n.bsUpdatePlaylistViewMakePublic,
                           //   textSize: TextSize.medium,////////////////////////////////////////////////////////////////////////
                              color: _Constants.greyColor,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (!iscollaborative) {
                          await PlaylistChangeCollaborativeAlert()
                              .playlistChangeCollaborativeShowDialog(
                            context,
                            viewModel: viewModel,
                            playlistId: playlistId,
                          );
                        } else {
                          await viewModel.changePlaylistCollaborative(
                            playlistId: playlistId,
                            playlistIsCollaborative: false,
                          );
                          await viewModel.getPlaylistDetail(playlistId: playlistId);
                        }
                      },
                    );
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: _Constants.paddingActionRow,
                    child: Row(
                      children: [
                        AppIcon(
                          icon: Icons.delete,
                          color: _Constants.greyColor,
                          //iconSize: IconSize.medium,
                        ),
                        SizedBox(width: _Constants.w5),
                        AppText(
                          text: l10n.bsUpdatePlaylistViewDeletePlaylist,
                        //  textSize: TextSize.medium,///////////////////////////////////////////////////////////
                          color: _Constants.greyColor,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await PlaylistDeleteAlert().playlistDeleteShowDialog(
                      context,
                      viewModel: viewModel,
                      playlistId: playlistId,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class _Constants {
  static Color get backgroundColor => AppColors.background;
  static Color get cardColor => AppColors.cardBackground;
  static Color get greyColor => AppColors.grey;
  static Color get greenColor => AppColors.green;
  static Color get whiteColor => AppColors.white;

  static Color get blackOpacity => const Color.fromARGB(124, 0, 0, 0);
  static Color get darkGreyColor => const Color.fromARGB(255, 45, 45, 45);

  static double get sheetHeight => 360.0.h;
  static double get insetLimit => 50.0.h;
  static double get h150 => 150.h;
  static double get h80 => 80.h;
  static double get h50 => 50.h;
  static double get h40 => 40.h;
  static double get h30 => 30.h;
  static double get w180 => 180.w;
  static double get w150 => 150.w;
  static double get w30 => 30.w;
  static double get w5 => 5.w;
  static double get pos5 => 5.0;

  static EdgeInsets get paddingH20V10 =>  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h);
  static EdgeInsets get paddingH10V10 =>  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h);
  static EdgeInsets get paddingH10V4 => EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);
  static EdgeInsets get paddingActionRow =>  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 10.h, right: 20.w);

  static BorderRadius get radius20 =>  BorderRadius.all(Radius.circular(20.r));
  static BorderRadius get radius10 => BorderRadius.circular(10.r);
  static BorderRadius get radius5 => BorderRadius.circular(5.r);
  static BorderRadius get radius50 => BorderRadius.circular(50.r);
}