import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
//import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/helpers/song_data_manager.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/file_manager_service.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/view/main_tab_view.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_drag_handle.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_point.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class SongBottomSheet extends StatelessWidget {
  final PlayerStore viewModel;
  final BuildContext context;
  final PlayTrackItem track;
  final String title;
  final MediaType type;
  final bool isDownloaded;
  final MediaItem? item;
  const SongBottomSheet({
    super.key,
    required this.viewModel,
    required this.context,
    required this.track,
    required this.title,
    required this.type,
    required this.isDownloaded,required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return _DraggableSection(
      viewModel: viewModel,
      track: track,
      title: title,
      type: type,
      isDownloaded: isDownloaded,
      item: item,
    );
  }

  static void show(
    BuildContext context,
    PlayerStore viewModel,
    PlayTrackItem track,
    String title,
    MediaType type,
    bool isDownloaded,
    MediaItem? item,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SongBottomSheet(
        
        viewModel: viewModel,
        context: context,
        track: track,
        title: title,
        type: type,
        isDownloaded: isDownloaded,
        item: item,
      ),
    );
  }
}

class _DraggableSection extends StatefulWidget {
  const _DraggableSection({
    required this.viewModel,
    required this.track,
    required this.title,
    required this.type,
    required this.isDownloaded, required this.item,
  });

  final PlayerStore viewModel;
  final PlayTrackItem track;
  final String title;
  final MediaType type;
  final bool isDownloaded;
  final MediaItem? item;

  @override
  State<_DraggableSection> createState() => _DraggableSectionState();
}

class _DraggableSectionState extends State<_DraggableSection> {
  bool isLoading = false;

final BorderRadiusGeometry _borderRadius = BorderRadius.vertical(
   top: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.50,
      minChildSize: 0.50,
      maxChildSize: 0.90,
      expand: false,
      builder: (context, scrollController) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          decoration:  BoxDecoration(
            color: AppColors.background,
            borderRadius: _borderRadius,
          ),
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(height: 10),
              CustomDragHandle(),
              _TitleListTile(widget: widget ,   item: widget.item,),
              Divider(color: AppColors.grey),
              !widget.isDownloaded
                  ? _CustomListTile(
                      title: l10n.playerViewMenuDownload,
                      iconData: Icons.download,
                      onPressed: () async {
                        if (widget.type != MediaType.downloaded) {
                          if (!isLoading) {
                            isLoading = true;
                            await OnPressMethods().download(widget.track, context , widget.item);
                            isLoading = false;
                          }
                        }
                      },
                    )
                  : _CustomListTile(
                      title: l10n.playerViewMenuDeleteDownload,
                      iconData: Icons.delete,
                      onPressed: () async {
                        if (!isLoading) {
                          isLoading = true;
                          await OnPressMethods().delete(
                            widget.track,
                            context,
                            widget.viewModel,
                            widget.type,
                          );
                          isLoading = false;
                        }
                      },
                    ),
              _CustomListTile(
                title: l10n.playerViewMenuShare,
                iconData: Icons.person_2_outlined,
                color: AppColors.grey,
                onPressed: () async {
/*
                  List<String> files = await FileManagerService().listFiles();
                  debugPrint("İndirilen dosyalar:");
                  files.forEach((f) => print(f));

                  List<Map<String, dynamic>> allSongs = await SongDataManager()
                      .loadSongsFromPrefs();
                  debugPrint(allSongs.toString());
                  */
                },
              ),
              _CustomListTile(
                title: l10n.playerViewMenuAddPlaylist,
                iconData: Icons.add_circle_outline,
                color: AppColors.grey,
                onPressed: () async {
                  /*
                  SongDataManager().clearSongsFromPrefs();
                  */
                },
              ),
              _CustomListTile(
                title: l10n.playerViewMenuHideAlbum,
                iconData: Icons.close,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuAdFree,
                iconData: Icons.diamond_outlined,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuAddQueue,
                iconData: Icons.queue_music,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuGoQueue,
                iconData: Icons.view_list,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuGoAlbum,
                iconData: Icons.album,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuGoArtist,
                iconData: Icons.person,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuStartJam,
                iconData: Icons.group,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuExcludeTaste,
                iconData: Icons.close,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuSleepTimer,
                iconData: Icons.timer_outlined,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuSongRadio,
                iconData: Icons.podcasts,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuContributors,
                iconData: Icons.music_note,
                color: AppColors.grey,
              ),
              _CustomListTile(
                title: l10n.playerViewMenuSpotifyCode,
                iconData: Icons.graphic_eq,
                color: AppColors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TitleListTile extends StatelessWidget {
   _TitleListTile({
    required this.widget,required this.item,
  });
  final MediaItem? item;
  final _DraggableSection widget;
  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: _borderRadius,
        child: widget.type != MediaType.downloaded
            ?  Image.network(item!.album!)
            : Image.file(File(item?.album ?? "")),
      ),
      title: CustomText(data: item?.title ?? ""),
      subtitle: Row(
        children: [
          CustomText(data: item?.artist ?? "", color: AppColors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Point(color: AppColors.grey),
          ),
          CustomText(data: item?.title ?? "", color: AppColors.grey),
        ],
      ),
    );
  }
}

class OnPressMethods {
  Future<void> download(PlayTrackItem track, BuildContext context , MediaItem? item) async {
    //String songMP3Url = track.previewUrl ?? "";
    //String songCoverImageUrl = "${track.albumImage}";
   // String songMP3FileName = "${track.id}.mp3";
   // String songCoverImageFileName = "${track.id}.jpg";

   // debugPrint("_" * 30);
   // debugPrint("[MP3 File Name] : $songMP3FileName");
   // debugPrint("[Cover Image File Name] : $songCoverImageFileName");

    String songMP3Url = item?.id ?? "";
    String songCoverImageUrl = "${item?.album}";
    String songMP3FileName = "${item?.genre}.mp3";
    String songCoverImageFileName = "${item?.genre}.jpg";

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
        content: Text("Şarkı indirildi", style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> delete(
    PlayTrackItem track,
    BuildContext context,
    PlayerStore viewModel,
    MediaType type,
  ) async {
    debugPrint("sildi");
    await SongDataManager().deleteSongById(track.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Şarki indirilenlerden kaldirildi.",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
    if (type == MediaType.downloaded) {
      viewModel.playlist.removeAt(viewModel.currentIndex.value);
      if (viewModel.playlist.isNotEmpty) {
        viewModel.indexDeleteAndUpdate();
      } else {
        viewModel.stopSong();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainTabView(initialIndex: 2)),
          (route) => false,
        );
      }
    }
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
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

