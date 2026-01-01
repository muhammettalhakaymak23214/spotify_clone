import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Paket eklendi
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/widgets/bottom_sheet/create_bottom_sheet.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.tabController.index;
    widget.tabController.addListener(() {
      if (mounted) {
        setState(() => currentIndex = widget.tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
     
      height: 75.h, 
      padding: EdgeInsets.zero,
      child: Row(
        children: _MainTab.values.map((tab) {
          final index = _MainTab.values.indexOf(tab);
          final isSelected = currentIndex == index;
          final color = isSelected && index != 4 ? AppColors.green : AppColors.grey;

          return Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (tab == _MainTab.create) {
                  CreateBottomSheet().customShowModalBottom(context);
                } else {
                  widget.tabController.index = index;
                }
              },
              child: AnimatedScale(
                scale: isSelected ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    tab.getIcon(color, 22.sp), 
                    
                    SizedBox(height: 4.h), 
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tab.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: color,
                          
                            fontSize: 11.sp, 
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

enum _MainTab { home, search, library, premium, create }

extension _MainTabExtension on _MainTab {
  String get title {
    switch (this) {
      case _MainTab.home: return "Ana Sayfa";
      case _MainTab.search: return "Ara";
      case _MainTab.library: return "Kitaplığın";
      case _MainTab.premium: return "Premium";
      case _MainTab.create: return "Oluştur";
    }
  }

  Widget getIcon(Color color, double size) {
    IconData iconData;
    switch (this) {
      case _MainTab.home: iconData = FontAwesomeIcons.house; break;
      case _MainTab.search: iconData = FontAwesomeIcons.magnifyingGlass; break;
      case _MainTab.library: iconData = FontAwesomeIcons.bookBookmark; break;
      case _MainTab.premium: iconData = FontAwesomeIcons.spotify; break;
      case _MainTab.create: iconData = FontAwesomeIcons.plus; break;
    }
    return FaIcon(iconData, size: size, color: color);
  }
}