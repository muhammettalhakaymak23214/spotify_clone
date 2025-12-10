import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/models/player_model.dart';

import 'package:spotify_clone/view_model/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_text.dart';

class PlayerView extends StatefulWidget {
  final String title;
  //final String type;
  final PlayTrackItem track;
 final MediaType type;

  const PlayerView({
    super.key,
    required this.track,
    required this.title,
    required this.type,
  });

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late AudioPlayer _player;
  late PlayerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PlayerViewModel();
    viewModel.updateBackground(widget.track.albumImage ?? "");
    _player = AudioPlayer();
    _setupAudio();
    _player.play();
  }

  Future<void> _setupAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    if (widget.track.previewUrl != null &&
        widget.track.previewUrl!.isNotEmpty) {
      try {
        await _player.setUrl(widget.track.previewUrl!);
      } catch (e) {
        debugPrint("[setupAudio] : $e");
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double leftPadding = (screenWidth - 350) / 2;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Observer(
          builder: (context) {
            return AppBar(
              centerTitle: true,
              backgroundColor: viewModel.bgColor.value.withValues(alpha: 0.8),
              title: Column(
                children: [
                  CustomText(data: widget.type.title),
                  CustomText(
                    data: widget.title,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.fontSize16,
                  ),
                ],
              ), //Text(track.trackName ?? "No Data"),
              leadingWidth: 80,
              actionsPadding: EdgeInsets.only(right: 20),
              actions: [CustomIcon(iconData: Icons.more_vert_outlined)],
            );
          },
        ),
      ),
      body: Observer(
        builder: (context) {
          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  viewModel.bgColor.value.withValues(alpha: 1),
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: [0.3, 0.9],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.only( left: leftPadding),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child:
                        track.albumImage != null && track.albumImage!.isNotEmpty
                        ? Image.network(
                            track.albumImage!,
                            width: 350,
                            height: 350,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 250,
                            height: 250,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.music_note,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
SizedBox(height: 50),
                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: leftPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            data: track.trackName,
                            fontSize: AppSizes.fontSize22,
                            fontWeight: FontWeight.bold,
                            padding: EdgeInsets.all(0),
                          ),
                          CustomText(
                            data: track.artistName,
                            fontSize: AppSizes.fontSize16,
                            fontWeight: FontWeight.normal,
                            padding: EdgeInsets.all(0),
                          ),
                        ],
                      ),
                      CustomIcon(
                        iconData: Icons.add_circle_outline,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                StreamBuilder<Duration?>(
                  stream: _player.durationStream,
                  builder: (context, snapshotDuration) {
                    final duration = snapshotDuration.data ?? Duration.zero;

                    return StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      builder: (context, snapshotPosition) {
                        final position = snapshotPosition.data ?? Duration.zero;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: leftPadding,
                          ),
                          child: ProgressBar(
                            progress: position,
                            total: duration,
                            barHeight: 5,
                            baseBarColor: Colors.grey,
                            progressBarColor: AppColors.white,
                            thumbColor: AppColors.white,
                            thumbRadius: 5,
                            timeLabelPadding: 10.0,
                            timeLabelTextStyle: TextStyle(
                              color: AppColors.grey,
                              fontSize: AppSizes.fontSize,
                            ),
                            onSeek: (newPosition) => _player.seek(newPosition),
                          ),
                        );
                      },
                    );
                  },
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: leftPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(iconData: Icons.shuffle),
                      CustomIcon(iconData: Icons.skip_previous, iconSize: 40),
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;

                          final isPlaying = state?.playing ?? false;
                          final isLoading =
                              state?.processingState ==
                                  ProcessingState.loading ||
                              state?.processingState ==
                                  ProcessingState.buffering;

                          if (isLoading) {
                            return const CircularProgressIndicator();
                          }

                          return IconButton(
                            iconSize: 70,
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                _player.pause();
                              } else {
                                _player.play();
                              }
                            },
                          );
                        },
                      ),
                      CustomIcon(iconData: Icons.skip_next, iconSize: 40),
                      CustomIcon(iconData: Icons.repeat),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: leftPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        // color: Colors.amber,
                        width: 250,
                        child: CustomIcon(iconData: Icons.devices),
                      ),

                      CustomIcon(iconData: Icons.share),
                      CustomIcon(iconData: Icons.queue_music),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
