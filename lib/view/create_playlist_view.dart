import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/navigation_service.dart';
import 'package:spotify_clone/view/update_playlist_view.dart';
import 'package:spotify_clone/view_model/create_playlist_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';

class CreatePlaylistView extends StatefulWidget {
  const CreatePlaylistView({super.key});

  @override
  State<CreatePlaylistView> createState() => _CreatePlaylistViewState();
}

class _CreatePlaylistViewState extends State<CreatePlaylistView> {
  final TextEditingController _controller = TextEditingController();
  late CreatePlaylistViewModel viewModel;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    viewModel = CreatePlaylistViewModel();
    _initializeView();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeView() async {
    await viewModel.getTotalPlaylist();
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_isReady) {
      return const SizedBox.shrink();
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
            AppText(
              text: l10n.createPlaylistViewDialogPlaylistNameHint,
              style: AppTextStyle.titleL,
              color: _Constants.primaryTextColor,
            ),
            SizedBox(height: _Constants.heightSizeBox),
            Padding(
              padding: _Constants.padding,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                style: _Constants.textFieldTextStyle(context),
                decoration: InputDecoration(
                  hintText: l10n.myPlaylistHint(viewModel.totalPlaylist),
                  hintStyle: _Constants.hintTextStyle(context),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _Constants.enabledBorderColor,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _Constants.focusedBorderColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: _Constants.heightSizeBox),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: viewModel.isLoading ? null : () => NavigationService.instance.back(),
                  child: AppText(
                    text: l10n.createPlaylistViewCancel,
                    style: AppTextStyle.bodyL,
                    fontWeight: FontWeight.bold,
                    color: _Constants.primaryTextColor,
                  ),
                ),
                SizedBox(width: _Constants.widthSizeBox),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _Constants.createButtonBackgroundColor,
                  ),
                  onPressed: viewModel.isLoading
                      ? null
                      : () => viewModel.handleCreatePlaylist(
                            name: _controller.text,
                            fallbackName: l10n.myPlaylistHint(viewModel.totalPlaylist),
                            onNotify: () => setState(() {}),
                            onSuccess: () {
                              if (mounted) {
                                NavigationService.instance.push(
                                  UpdatePlaylistView(playlistId: viewModel.playlistId),
                                  routeName: 'UpdatePlaylistView',
                                );
                              }
                            },
                          ),
                  child: AppText(
                    text: l10n.createPlaylistViewCreate,
                    style: AppTextStyle.bodyL,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
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

abstract final class _Constants {
  static double get heightSizeBox => 50.h;
  static double get widthSizeBox => 25.w;
  static EdgeInsets get padding => EdgeInsets.symmetric(horizontal: 40.w);
  static const Color primaryTextColor = AppColors.white;
  static const Color createButtonBackgroundColor = AppColors.green;
  static const Color enabledBorderColor = AppColors.textFiledEnabledLineColor;
  static const Color focusedBorderColor = AppColors.white;
  static TextStyle? textFieldTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
            color: primaryTextColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          );
  static TextStyle? hintTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryTextColor, fontSize: 22.sp);
}