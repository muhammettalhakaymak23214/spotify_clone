import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class PlaylistDeleteAlert {
  Future<dynamic> playlistDeleteShowDialog(
    BuildContext context, {
    required UpdatePlaylistViewModel viewModel,
    required String playlistId,
  }) {
    return showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.blackPanther,
          title: CustomText(
            data: AppStrings.sDDeletePlaylistTitle,
            textSize: TextSize.medium,
            textWeight: TextWeight.bold,
          ),
          actions: [
            CustomText(
              data: viewModel.playlistName.value.length <= 20
                  ? "${viewModel.playlistName.value} adlı öğeyi silmek istediğine emin misin?"
                  : "${viewModel.playlistName.value.substring(0, 20)}... adlı öğeyi silmek istediğine emin misin?",
              textSize: TextSize.medium,
              textWeight: TextWeight.bold,
            ),

            Padding(
              padding: const EdgeInsets.only(right: 20, top: 30, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: CustomText(
                      data: AppStrings.sDCancel,
                      textSize: TextSize.medium,
                      textWeight: TextWeight.bold,
                      color: AppColors.green,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    child: CustomText(
                      data: AppStrings.sDDelete,
                      textSize: TextSize.medium,
                      textWeight: TextWeight.bold,
                      color: AppColors.green,
                    ),
                    onTap: () async {
                      await viewModel.deletePlaylist(playlistId: playlistId);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainTabView(initialIndex: 2),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
