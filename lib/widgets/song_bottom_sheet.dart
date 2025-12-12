import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/song_data_manager.dart';
import 'package:spotify_clone/core/services/file_manager_service.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_point.dart';
import 'package:spotify_clone/widgets/custom_text.dart';

class SongBottomSheet {
  bool isLoading = false;
  void songShowModalBottom(
    BuildContext context,
    PlayTrackItem track,
    String title,
    MediaType type,
    bool isDownloaded,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.50,
          minChildSize: 0.50,
          maxChildSize: 0.90,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  SizedBox(height: 10),
                  _DragHandle(),
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: type != MediaType.downloaded
                          ? Image.network(track.albumImage ?? "")
                          : Image.file(File(track.albumImagePath ?? "")),
                    ),
                    title: CustomText(data: title),
                    subtitle: Row(
                      children: [
                        CustomText(data: track.artistName, color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Point(color: Colors.grey),
                        ),
                        CustomText(data: track.trackName, color: Colors.grey),
                      ],
                    ),
                  ),
                  Divider(color: AppColors.grey),
                  !isDownloaded
                      ? _CustomListTile(
                          title: AppStrings.download,
                          iconData: Icons.download,
                          onPressed: () async {
                            if (!isLoading) {
                              isLoading = true;
                              await OnPressMethods().download(track, context);
                              isLoading = false;
                            }
                          },
                        )
                      : _CustomListTile(
                          title: "İndirilenlerden Kaldır",
                          iconData: Icons.delete,
                          onPressed: () async {
                            if (!isLoading) {
                              isLoading = true;
                              await OnPressMethods().delete(track, context);
                              isLoading = false;
                            }
                          },
                        ),
                  _CustomListTile(
                    title: AppStrings.share,
                    iconData: Icons.person_2_outlined,
                    color: AppColors.grey,
                    onPressed: () async {
/*
                      List<String> files = await FileManagerService()
                          .listFiles();
                      debugPrint("İndirilen dosyalar:");
                      files.forEach((f) => print(f));

                      List<Map<String, dynamic>> allSongs =
                          await SongDataManager().loadSongsFromPrefs();
                      debugPrint(allSongs.toString());
                      */
                    },
                  ),
                  _CustomListTile(
                    title: AppStrings.addPlaylist,
                    iconData: Icons.add_circle_outline,
                    color: AppColors.grey,
                    onPressed: () async {
                      /*
                      List<Map<String, dynamic>> allSongs =
                          await SongDataManager().loadSongsFromPrefs();
                      SongDataManager().clearSongsFromPrefs();
                      */
                    },
                  ),
                  _CustomListTile(
                    title: AppStrings.hideAlbum,
                    iconData: Icons.close,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.adFree,
                    iconData: Icons.diamond_outlined,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.addQueue,
                    iconData: Icons.queue_music,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.goQueue,
                    iconData: Icons.view_list,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.goAlbum,
                    iconData: Icons.album,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.goArtist,
                    iconData: Icons.person,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.startJam,
                    iconData: Icons.group,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.excludeTaste,
                    iconData: Icons.close,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.sleepTimer,
                    iconData: Icons.timer_outlined,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.songRadio,
                    iconData: Icons.podcasts,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.contributors,
                    iconData: Icons.music_note,
                    color: AppColors.grey,
                  ),
                  _CustomListTile(
                    title: AppStrings.spotifyCode,
                    iconData: Icons.graphic_eq,
                    color: AppColors.grey,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class OnPressMethods {
  Future<void> download(PlayTrackItem track, BuildContext context) async {
    String songMP3Url = track.previewUrl ?? "";
    String songCoverImageUrl = "${track.albumImage}";
    String songMP3FileName = "${track.id}.mp3";
    String songCoverImageFileName = "${track.id}.jpg";

    debugPrint("_" * 30);
    debugPrint("[MP3 File Name] : $songMP3FileName");
    debugPrint("[Cover Image File Name] : $songCoverImageFileName");

    String? pathSongMp3 = await FileManagerService().downloadFile(
      songMP3Url,
      songMP3FileName,
    );

    String? pathSongCoverImage = await FileManagerService().downloadFile(
      songCoverImageUrl,
      songCoverImageFileName,
    );

    debugPrint("[MP3 File Path] : $pathSongMp3");
    debugPrint("[Cover Image File Path] : $pathSongCoverImage");
    debugPrint("_" * 30);

    List<Map<String, dynamic>> songs = await SongDataManager()
        .loadSongsFromPrefs();

    songs.add({
      "id": track.id,
      "title": track.trackName,
      "artist": track.artistName,
      "albumCoverPath": pathSongCoverImage,
      "filePath": pathSongMp3,
    });
    await SongDataManager().saveSongsToPrefs(songs);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Şarkı indirildi" ,style: TextStyle(color: Colors.white), ),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> delete(PlayTrackItem track, BuildContext context) async {
    debugPrint("sildi");
    await SongDataManager().deleteSongById(track.id!);
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Şarkı indirilenlerden kaldırıldı." ,style: TextStyle(color: Colors.white), ),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    super.key,
    required this.title,
    required this.iconData,
    this.onPressed = _emptyFunction,
    this.color = Colors.white,
  });

  final String title;
  final IconData iconData;
  final VoidCallback onPressed;
  static void _emptyFunction() {}
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIcon(
        iconData: iconData,
        iconSize: IconSize.large,
        color: color,
      ),
      title: CustomText(
        data: title,
        textSize: TextSize.large,
        textWeight: TextWeight.regular,
        color: color,
      ),
      onTap: onPressed,
    );
  }
}
