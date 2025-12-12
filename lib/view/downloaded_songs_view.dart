import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/view_model/downloaded_songs_view_model.dart';
import 'package:spotify_clone/widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_text.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late AudioPlayer _player;
  int? currentlyPlayingIndex;

  late DownloadedSongsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DownloadedSongsViewModel();
    _player = AudioPlayer();
    viewModel.loadSongs();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: CustomText(
              data: "İndirilenler",
              textSize: TextSize.extraLarge,
              textWeight: TextWeight.bold,
            ),
          ),
          body: viewModel.songs.isEmpty
              ? const Center(child: Text("Henüz şarkı yok"))
              : ListView.builder(
                  itemCount: viewModel.songs.length,
                  itemBuilder: (context, index) {
                    final song = viewModel.songs[index];

                    return ListTile(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerView(
                              track: PlayTrackItem(
                                previewUrl: "",
                                id: song['id'],
                                trackName: song['title'],
                                artistName: song['artist'],
                                albumImage: "",
                                albumImagePath: song['albumCoverPath'],
                                previewPath: song['filePath'],
                              ),
                              title: "İndirilenler",
                              type: MediaType.downloaded,
                            ),
                          ),
                        );
                        await viewModel.loadSongs();
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child:
                            File(song['albumCoverPath'])
                                .existsSync()
                            ? Image.file(
                                File(song['albumCoverPath'] ?? ""),
                                fit: BoxFit.cover,
                              )
                            : const Text("Resim bulunamadı"),
                      ),
                      title: CustomText(
                        data: song['title'],
                        textSize: TextSize.medium,
                      ),
                      subtitle: CustomText(
                        data: song['artist'],
                        textSize: TextSize.small,
                        color: AppColors.grey,
                      ),
                      trailing: IconButton(
                        icon: CustomIcon(
                          iconData: Icons.delete,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          viewModel.delete(song['id']);
                          //
                          //playSong(song['filePath'], index);
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
