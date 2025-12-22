import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/view/update_playlist_view.dart';
import 'package:spotify_clone/view_model/create_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class CreatePlaylistView extends StatefulWidget {
  const CreatePlaylistView({super.key});

  @override
  State<CreatePlaylistView> createState() => _CreatePlaylistViewState();
}

class _CreatePlaylistViewState extends State<CreatePlaylistView> {
  //Controller
  final TextEditingController _controller = TextEditingController();
  //ViewModel
  late CreatePlaylistViewModel viewModel;
  //Variables
  bool _isReady = false;
  String _defaultName = "";

  @override
  void initState() {
    super.initState();
    viewModel = CreatePlaylistViewModel();
    _getTotalPlaylist();
  }

  Future<void> _getTotalPlaylist() async {
    await viewModel.getTotalPlaylist();
    _defaultName = "${viewModel.totalPlaylist}. çalma listem";
    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return SizedBox.shrink();
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.grey, AppColors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              data: AppStrings.setPlaylistName,
              textSize: TextSize.extraLarge,
              textWeight: TextWeight.bold,
            ),
            SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "${viewModel.totalPlaylist}. çalma listem",
                  hintStyle: TextStyle(color: AppColors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.textFiledEnabledLineColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: CustomText(
                    data: AppStrings.cancel,
                    textSize: TextSize.large,
                  ),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                  ),
                  onPressed: () async {
                    bool success = false;
                    String playlistName = "";
                    if (_controller.text.isNotEmpty) {
                      playlistName = _controller.text;
                      success = await viewModel.createPlaylist(
                        _controller.text,
                      );
                    } else {
                      playlistName = _defaultName;
                      success = await viewModel.createPlaylist(_defaultName);
                    }
                    if (success) {
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdatePlaylistView(
                            playlistName: playlistName,
                            playlistId:  viewModel.playlistId,
                         
                            /////////////////////////////////////////////
                          ), 
                        ),
                      );
                    }
                  },
                  child: CustomText(
                    data: AppStrings.create,
                    textSize: TextSize.large,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
