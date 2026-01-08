import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/core/services/service_locator.dart';
import 'package:spotify_clone/models/player_model.dart';
import 'package:spotify_clone/models/track_list_model.dart';
import 'package:spotify_clone/models/user_model.dart';
import 'package:spotify_clone/view/player_view.dart';
import 'package:spotify_clone/core/stores/player_view_model.dart';
import 'package:spotify_clone/view_model/track_list_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_point.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final player = getIt<PlayerStore>();
  late TrackListViewModel viewModel;
  late ScrollController scrollController;
  double offset = 0;
  double maxSize = _Constants.maxSize;
  double minSize = _Constants.minSize;

  List<PlayTrackItem> playlist = [];

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
    final l10n = AppLocalizations.of(context)!;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: _Constants.headerHeight,
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
                        padding: _Constants.titlePadding,
                        child: Container(
                          alignment: AlignmentDirectional.bottomStart,
                          child: CustomText(
                            data: widget.title,
                            textSize: TextSize.extraLarge,
                            textWeight: TextWeight.bold,
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
                final int? total = viewModel.detail.value?.total;
                final String totalData = "${total ?? 0} ${l10n.trackListViewSave}";

                
                String durationText;
                if (viewModel.totalHours.value > 0) {
                  durationText = l10n.durationHoursMinutes(
                    viewModel.totalHours.value.toString(),
                    viewModel.totalMinutes.value.toString(),
                  );
                } else {
                  durationText = l10n.durationMinutes(viewModel.totalMinutes.value.toString());
                }

                return _RowPlaylist(
                  duration: durationText,
                  total: totalData,
                );
              },
            )
          : widget.type == MediaType.album
              ? Observer(
                  builder: (_) {
                    final String? releaseDate = viewModel.detail.value?.releaseDate;
                    return _RowAlbum(
                      releaseDate: releaseDate ?? l10n.trackListViewNoData,
                    );
                  },
                )
                          : widget.type == MediaType.album
                          ? Observer(
                              builder: (_) {
                                final String? releaseDate =
                                    viewModel.detail.value?.releaseDate;
                                return _RowAlbum(
                                  releaseDate:
                                      releaseDate ?? l10n.trackListViewNoData,
                                );
                              },
                            )
                          : widget.type == "artist"
                          ? SizedBox.shrink()
                          : SizedBox.shrink(),
                      _RowButtons(
                        imageUrl: widget.imageUrl ?? "",
                        viewModel: viewModel,
                      ),
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
                      data: l10n.trackListViewEmptyList,
                      textSize: TextSize.extraLarge,
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
                      padding: _Constants.trackPadding,
                      child: _CustomListTile(
                        track: track,
                        viewModel: viewModel,
                        title: widget.title,
                        type: widget.type,
                        index: index,
                        player: player,
                        id: widget.id,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: _Constants.bottomSpace)),
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
    required this.index,
    required this.player,
    required this.id,
  });
  final String title;
  final MediaType type;
  final TrackItem track;
  final TrackListViewModel viewModel;
  final double imageSize = _Constants.tileImageSize;
  final EdgeInsetsGeometry padding = EdgeInsets.all(0);
  final int index;
  final PlayerStore player;
  final String id;

  List<PlayTrackItem> playlist = [];

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
      title: CustomText(data: track.name, textSize: TextSize.large),
      subtitle: CustomText(
        data: track.artistsName?.join(", "),
        textSize: TextSize.small,
        color: AppColors.grey,
      ),
      trailing: Padding(
        padding: _Constants.tileTrailingPadding,
        child: CustomIcon(
          iconData: Icons.more_vert_outlined,
          iconSize: IconSize.large,
        ),
      ),
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        final futures = viewModel.tracks.map(
          (t) => viewModel.getTrackWithPreview(t),
        );
        Navigator.pop(context);
        final playlist = await Future.wait(futures);
        player.playFromPlaylist(
          list: playlist,
          index: index,
          type: type,
          id: id,
        );
      },
    );
  }
}

