import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/view_model/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_text.dart';

class PlayerView extends StatefulWidget {
  final PlayTrackItem track;

  const PlayerView({super.key, required this.track});

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
              backgroundColor: viewModel.bgColor.value.withValues(alpha: 0.8),
              title: Text(track.trackName ?? "No Data"));
          }
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, left: leftPadding),
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

                const SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.only(left: leftPadding),
                  child: CustomText(
                    data: track.trackName,
                    fontSize: AppSizes.fontSize22,
                    fontWeight: FontWeight.bold,
                    padding: EdgeInsets.all(0),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: leftPadding),
                  child: CustomText(
                    data: track.artistName,
                    fontSize: AppSizes.fontSize16,
                    fontWeight: FontWeight.normal,
                    padding: EdgeInsets.all(0),
                  ),
                ),

                SizedBox(height: 90),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIcon(iconData: Icons.pause_circle , iconSize: 60,)
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
