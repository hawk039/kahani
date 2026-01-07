import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
// Corrected import paths
import 'widgets/generate_screen.dart';
import 'widgets/settings_screen.dart';
import '../stories/stories.dart';

import '../../core/utils/theme.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Default to the Stories tab

  static const List<Widget> _widgetOptions = <Widget>[
    GenerateScreen(),
    StoriesPage(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double tabWidth = screenWidth / 3;
    final double circlePosition = _selectedIndex * tabWidth;

    return Container(
      height: 80.h,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: AppTheme.borderDarker, width: 1.5)),
      ),
      child: Stack(
        children: [
          // Animated blue circle background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: circlePosition,
            width: tabWidth,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 70, // Size of the circle
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondary, 
                ),
              ),
            ),
          ),
          // The icons and text row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Symbols.stylus_fountain_pen, label: 'Generate', index: 0),
              _buildNavItem(icon: Icons.auto_stories, label: 'Stories', index: 1),
              _buildNavItem(icon: Icons.settings, label: 'Settings', index: 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _selectedIndex == index;
    // The icon is always white when inside the moving circle, otherwise it's muted.
    final color = isSelected ? Colors.white : AppTheme.textMutedDark;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
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