class _CustomCircularProgressIndicator extends StatelessWidget {
  _CustomCircularProgressIndicator();
  final EdgeInsetsGeometry padding = _Constants.loadingPadding;
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
      expandedHeight: _Constants.appBarHeight,
      elevation: 0,
      title: offset > _Constants.appBarOffset ? Text(title) : const SizedBox(),
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
              AppColors.background.withValues(alpha: 1),
            ],
            stops: _Constants.gradientStops,
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
      padding: _Constants.coverPadding,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: _Constants.commonRadius,
          child: imageUrl.isEmpty
              ? Container(
                  width: size,
                  height: size,
                  color: AppColors.grey,
                  child: CustomIcon(
                    iconData: Icons.music_note,
                    iconSize: IconSize.mega,
                  ),
                )
              : Image.network(
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
  _Row2({required this.user, this.isImage = true});

  final UserModel? user;
  final String defaultProfileImage = _Constants.defaultProfilePath;
  final double imageSize = _Constants.row2ImageSize;
  final bool isImage;
  final EdgeInsetsGeometry padding = _Constants.row2Padding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: padding,
      child: Container(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          children: [
            isImage
                ? SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: ClipOval(
                      child: user?.imageUrl != null
                          ? Image.network(
                              "${user?.imageUrl}",
                              fit: BoxFit.cover,
                            )
                          : Image.asset(defaultProfileImage, fit: BoxFit.cover),
                    ),
                  )
                : SizedBox.shrink(),
            isImage
                ? Padding(
                    padding: _Constants.row2TextPadding,
                    child: CustomText(
                      data: user?.displayName ?? "",
                      textSize: TextSize.medium,
                      textWeight: TextWeight.normal,
                    ),
                  )
                : Padding(
                    padding: _Constants.row2TextPadding,
                    child: CustomText(
                      data:
                          "${l10n.trackListViewTotalListener} : ${user?.total}",
                      textSize: TextSize.small,
                      textWeight: TextWeight.normal,
                      color: AppColors.grey,
                    ),
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
      padding: _Constants.playlistRowPadding,
      child: Container(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomIcon(
              iconData: Icons.public_outlined,
              color: AppColors.grey,
              iconSize: IconSize.medium,
            ),
            Padding(
              padding: _Constants.rowTextStartPadding,
              child: CustomText(data: total, color: AppColors.grey),
            ),
            Padding(
              padding: _Constants.horizontal5Padding,
              child: Point(color: AppColors.grey),
            ),
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.albumRowPadding,
      child: Container(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(data: l10n.trackListViewAlbum, color: AppColors.grey),
            Padding(
              padding: _Constants.horizontal5Padding,
              child: Point(color: AppColors.grey),
            ),
            CustomText(data: releaseDate, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

class _RowButtons extends StatelessWidget {
  const _RowButtons({required this.imageUrl, required this.viewModel});
  final TrackListViewModel viewModel;

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _Constants.buttonsRowPadding,
      child: Container(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: _Constants.buttonBoxSize,
              width: _Constants.buttonBoxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _Constants.miniImageWidth,
                    height: _Constants.miniImageHeight,
                    decoration: BoxDecoration(
                      borderRadius: _Constants.commonRadius,
                      border: Border.all(color: AppColors.white, width: 1.w),
                    ),
                    child: ClipRRect(
                      borderRadius: _Constants.commonRadius,
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  CustomIcon(
                    iconData: Icons.check_circle,
                    color: Colors.green,
                    iconSize: IconSize.large,
                  ),
                  IconButton(
                    icon: CustomIcon(
                      iconData: Icons.download,
                      iconSize: IconSize.large,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(
                          child: SizedBox(
                            child: Lottie.asset(
                              _Constants.loadingLottie,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                      await viewModel.fullDownload();
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(
                          child: SizedBox(
                            child: Lottie.asset(
                              _Constants.successLottie,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                      await Future.delayed(_Constants.lottieDuration);
                      Navigator.pop(context);
                    },
                  ),
                  CustomIcon(
                    iconData: Icons.more_vert_outlined,
                    color: Colors.grey,
                    iconSize: IconSize.large,
                  ),
                ],
              ),
            ),
            Padding(
              padding: _Constants.playButtonPadding,
              child: Container(
                height: _Constants.buttonBoxSize,
                width: _Constants.buttonBoxSize,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: _Constants.circleRadius,
                ),
                child: CustomIcon(
                  color: AppColors.black,
                  iconData: Icons.play_arrow,
                  iconSize: IconSize.extraLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class _Constants {
  static double maxSize = 230.h;
  static double minSize = 80.h;
  static double headerHeight = 400.h;
  static double appBarHeight = 50.h;
  static double appBarOffset = 110.h;
  static double tileImageSize = 50.w;
  static double row2ImageSize = 20.w;
  static double buttonBoxSize = 50.w;
  static double buttonBoxWidth = 200.w;
  static double miniImageWidth = 30.w;
  static double miniImageHeight = 40.h;
  static double bottomSpace = 200.h;

  static EdgeInsetsDirectional titlePadding = EdgeInsetsDirectional.only(
    bottom: 115.h,
    start: 20.w,
  );
  static EdgeInsetsDirectional coverPadding = EdgeInsetsDirectional.only(
    bottom: 170.h,
  );
  static EdgeInsetsDirectional trackPadding = EdgeInsetsDirectional.only(
    start: 2.w,
  );
  static EdgeInsetsDirectional tileTrailingPadding = EdgeInsetsDirectional.only(
    end: 5.w,
  );
  static EdgeInsetsDirectional loadingPadding = EdgeInsetsDirectional.only(
    top: 100.h,
  );
  static EdgeInsetsDirectional row2Padding = EdgeInsetsDirectional.only(
    start: 15.w,
    bottom: 90.h,
  );
  static EdgeInsetsDirectional row2TextPadding = EdgeInsetsDirectional.only(
    start: 5.w,
  );
  static EdgeInsetsDirectional playlistRowPadding = EdgeInsetsDirectional.only(
    start: 20.w,
    bottom: 60.h,
  );
  static EdgeInsetsDirectional albumRowPadding = EdgeInsetsDirectional.only(
    start: 20.w,
    bottom: 60.h,
  );
  static EdgeInsetsDirectional buttonsRowPadding = EdgeInsetsDirectional.only(
    start: 20.w,
    bottom: 0,
  );
  static EdgeInsetsDirectional playButtonPadding = EdgeInsetsDirectional.only(
    end: 15.w,
  );
  static EdgeInsets horizontal5Padding = EdgeInsets.symmetric(horizontal: 5.w);
  static EdgeInsetsDirectional rowTextStartPadding = EdgeInsetsDirectional.only(
    start: 5.w,
  );

  static final BorderRadius commonRadius = BorderRadius.circular(10.r);
  static final BorderRadius circleRadius = BorderRadius.circular(100.r);
  static const List<double> gradientStops = [0.3, 0.95];

  //Path
  static String defaultProfilePath = AppStrings.defaultProfileImage;
  static String loadingLottie = AppStrings.loadingLottie;
  static String successLottie = AppStrings.successLottie;
  //Duration
  static const Duration lottieDuration = Duration(milliseconds: 3400);
}
