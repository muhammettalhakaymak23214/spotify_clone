import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class PlaylistChangeCollaborativeAlert {
  Future<dynamic> playlistChangeCollaborativeShowDialog(
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
          backgroundColor: AppColors.white,
          title: CustomText(
            data: l10n.bsUpdatePlaylistViewMakePublicAreYouSure,
            textSize: TextSize.large,
            color: AppColors.black,
            textWeight: TextWeight.bold,
            textAlign: TextAlign.center,
          ),
          actions: [
            CustomText(
              data: l10n.bsUpdatePlaylistViewMakePubliDesciription,
              color: AppColors.black,
              textSize: TextSize.medium,
              //textWeight: TextWeight.bold,
              textAlign: TextAlign.center,
            ),

            Container(
              width: double.infinity,
              // color: Colors.amber,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                      ),
                      child: CustomText(
                        data: l10n.bsUpdatePlaylistViewMakePublic,
                        textSize: TextSize.medium,
                        textWeight: TextWeight.bold,
                        color: AppColors.black,
                      ),
                      onPressed: () async {
                        final bool succesfull = await viewModel
                            .changePlaylistCollaborative(
                              playlistId: playlistId,
                              playlistIsCollaborative: true,
                            );
                        await viewModel.getPlaylistDetail(
                          playlistId: playlistId,
                        );
                        if (succesfull) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: CustomText(
                      data: l10n.updatePlaylistViewCancel,
                      textSize: TextSize.medium,
                      textWeight: TextWeight.bold,
                      color: AppColors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
