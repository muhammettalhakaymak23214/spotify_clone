import 'package:flutter/material.dart';
import 'package:spotify_clone/view/home_view.dart';
import 'package:spotify_clone/view/library_view.dart';
import 'package:spotify_clone/view/premium_view.dart';
import 'package:spotify_clone/view/search_view.dart';
import 'package:spotify_clone/widgets/custom_bottom_app_bar.dart';
import 'package:spotify_clone/widgets/custom_drawer.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      body: tabBarView(tabController , scaffoldKey),
      bottomNavigationBar: CustomBottomAppBar(tabController: tabController),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: CustomDrawer(),
      ),
    );
  }
}



TabBarView tabBarView(TabController controller , GlobalKey<ScaffoldState> scaffoldKey) {
  return TabBarView(
    controller: controller,
    physics: NeverScrollableScrollPhysics(),
    children: [HomeView(), SearchView(scaffoldKey: scaffoldKey), LibraryView(), PremiumView()],
  );
}