import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/models/track_list_model.dart';
import 'package:spotify_clone/models/user_model.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/view_model/track_list_view_model.dart';
import 'package:spotify_clone/widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_point.dart';
import 'package:spotify_clone/widgets/custom_text.dart';

class TrackListView extends StatefulWidget {
  final String id;
  final MediaType type;
  final String title;
  final String? imageUrl;

  const TrackListView({
    Key? key,
    required this.id,
    required this.type,
    required this.title,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<TrackListView> createState() => _TrackListViewState();
}

class _TrackListViewState extends State<TrackListView> {
  late TrackListViewModel viewModel;
  late ScrollController scrollController;
  double offset = 0;
  double maxSize = 230;
  double minSize = 80;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      setState(() {
        offset = scrollController.offset;
      });
    });
    viewModel = TrackListViewModel();
    viewModel.updateBackground(widget.imageUrl ?? "");
    viewModel.loadDataForType(widget.type, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    double size = (maxSize - offset).clamp(minSize, maxSize);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          Observer(
            builder: (_) {
              final String title = widget.title;
              final Color color = viewModel.bgColor.value;
              return _CustomSliverAppBar(
                color: color,
                offset: offset,
                title: title,
              );
            },
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Stack(
                    children: [
                      Observer(
                        builder: (_) {
                          return _BackgroundColor(
                            color: viewModel.bgColor.value,
                          );
                        },
                      ),
                      _CoverImage(imageUrl: widget.imageUrl!, size: size),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: CustomText(
                            data: widget.title,
                            textSize: TextSize.extraLarge,
                            textWeight: TextWeight.bold,
                            padding: EdgeInsetsGeometry.only(left: 20),
                          ),
                        ),
                      ),
                      widget.type != MediaType.artist
                          ? Observer(
                              builder: (_) {
                                return _Row2(user: viewModel.user.value);
                              },
                            )
                          : Observer(
                              builder: (context) {
                                return _Row2(
                                  user: viewModel.user.value,
                                  isImage: false,
                                );
                              },
                            ),
                      widget.type == MediaType.playlist
                          ? Observer(
                              builder: (_) {
                                final int? total =
                                    viewModel.detail.value?.total;
                                final String totalData = "$total kaydetme";
                                final String duration =
                                    viewModel.duration.value;
                                return _RowPlaylist(
                                  duration: duration,
                                  total: totalData,
                                );
                              },
                            )
                          : widget.type == MediaType.album
                          ? Observer(
                              builder: (_) {
                                final String? releaseDate =
                                    viewModel.detail.value?.releaseDate;
                                return _RowAlbum(
                                  releaseDate: releaseDate ?? "no data",
                                );
                              },
                            )
                          : widget.type == "artist"
                          ? SizedBox.shrink()
                          : SizedBox.shrink(),
                      _RowButtons(imageUrl: widget.imageUrl ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Observer(
            builder: (_) {
              if (viewModel.isLoading.value) {
                return _CustomCircularProgressIndicator();
              }

              if (viewModel.tracks.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CustomText(
                      data: AppStrings.emtyListMessage,
                      textSize: TextSize.extraLarge,
                      padding: AppPaddings.all10,
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: viewModel.tracks.length,
                  (context, index) {
                    final track = viewModel.tracks[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: _CustomListTile(
                        track: track,
                        viewModel: viewModel,
                        title: widget.title,
                        type: widget.type,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  _CustomListTile({
    required this.track,
    required this.viewModel,
    required this.title,
    required this.type,
  });
  final String title;
  final MediaType type;
  final TrackItem track;
  final TrackListViewModel viewModel;
  final double imageSize = 50;
  final EdgeInsetsGeometry padding = EdgeInsets.all(0);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: track.albumImage != null
          ? Image.network(
              track.albumImage!,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            )
          : null,

      title: CustomText(
        data: track.name,
        textSize: TextSize.large,
        padding: padding,
      ),

      subtitle: CustomText(
        data: track.artistsName?.join(", "),
        textSize: TextSize.small,
        color: AppColors.grey,
        padding: padding,
      ),

      trailing: CustomIcon(iconData: Icons.more_vert_outlined),

      onTap: () async {
        final playTrack = await viewModel.getTrackWithPreview(track);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PlayerView(track: playTrack, title: title, type: type),
          ),
        );
      },
    );
  }
}

class _CustomCircularProgressIndicator extends StatelessWidget {
  _CustomCircularProgressIndicator();
  final EdgeInsetsGeometry padding = EdgeInsets.only(top: 100);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  const _CustomSliverAppBar({
    required this.color,
    required this.offset,
    required this.title,
  });

  final Color color;
  final double offset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: color,
      pinned: true,
      stretch: true,
      expandedHeight: 50,
      elevation: 0,
      title: offset > 110 ? Text(title) : const SizedBox(),
      centerTitle: true,
    );
  }
}

class _BackgroundColor extends StatelessWidget {
  const _BackgroundColor({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 1),
              AppColors.darkToneInk.withValues(alpha: 1),
            ],
            stops: [0.3, 0.95],
          ),
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.imageUrl, required this.size});

  final double size;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 170),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _Row2 extends StatelessWidget {
  const _Row2({required this.user, this.isImage = true});

  final UserModel? user;
  final String defaultProfileImage = "assets/png/default_profile_image.png";
  final double imageSize = 20;
  final bool isImage;
  final EdgeInsetsGeometry padding = const EdgeInsets.only(
    //left: 20,
    bottom: 90,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            isImage
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: imageSize,
                      width: imageSize,
                      child: ClipOval(
                        child: user?.imageUrl != null
                            ? Image.network(
                                "${user?.imageUrl}",
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                defaultProfileImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            isImage
                ? CustomText(
                    data: user?.displayName ?? "",
                    textSize: TextSize.large,
                    textWeight: TextWeight.bold,
                  )
                : CustomText(
                    data: "Toplam dinleyici : ${user?.total}",
                    textSize: TextSize.small,
                    textWeight: TextWeight.normal,
                    color: AppColors.grey,
                    padding: EdgeInsets.only(left: 20, bottom: 5),
                  ),
          ],
        ),
      ),
    );
  }
}

class _RowPlaylist extends StatelessWidget {
  const _RowPlaylist({required this.total, required this.duration});

  final String total;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 60),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomIcon(iconData: Icons.public_outlined, color: AppColors.grey),
            CustomText(data: total, color: AppColors.grey),
            Point(color: AppColors.grey),
            CustomText(data: duration, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

class _RowAlbum extends StatelessWidget {
  const _RowAlbum({required this.releaseDate});

  final String releaseDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 60),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(data: "Album", color: AppColors.grey),
            Point(color: AppColors.grey),
            CustomText(data: releaseDate, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

class _RowButtons extends StatelessWidget {
  const _RowButtons({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 0),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.amber,
              height: 50,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.white, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  CustomIcon(iconData: Icons.check_circle, color: Colors.green),
                  CustomIcon(iconData: Icons.download, color: Colors.grey),
                  CustomIcon(
                    iconData: Icons.more_vert_outlined,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CustomIcon(
                  color: AppColors.black,
                  iconData: Icons.play_arrow,
                  iconSize: IconSize.large,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
