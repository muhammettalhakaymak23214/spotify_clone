import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class FileSizeWarningAlertDialog extends StatelessWidget {
  const FileSizeWarningAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      ),
      title: CustomText(
        data: "Dosya boyutu çok büyük!",
        color: AppColors.black,
        textSize: TextSize.large,
        textWeight: TextWeight.bold,
      ),
      content: CustomText(
        data: "Lütfen daha küçük bir resim seçin.",
        color: AppColors.black,
        textSize: TextSize.medium,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: CustomText(
            data: "Tamam",
            color: AppColors.green,
            textSize: TextSize.medium,
          ),
        ),
      ],
    );
  }
}
