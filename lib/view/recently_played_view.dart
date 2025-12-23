import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/view_model/recently_played_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';

class RecentlyPlayedView extends StatefulWidget {
  const RecentlyPlayedView({super.key});

  @override
  State<RecentlyPlayedView> createState() => _RecentlyPlayedViewState();
}

class _RecentlyPlayedViewState extends State<RecentlyPlayedView> {
  //ViewModel
  late RecentlyPlayedViewModel viewModel;
  //ScrollController
  final ScrollController _scrollController = ScrollController();
  //Variables
  bool _isAtBottom = false;
  Map<String, bool> _isExpanded = {};

  void _onScrollEnd() {
    debugPrint("Ekran sonu!");
    getRecentlyPlayedTracks();
  }

  @override
  void initState() {
    super.initState();
    viewModel = RecentlyPlayedViewModel();
    getRecentlyPlayedTracks();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isAtBottom = true;
        });
      } else {
        setState(() {
          _isAtBottom = false;
        });
      }
    });
  }

  void getRecentlyPlayedTracks() async {
    viewModel.getNowDate();
    await viewModel.getRecentlyPlayedTracks();
    viewModel.grupla();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.slowMiddle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkToneInk,
        surfaceTintColor: AppColors.darkToneInk,
        centerTitle: true,
        title: CustomText(
          data: "Son çalınanlar",
          textSize: TextSize.large,
          textWeight: TextWeight.bold,
        ),
      ),
      body: Observer(
        builder: (context) {
          return ListView(
            controller: _scrollController,
            children: viewModel.groupedByDate.keys.map((date) {
              bool isExpanded = _isExpanded[date] ?? true;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          data: date,
                          textSize: TextSize.extraLarge,
                          textWeight: TextWeight.bold,
                        ),
                        IconButton(
                          icon: AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0.0,
                            duration: Duration(milliseconds: 300),
                            child: CustomIcon(
                              iconData: Icons.arrow_drop_down,
                              iconSize: IconSize.extraLarge,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded[date] = !isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(color: AppColors.grey),
                    ),
                    secondChild: Column(
                      children: viewModel.groupedByDate[date]!.map((track) {
                        return ListTile(
                          title: CustomText(
                            data: track.name,
                            textSize: TextSize.medium,
                            textWeight: TextWeight.bold,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(track.imageUrl ?? ""),
                          ),
                          subtitle: CustomText(
                            data: track.artistName,
                            textSize: TextSize.small,
                            textWeight: TextWeight.normal,
                            color: AppColors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                    duration: Duration(milliseconds: 300),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: _isAtBottom
          ? Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 120),
              child: InkWell(
                onTap: _scrollToTop,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CustomIcon(
                    iconData: Icons.arrow_upward_outlined,
                    color: Colors.white,
                    iconSize: IconSize.large,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
