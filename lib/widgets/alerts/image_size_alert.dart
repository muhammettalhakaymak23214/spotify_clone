import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class FileSizeWarningAlertDialog extends StatelessWidget {
  const FileSizeWarningAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      ),
      title: CustomText(
        data: l10n.bschangePlaylistImageViewErrorImageSize,
        color: AppColors.black,
        textSize: TextSize.large,
        textWeight: TextWeight.bold,
      ),
      content: CustomText(
        data: l10n.bschangePlaylistImageViewPleaseSmallImage,
        color: AppColors.black,
        textSize: TextSize.medium,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: CustomText(
            data: l10n.bschangePlaylistImageViewOKey,
            color: AppColors.green,
            textSize: TextSize.medium,
          ),
        ),
      ],
    );
  }
}
