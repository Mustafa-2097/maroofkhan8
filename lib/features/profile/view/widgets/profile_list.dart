import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/profile/view/pages/change_password.dart';
import 'package:maroofkhan8/features/profile/view/pages/contact_us.dart';
import 'package:maroofkhan8/features/profile/view/pages/payment_history.dart';
import 'package:maroofkhan8/features/profile/view/pages/personal_data.dart';
import 'package:maroofkhan8/features/profile/view/pages/save.dart';
import 'package:maroofkhan8/features/profile/view/pages/support_center.dart';
import 'package:maroofkhan8/features/profile/view/pages/terms_conditions.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Personal Info Section
          _SectionHeader(title: 'personal_info'.tr),
          _DrawerItem(
            icon: Icons.person_outline,
            label: 'Personal Data',
            onTap: () => Get.to(() => const PersonalData()),
          ),
          _DrawerItem(
            icon: Icons.star_border,
            label: 'Save',
            onTap: () => Get.to(() => NamesListScreen(
              pageTitle: "Save",
              repository: SaveRepository(),
              useHeartIcon: false,
            )),
          ),
          _DrawerItem(
            icon: Icons.star_border,
            label: 'Favourite',
            onTap: () => Get.to(() => NamesListScreen(
              pageTitle: "Favourite",
              repository: FavoriteRepository(),
              useHeartIcon: true,
            )),
          ),
          _DrawerItem(
            icon: Icons.subscriptions_outlined,
            label: 'Subscription',
            //onTap: () => Get.to(() => SubscriptionPage()),
          ),
          _DrawerItem(
            icon: Icons.payment_outlined,
            label: 'Payment History',
            onTap: () => Get.to(() => const PaymentHistory()),
          ),

          SizedBox(height: 18.h),

          /// General Section
          _SectionHeader(title: 'General'),
          _DrawerItem(
            icon: Icons.notifications_outlined,
            label: 'Change Password',
            onTap: () => Get.to(() => ChangePassword()),
          ),
          _DrawerItem(
            icon: Icons.language_outlined,
            label: 'Language',
            //onTap: () => Get.to(() => NotificationSettingPage()),
          ),

          SizedBox(height: 18.h),

          /// About Section
          _SectionHeader(title: 'about'.tr),
          _DrawerItem(
            icon: Icons.contact_mail_outlined,
            label: 'Contact Us',
            onTap: () => Get.to(() => ContactUs()),
          ),
          _DrawerItem(
            icon: Icons.help_outline,
            label: 'Support Center',
            onTap: () => Get.to(() => SupportCenter()),
          ),
          _DrawerItem(
            icon: Icons.lock_outline,
            label: 'Privacy & Policy',
            onTap: () => Get.to(() => const TermsConditions()),
          ),

          SizedBox(height: 18.h),

          /// Logout Button
          _LogoutButton(
            onPressed: () => _showLogoutBottomSheet(context),
          ),
          SizedBox(height: 18.h)
        ],
      ),
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allows full height control
      isDismissible: true, // Allows swipe down to dismiss
      enableDrag: true, // Allows dragging the bottom sheet
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Initial height (40% of screen)
          minChildSize: 0.4, // Minimum height when swiping down
          maxChildSize: 0.6, // Maximum height when swiping up
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.surface
                    : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Draggable handle indicator
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  /// WARNING ICON
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TITLE
                  Text(
                    "LOGOUT",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// DESCRIPTION
                  Text(
                    "Are you sure you want to log out? "
                        "You will need to sign in again to access your account.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// BUTTONS - Wrap in Container to prevent swiping issues
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 56, // Minimum button height
                    ),
                    child: Row(
                      children: [
                        /// CANCEL
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: isDark
                                  ? Colors.grey.shade900.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// LOGOUT
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade500,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // TODO: handle logout logic
                            },
                            child: Text(
                              "Logout",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Safe area spacer for devices with notches
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom > 0
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 0,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.r,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            SizedBox(width: 16.w),
            Text(
              label.tr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 24.r,
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Professional red colors for light/dark modes
    final logoutRed = isDark
        ? const Color(0xFFE57373) // Softer, desaturated red for Dark Mode
        : const Color(0xFFDF1C41); // Your original brand red for Light Mode

    return SizedBox(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.logout, color: logoutRed),
        label: Text(
          "Logout",
          style: TextStyle(color: logoutRed, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: logoutRed),
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 6.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}