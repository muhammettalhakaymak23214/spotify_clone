import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
//import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class PlaylistDeleteAlert {
  Future<dynamic> playlistDeleteShowDialog(
    BuildContext context, {
    required UpdatePlaylistViewModel viewModel,
    required String playlistId,
  }) {
     final l10n = AppLocalizations.of(context)!;
    return showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.cardBackground,
          title: CustomText(
            data: l10n.bsUpdatePlaylistViewDeletePlaylist,
            textSize: TextSize.medium,
            textWeight: TextWeight.bold,
          ),
          actions: [
            CustomText(
              data: viewModel.playlistName.value.length <= 20
                  ? l10n.bsUpdatePlaylistViewDeletePlaylistAreYouSure(viewModel.playlistName.value)
                  : l10n.bsUpdatePlaylistViewDeletePlaylistAreYouSure(viewModel.playlistName.value.substring(0, 20)),
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
                      data: l10n.bsUpdatePlaylistViewCancel,
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
                      data: l10n.bsUpdatePlaylistViewDelete,
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
