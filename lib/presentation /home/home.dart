import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import 'home_view_model.dart';
import 'widgets/generate_screen.dart';
import 'widgets/settings_screen.dart';
import '../stories/stories.dart';
import '../../core/utils/theme.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    GenerateScreen(),
    StoriesPage(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: IndexedStack(
        index: homeProvider.selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(context, homeProvider),
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context, HomeProvider homeProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double tabWidth = screenWidth / 3;
    final double circlePosition = homeProvider.selectedIndex * tabWidth;

    return Container(
      height: 80.h,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: AppTheme.borderDarker, width: 1.5)),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: circlePosition,
            width: tabWidth,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, homeProvider, icon: Symbols.stylus_fountain_pen, label: 'Generate', index: 0),
              _buildNavItem(context, homeProvider, icon: Icons.auto_stories, label: 'Stories', index: 1),
              _buildNavItem(context, homeProvider, icon: Icons.settings, label: 'Settings', index: 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, HomeProvider homeProvider, {required IconData icon, required String label, required int index}) {
    final isSelected = homeProvider.selectedIndex == index;
    final color = isSelected ? Colors.white : AppTheme.textMutedDark;

    return Expanded(
      child: InkWell(
        onTap: () => homeProvider.setTabIndex(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
