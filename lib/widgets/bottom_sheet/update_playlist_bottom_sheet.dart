import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/view/playlist_image_change_view.dart';
import 'package:spotify_clone/view_model/update_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';
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

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.bottomSheetBgColor,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: (MediaQuery.of(context).viewInsets.bottom) > 50
              ? (MediaQuery.of(context).viewInsets.bottom) - 50
              : (MediaQuery.of(context).viewInsets.bottom),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: AppColors.darkToneInk,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Row1(
                  controllerPlaylistDesciription:
                      controllerPlaylistDesciription,
                  controllerPlaylistName: controllerPlaylistName,
                  playlistId: playlistId,
                  viewModel: viewModel,
                ),
                _Row2(
                  controllerPlaylistDesciription:
                      controllerPlaylistDesciription,
                  controllerPlaylistName: controllerPlaylistName,
                  playlistId: playlistId,
                  viewModel: viewModel,
                ),
                Observer(
                  builder: (context) {
                    final bool iscollaborative =
                        viewModel.playlistIscollaborative.value;
                    return _PlaylistChangeCollaborativeSection(
                      iscollaborative: iscollaborative,
                      playlistId: playlistId,
                      viewModel: viewModel,
                    );
                  },
                ),
                _PlaylistDeleteSection(
                  playlistId: playlistId,
                  viewModel: viewModel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistChangeCollaborativeSection extends StatelessWidget {
  const _PlaylistChangeCollaborativeSection({
    super.key,
    required this.iscollaborative,
    required this.viewModel,
    required this.playlistId,
  });
  final UpdatePlaylistViewModel viewModel;
  final String playlistId;
  final bool iscollaborative;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
        child: Row(
          children: [
            CustomIcon(
              iconData: iscollaborative ? Icons.lock : Icons.public_outlined,
              color: AppColors.grey,
              iconSize: IconSize.medium,
            ),
            SizedBox(width: 5),

            CustomText(
              data: iscollaborative
                  ? "Başka kullanıcılar için erişimi engelle"
                  : "Herkese açık yap",
              textSize: TextSize.medium,
              color: AppColors.grey,
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
  }
}

class _PlaylistDeleteSection extends StatelessWidget {
  const _PlaylistDeleteSection({
    super.key,
    required this.viewModel,
    required this.playlistId,
  });

  final UpdatePlaylistViewModel viewModel;
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
        child: Row(
          children: [
            CustomIcon(
              iconData: Icons.delete,
              color: AppColors.grey,
              iconSize: IconSize.medium,
            ),
            SizedBox(width: 5),
            CustomText(
              data: "Çalma listesini sil",
              textSize: TextSize.medium,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
      onTap: () async {
        //  await viewModel.getPlaylistDetail(playlistId: playlistId);
        await PlaylistDeleteAlert().playlistDeleteShowDialog(
          context,
          viewModel: viewModel,
          playlistId: playlistId,
        );
      },
    );
  }
}

class _Row2 extends StatelessWidget {
  const _Row2({
    super.key,
    required this.controllerPlaylistDesciription,
    required this.controllerPlaylistName,
    required this.viewModel,
    required this.playlistId,
  });

  final TextEditingController controllerPlaylistDesciription;
  final TextEditingController controllerPlaylistName;
  final UpdatePlaylistViewModel viewModel;
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        //  color: Colors.blue,
        height: 150,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            viewModel.playlistCoverImage.value.isNotEmpty
                ? Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.blackPanther,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            child: Image.network(
                              viewModel.playlistCoverImage.value,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
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
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(124, 0, 0, 0),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CustomIcon(iconData: Icons.edit),
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
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.blackPanther,
                      ),
                      child: CustomIcon(
                        iconData: Icons.mode_edit_outline_outlined,
                        iconSize: IconSize.mega,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
            Container(
              height: 150,
              width: 180,
              //color: Colors.red,
              child: Column(
                children: [
                  Container(
                    width: 180,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 45, 45, 45),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: TextField(
                        style: TextStyle(color: AppColors.white),
                        onTap: () {},
                        controller: controllerPlaylistName,
                        decoration: InputDecoration(
                          hintText: viewModel.playlistName.value,
                          hintStyle: TextStyle(color: AppColors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 180,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 45, 45, 45),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: TextField(
                        style: TextStyle(color: AppColors.white),
                        minLines: 2,
                        maxLines: 2,
                        onTap: () {},
                        controller: controllerPlaylistDesciription,
                        decoration: InputDecoration(
                          hintText: viewModel.playlistDesciription.value,
                          hintStyle: TextStyle(color: AppColors.grey),
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
    );
  }
}

class _Row1 extends StatelessWidget {
  const _Row1({
    super.key,
    required this.controllerPlaylistDesciription,
    required this.controllerPlaylistName,
    required this.viewModel,
    required this.playlistId,
  });
  final TextEditingController controllerPlaylistDesciription;
  final TextEditingController controllerPlaylistName;
  final UpdatePlaylistViewModel viewModel;
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: CustomText(
                data: "İptal",
                textSize: TextSize.medium,
                textWeight: TextWeight.bold,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            CustomText(
              data: "Ad ve ayrıntılar",
              textSize: TextSize.large,
              textWeight: TextWeight.bold,
            ),
            GestureDetector(
              child: CustomText(
                data: "Kaydet",
                textSize: TextSize.medium,
                textWeight: TextWeight.bold,
                color: AppColors.green,
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
    );
  }
}
