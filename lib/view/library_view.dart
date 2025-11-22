import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/models/library_model.dart';
import 'package:spotify_clone/view_model/library_view_model.dart';
import 'package:spotify_clone/widgets/custom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_bottom_sheet.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final LibraryViewModel viewModel = LibraryViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 110;

    return Scaffold(
      appBar: CustomAppBar(
        actionButtonsData: [
          AppBarButtonData(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {
              viewModel.addItem();
            },
          ),
          AppBarButtonData(
            icon: FaIcon(FontAwesomeIcons.plus),
            onPressed: () {
              CustomBottomSheet().customShowModalBottom(context);
            },
          ),
        ],
        bottomButtonsData: [
          AppBarButtonData(text: AppStrings.playlist, onPressed: () {}),
          AppBarButtonData(text: AppStrings.podcasts, onPressed: () {}),
          AppBarButtonData(text: AppStrings.albums, onPressed: () {}),
          AppBarButtonData(text: AppStrings.artists, onPressed: () {}),
        ],
        leading: Image.asset(AppStrings.profileImagePath),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: SizedBox(
          child: Text(AppStrings.library, style: TextStyle(color: AppColors.white)),
        ),
        appBarHeight: appBarHeight,
      ),
      body: Observer(
        builder: (context) => ListView.builder(
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            final item = viewModel.items[index];
            return _customListTile(item);
          },
        ),
      ),
    );
  }

  ListTile _customListTile(LibraryItem item) {
    return ListTile(
      leading: Image.network(item.imageUrl ?? "", fit: BoxFit.cover),
      title: Text(item.title ?? "", style: TextStyle(color: Colors.white)),
      subtitle: Text(item.subTitle ?? ""),
    );
  }
}
