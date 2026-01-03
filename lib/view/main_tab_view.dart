import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/enums/media_type.dart';
import 'package:spotify_clone/view/home_view.dart';
import 'package:spotify_clone/view/library_view.dart';
import 'package:spotify_clone/view/premium_view.dart';
import 'package:spotify_clone/view/recently_played_view.dart';
import 'package:spotify_clone/view/search_view.dart';
import 'package:spotify_clone/view/track_list_view.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_bottom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_drawer.dart';
import 'package:spotify_clone/widgets/mini_player/mini_player.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({
    super.key,
    this.initialIndex = 0,
    this.id = "",
    this.title = "",
    this.imageUrl = "",
    this.type = MediaType.album,
  });

  final String id;
  final String title;
  final String? imageUrl;
  final MediaType type;

  final int initialIndex;

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final double bottomNavigatorBarHeight = 60.h + 75.h + 2.h;
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      body: tabBarView(
        tabController,
        scaffoldKey,
        widget.id,
        widget.title,
        widget.imageUrl,
        widget.type,
      ),

      bottomNavigationBar: SafeArea(
  child: SizedBox(
    
    height: 145.h, 
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w, 
            vertical: 1.h,   
          ),
          child: MiniPlayer(),
        ),
        
        CustomBottomAppBar(tabController: tabController),
      ],
    ),
  ),
),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: CustomDrawer(),
      ),
    );
  }
}

TabBarView tabBarView(
  TabController controller,
  GlobalKey<ScaffoldState> scaffoldKey,
  final String id,
  final String title,
  final String? imageUrl,
  final MediaType type,
) {
  return TabBarView(
    controller: controller,
    physics: NeverScrollableScrollPhysics(),
    children: [
      HomeView(),
      SearchView(scaffoldKey: scaffoldKey),
      LibraryView(),
      PremiumView(),
      RecentlyPlayedView(),
      TrackListView(id: id, title: title, type: type, imageUrl: imageUrl),
    ],
  );
}
