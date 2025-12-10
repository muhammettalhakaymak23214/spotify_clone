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
            final color = viewModel.bgColor;
            return _CustomAppBar(backgroundColor: color.value, widget: widget);
          },
        ),
      ),
      body: Observer(
        builder: (context) {
          final backgroundColor = viewModel.bgColor.value;
          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor.withValues(alpha: 1),
                  AppColors.black.withValues(alpha: 0.5),
                ],
                stops: [0.3, 0.9],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CoverImage(leftPadding: leftPadding, track: track),
                const SizedBox(height: 70),
                _Row1(leftPadding: leftPadding, track: track),
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
                _Row2(leftPadding: leftPadding, player: _player),
                SizedBox(height: 20),
                _Row3(leftPadding: leftPadding),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Row3 extends StatelessWidget {
  const _Row3({super.key, required this.leftPadding});

  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 250,
            child: CustomIcon(iconData: Icons.devices),
          ),

          CustomIcon(iconData: Icons.share),
          CustomIcon(iconData: Icons.queue_music),
        ],
      ),
    );
  }
}

class _Row2 extends StatelessWidget {
  const _Row2({
    super.key,
    required this.leftPadding,
    required AudioPlayer player,
  }) : _player = player;

  final double leftPadding;
  final AudioPlayer _player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIcon(iconData: Icons.shuffle),
          CustomIcon(
            iconData: Icons.skip_previous,
            iconSize: IconSize.extraLarge,
          ),
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final isPlaying = state?.playing ?? false;
              final isLoading =
                  state?.processingState == ProcessingState.loading ||
                  state?.processingState == ProcessingState.buffering;
              if (isLoading) {
                return const CircularProgressIndicator();
              }
              return IconButton(
                icon: CustomIcon(
                  iconData: isPlaying ? Icons.pause_circle : Icons.play_circle,
                  iconSize: IconSize.mega,
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
          CustomIcon(iconData: Icons.skip_next, iconSize: IconSize.extraLarge),
          CustomIcon(iconData: Icons.repeat),
        ],
      ),
    );
  }
}

class _Row1 extends StatelessWidget {
  const _Row1({required this.leftPadding, required this.track});

  final double leftPadding;
  final PlayTrackItem track;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                textSize: TextSize.extraLarge,
                textWeight: TextWeight.bold,
              ),
              CustomText(
                data: track.artistName,
                textSize: TextSize.large,
                textWeight: TextWeight.normal,
              ),
            ],
          ),
          CustomIcon(
            iconData: Icons.add_circle_outline,
            iconSize: IconSize.extraLarge,
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.leftPadding, required this.track});

  final double leftPadding;
  final PlayTrackItem track;
  final double size = 350;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: track.albumImage != null && track.albumImage!.isNotEmpty
            ? Image.network(
                track.albumImage!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : Container(
                width: size,
                height: size,
                color: AppColors.grey,
                child: CustomIcon(
                  iconData: Icons.music_note,
                  iconSize: IconSize.extraLarge,
                ),
              ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  _CustomAppBar({required this.widget, required this.backgroundColor});

  final Color backgroundColor;
  final PlayerView widget;
  final EdgeInsetsGeometry actionPadding = EdgeInsets.only(right: 20);
  final double leadingWidth = 80;
  final double backgroundColorAlphaValue = 0.8;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: backgroundColor.withValues(
        alpha: backgroundColorAlphaValue,
      ),
      title: Column(
        children: [
          CustomText(data: widget.type.title, textWeight: TextWeight.light),
          CustomText(
            data: widget.title,
            textWeight: TextWeight.normal,
            textSize: TextSize.medium,
          ),
        ],
      ),
      leadingWidth: leadingWidth,
      actionsPadding: actionPadding,
      actions: [CustomIcon(iconData: Icons.more_vert_outlined)],
    );
  }
}
