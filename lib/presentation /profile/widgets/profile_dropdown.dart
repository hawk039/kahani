import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme.dart';
import '../view_models/profile_view_model.dart';

class ProfileDropdown extends StatelessWidget {
  final VoidCallback onLogout; // Add a callback for logout

  const ProfileDropdown({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            width: 200.w,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTheme.borderDarker, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdownItem(icon: Icons.account_circle, text: 'Change Avatar', onTap: () {}),
                _buildDropdownItem(icon: Icons.edit, text: 'Edit Profile', onTap: () {}),
                const Divider(color: AppTheme.borderDarker, height: 1),
                _buildDropdownItem(
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () async {
                    await viewModel.logout();
                    onLogout(); // Call the callback to navigate
                  },
                  isLogout: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final color = isLogout ? Colors.red : AppTheme.textMutedLight;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: isLogout ? Colors.red : AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
