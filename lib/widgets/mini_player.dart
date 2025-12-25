import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/helpers/color_extension.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';
import 'package:spotify_clone/widgets/progress_bars/mini_player_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  final player = getIt<PlayerViewModel>();

  MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Observer(
        builder: (context) {
          //final color = player.bgColor.value;
          final color = player.bgColor.value.darken(0.25);
          return Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,

              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Observer(
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            child: player.playlist.isNotEmpty
                                ? Image.network(
                                    player
                                        .playlist[player.currentIndex.value]
                                        .albumImage!,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    "https://image.hurimg.com/i/hurriyet/90/750x422/56f52c2f18c7736068498229.jpg",
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 60,
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Observer(
                              builder: (context) {
                                return CustomText(
                                  data: player.playlist.isNotEmpty
                                      ? player
                                            .playlist[player.currentIndex.value]
                                            .trackName
                                      : "hata",
                                  textWeight: TextWeight.bold,
                                  textSize: TextSize.medium,
                                );
                              },
                            ),
                            SizedBox(height: 2),
                            Observer(
                              builder: (context) {
                                return CustomText(
                                  data: player.playlist.isNotEmpty
                                      ? player
                                            .playlist[player.currentIndex.value]
                                            .artistName
                                      : "hata",
                                  textWeight: TextWeight.regular,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 125,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  debugPrint("Device Button on click.");
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CustomIcon(
                                    iconData: Icons.devices_outlined,
                                    iconSize: IconSize.large,
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  debugPrint("Add Button on click.");
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CustomIcon(
                                    iconData: Icons.add_circle_outline,
                                    iconSize: IconSize.large,
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder<bool>(
                              stream: player.playingStream,
                              builder: (context, snapshot) {
                                final isPlaying = snapshot.data ?? false;
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (isPlaying) {
                                        player.playerPause();
                                      } else {
                                        player.playerPlay();
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      child: CustomIcon(
                                        iconData: isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        iconSize: IconSize.large,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MiniPlayerProgressBar(player: player),
              ],
            ),
          );
        },
      ),
      onTap: () {
        debugPrint("tiklandi");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerView(
              title: player.playlist[player.currentIndex.value].trackName ?? "",
              type: player.currentType,
              playlist: player.playlist,
              currentIndex: player.currentIndex.value,
            ),
          ),
        );
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          player.indexPrevious();
          debugPrint("sola kaydi");
        } else {
          debugPrint("saga kaydi");
          player.indexNext();
        }
      },
    );
  }
}
