import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/models/home_model.dart';
import 'package:spotify_clone/view_model/home_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_icon.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String imagePath = "assets/png/profile_photo.png";
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
    viewModel.fetchPlaylist();
    viewModel.fetchNewReleases();
    viewModel.fetchUserTopArtists();
  }

  @override
  Widget build(BuildContext context) {
    final String title1 = "Çalma Listelerin";
    final String title2 = "Yeni Çıkanlar";
    final String title3 = "Sevdiğin Sanatçılar";

    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: 10,
        leading: Image.asset(
          imagePath,
          width: 35.w,
          height: 35.w,
        ),
        onTap: () => Scaffold.of(context).openDrawer(),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterButton(AppStrings.all),
              _buildFilterButton(AppStrings.music),
              _buildFilterButton(AppStrings.podcasts),
            ],
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _observerSection<PlaylistItem>(title1, viewModel.itemsPlaylist),
          _observerSection<NewReleasesItem>(title2, viewModel.itemsNewReleases),
          _observerSection<UserTopArtistsItem>(title3, viewModel.itemsUserTopArtists),
          
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: SizedBox(
        height: 30.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blackPanther,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            minimumSize: Size(0, 30.h),
            shape: const StadiumBorder(),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {},
          child: Text(
            text,
            style: TextStyle(color: AppColors.white, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }

  Widget _observerSection<T>(String title, List<T> items) {
    return Observer(
      builder: (context) {
        return _HorizontalMediaSection<T>(
          viewModel: viewModel,
          items: items,
          itemCount: items.length,
          sectionTitle: title,
        );
      },
    );
  }
}

class _HorizontalMediaSection<T> extends StatelessWidget {
  const _HorizontalMediaSection({
    super.key,
    required this.viewModel,
    required this.sectionTitle,
    required this.itemCount,
    required this.items,
  });

  final HomeViewModel viewModel;
  final String sectionTitle;
  final int itemCount;
  final List<T> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 19.sp, 
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        SizedBox(
       
          height: 210.h, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            padding: EdgeInsets.only(left: 20.w),
            itemBuilder: (context, index) {
              final item = items[index] as HomeItem;
              final imageUrl = (item.imagesUrl != null && item.imagesUrl!.isNotEmpty)
                  ? item.imagesUrl
                  : null;

              return Container(
                width: 155.w,
                margin: EdgeInsets.only(right: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 155.w,
                      height: 155.w,
                      child: imageUrl == null
                          ? CustomIcon(
                              iconData: Icons.music_note,
                              iconSize: IconSize.mega,
                              color: AppColors.darkToneInk,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Padding(
                     
                      padding: EdgeInsets.only(top: 6.h),
                      child: Text(
                        item.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    Text(
                      item.subTitle ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}