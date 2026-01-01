import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_drag_handle.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

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
  _DraggableSection({required this.viewModel});

  final PlayerStore viewModel;

  final BorderRadiusGeometry _borderRadius = BorderRadius.vertical(
    top: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.22,
      maxChildSize: 0.32,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bottomSheetBgColor,
            borderRadius: _borderRadius,
          ),
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: 10),
              const CustomDragHandle(),
              const SizedBox(height: 20),
              Center(
                child: CustomText(
                  data: AppStrings.bsListenModes,
                  textSize: TextSize.large,
                ),
              ),
              Divider(color: AppColors.grey),
              Observer(
                builder: (context) {
                  final bool otoNextValue = viewModel.otoNext.value;
                  return _OtoNextSection(
                    viewModel: viewModel,
                    otoNextValue: otoNextValue,
                  );
                },
              ),
              Observer(
                builder: (context) {
                  final bool otoModeValue = viewModel.otoMode.value;
                  return _MixPlaySection(
                    viewModel: viewModel,
                    otoModeValue: otoModeValue,
                  );
                },
              ),
              Observer(
                builder: (context) {
                  final bool otoModeValue = viewModel.otoMode.value;
                  return _PlayInOrderSection(
                    viewModel: viewModel,
                    otoModeValue: otoModeValue,
                  );
                },
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
    return ListTile(
      leading: CustomIcon(
        iconData: Icons.view_list_outlined,
        iconSize: IconSize.extraLarge,
      ),
      title: CustomText(
        data: AppStrings.bsPlayInOrder,
        textSize: TextSize.medium,
        textWeight: TextWeight.bold,
      ),
      trailing: Switch(
        focusColor: Colors.green,
        activeThumbColor: Colors.green,
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
    return ListTile(
      leading: CustomIcon(
        iconData: Icons.shuffle_outlined,
        iconSize: IconSize.extraLarge,
      ),
      title: CustomText(
        data: AppStrings.bsMixPlay,
        textSize: TextSize.medium,
        textWeight: TextWeight.bold,
      ),
      trailing: Switch(
        focusColor: Colors.green,
        activeThumbColor: Colors.green,
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
  _OtoNextSection({required this.viewModel, required this.otoNextValue});

  final PlayerStore viewModel;
  final bool otoNextValue;

  final String activeSuffleIconPath = "assets/png/active_suffle.png";
  final String suffleIconPath = "assets/png/suffle.png";
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(50);
  final double iconContainerSize = 35;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: iconContainerSize,
        width: iconContainerSize,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: AppPaddings.all8,
          child: otoNextValue
              ? Image.asset(activeSuffleIconPath)
              : Image.asset(suffleIconPath),
        ),
      ),
      title: CustomText(
        data: AppStrings.bsAutoNext,
        textSize: TextSize.medium,
        textWeight: TextWeight.bold,
      ),
      trailing: Switch(
        focusColor: Colors.green,
        activeThumbColor: Colors.green,
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
