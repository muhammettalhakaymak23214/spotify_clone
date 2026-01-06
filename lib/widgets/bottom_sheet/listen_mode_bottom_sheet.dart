import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_icon.dart'; // Senin verdiğin AppIcon
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_drag_handle.dart';

class ListenModeBottomSheet extends StatelessWidget {
  final PlayerStore viewModel;
  const ListenModeBottomSheet({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return _DraggableSection(viewModel: viewModel);
  }

  static void show(BuildContext context, PlayerStore viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ListenModeBottomSheet(viewModel: viewModel),
    );
  }
}

class _DraggableSection extends StatelessWidget {
  const _DraggableSection({required this.viewModel});

  final PlayerStore viewModel;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _Constants.sheetInitialSize,
      minChildSize: _Constants.sheetMinSize,
      maxChildSize: _Constants.sheetMaxSize,
      expand: false,
      builder: (context, scrollController) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          decoration: _Constants.sheetDecoration,
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(height: _Constants.gapSmall),
              const CustomDragHandle(),
              SizedBox(height: _Constants.gapMedium),
              Center(
                child: AppText(
                  text: l10n.playerViewMenuListenModes,
                  style: AppTextStyle.titleM,
                ),
              ),
              Divider(color: AppColors.grey),
              Observer(
                builder: (context) => _OtoNextSection(
                  viewModel: viewModel,
                  otoNextValue: viewModel.otoNext.value,
                ),
              ),
              Observer(
                builder: (context) => _MixPlaySection(
                  viewModel: viewModel,
                  otoModeValue: viewModel.otoMode.value,
                ),
              ),
              Observer(
                builder: (context) => _PlayInOrderSection(
                  viewModel: viewModel,
                  otoModeValue: viewModel.otoMode.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlayInOrderSection extends StatelessWidget {
  const _PlayInOrderSection({
    required this.viewModel,
    required this.otoModeValue,
  });

  final PlayerStore viewModel;
  final bool otoModeValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const AppIcon(
        icon: Icons.view_list_outlined,
        size: AppIconSize.large, 
      ),
      title: AppText(
        text: l10n.playerViewMenuPlayInOrder,
        style: AppTextStyle.titleM,
        fontWeight: FontWeight.bold,
      ),
      trailing: Switch(
        activeColor: _Constants.switchActiveColor,
        value: !otoModeValue,
        onChanged: (value) {
          viewModel.setOtoMode();
          viewModel.getOtoMode();
        },
      ),
    );
  }
}

class _MixPlaySection extends StatelessWidget {
  const _MixPlaySection({required this.viewModel, required this.otoModeValue});

  final PlayerStore viewModel;
  final bool otoModeValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const AppIcon(
        icon: Icons.shuffle_outlined,
        size: AppIconSize.large, 
      ),
      title: AppText(
        text: l10n.playerViewMenuMixPlay,
        style: AppTextStyle.titleM,
        fontWeight: FontWeight.bold,
      ),
      trailing: Switch(
        activeColor: _Constants.switchActiveColor,
        value: otoModeValue,
        onChanged: (value) {
          viewModel.setOtoMode();
          viewModel.getOtoMode();
        },
      ),
    );
  }
}

class _OtoNextSection extends StatelessWidget {
  const _OtoNextSection({required this.viewModel, required this.otoNextValue});

  final PlayerStore viewModel;
  final bool otoNextValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: Container(
        height: _Constants.iconContainerSize,
        width: _Constants.iconContainerSize,
        decoration: _Constants.iconContainerDecoration,
        child: Padding(
          padding: _Constants.iconPadding,
          child: Image.asset(
            otoNextValue ? _Constants.activeShufflePath : _Constants.shufflePath,
          ),
        ),
      ),
      title: AppText(
        text: l10n.playerViewMenuAutoNext,
        style: AppTextStyle.titleM,
        fontWeight: FontWeight.bold,
      ),
      trailing: Switch(
        activeColor: _Constants.switchActiveColor,
        value: otoNextValue,
        onChanged: (value) async {
          await viewModel.setOtoNext();
          viewModel.getOtoNext();
          viewModel.getOtoLoop();
        },
      ),
    );
  }
}

abstract final class _Constants {
  // Sizes
  static double get sheetInitialSize => 0.22;
  static double get sheetMinSize => 0.22;
  static double get sheetMaxSize => 0.32;
  static double get gapSmall => 10.h;
  static double get gapMedium => 20.h;
  static double get iconContainerSize => 32.w;
  
  // Padding & Radius
  static EdgeInsets get iconPadding => EdgeInsets.all(8.w);
  static BorderRadius get sheetRadius => BorderRadius.vertical(top: Radius.circular(20.r));
  static BorderRadius get circleRadius => BorderRadius.circular(50.r);

  // Decoration
  static BoxDecoration get sheetDecoration => BoxDecoration(
        color: AppColors.bottomSheetBgColor,
        borderRadius: sheetRadius,
      );
  static BoxDecoration get iconContainerDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: circleRadius,
      );

  //Colors
  static Color get switchActiveColor => AppColors.green;
  
  //Paths
  static String activeShufflePath = AppStrings.activeSuffleImage;
  static String shufflePath = AppStrings.suffleImage;
}