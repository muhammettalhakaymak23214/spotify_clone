import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/helpers/image_picker_helper.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';
import 'package:spotify_clone/widgets/alerts/image_size_alert.dart';

class PlaylistImageChangeView extends StatefulWidget {
  const PlaylistImageChangeView({
    super.key,
    required this.playlistCoverImageUrl,
    required this.viewModel,
    required this.playlistId,
  });
  final UpdatePlaylistViewModel viewModel;
  final String playlistId;
  final String playlistCoverImageUrl;

  @override
  State<PlaylistImageChangeView> createState() =>
      _PlaylistImageChangeViewState();
}

class _PlaylistImageChangeViewState extends State<PlaylistImageChangeView> {
  //Variables
  File? selectedImage;
  bool isPressedAdd = false;
  bool isPressedRemove = false;

  @override
  void dispose() {
    super.dispose();
    isPressedAdd = false;
    isPressedRemove = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.darkToneInk),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              color: AppColors.grey,
              child: _buildCoverImage(),
            ),
            SizedBox(height: 25),
            selectedImage == null
                ? ElevatedButton(
                    onPressed: () async {
                      final tempSelectedImage = await ImagePickerHelper()
                          .pickImageFromGallery();
                      if (tempSelectedImage == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FileSizeWarningAlertDialog();
                          },
                        );
                      } else {
                        selectedImage = tempSelectedImage;
                        setState(() {});
                      }
                    },
                    child: CustomText(
                      data: "Kapak görselini değiştir",
                      color: AppColors.black,
                      textSize: TextSize.medium,
                      textWeight: TextWeight.bold,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(
                          child: SizedBox(
                            child: Lottie.asset(
                              'assets/lottie/lottie_loading.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                      if (!isPressedAdd) {
                        isPressedAdd = true;
                        await widget.viewModel.updatePlaylistCover(
                          playlistId: widget.playlistId,
                          imageFile: selectedImage!,
                        );
                        await widget.viewModel.getPlaylistDetail(
                          playlistId: widget.playlistId,
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: CustomText(
                      data: "Onayla",
                      color: AppColors.black,
                      textSize: TextSize.medium,
                      textWeight: TextWeight.bold,
                    ),
                  ),

            SizedBox(height: 10),
            widget.playlistCoverImageUrl.isNotEmpty
                ? ElevatedButton(
                    onPressed: () async {
                      if (!isPressedRemove) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => Center(
                            child: SizedBox(
                              child: Lottie.asset(
                                'assets/lottie/lottie_loading.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                        isPressedRemove = true;
                        selectedImage = await ImagePickerHelper().assetToFile(
                          "assets/png/default_playlist_cover_image.jpg",
                        );
                        await widget.viewModel.updatePlaylistCover(
                          playlistId: widget.playlistId,
                          imageFile: selectedImage!,
                        );
                        await widget.viewModel.getPlaylistDetail(
                          playlistId: widget.playlistId,
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: CustomText(
                      data: "Kaldır",
                      color: AppColors.black,
                      textSize: TextSize.medium,
                      textWeight: TextWeight.bold,
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    if (selectedImage != null) {
      return Image.file(selectedImage!, fit: BoxFit.cover);
    }

    if (widget.playlistCoverImageUrl.isNotEmpty) {
      return Image.network(widget.playlistCoverImageUrl, fit: BoxFit.cover);
    }

    return CustomIcon(
      iconData: Icons.music_note,
      iconSize: IconSize.mega,
      color: AppColors.planSectionColor,
    );
  }
}

