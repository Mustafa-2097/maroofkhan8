import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          //LanguageDropdown(),
          _DrawerItem(
            icon: Icons.notifications_outlined,
            label: 'Notification Setting',
            //onTap: () => Get.to(() => NotificationSettingPage()),
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

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// WARNING ICON
              Container(
                height: 64.h,
                width: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5A5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 32.r,
                ),
              ),

              SizedBox(height: 20.h),

              /// TITLE
              Text(
                "LOGOUT".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),

              SizedBox(height: 12.h),

              /// DESCRIPTION
              Text(
                "Are you sure you want to log out? "
                    "You will need to sign in again to access your account.".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 28.h),

              /// BUTTONS
              Row(
                children: [
                  /// LOGOUT
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF5A5A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: handle logout
                      },
                      child: Text(
                        "Logout".tr,
                        style: TextStyle(
                          color: const Color(0xFFFF5A5A),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  /// CANCEL
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),
            ],
          ),
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
    return SizedBox(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: const Color(0xFFDF1C41),
            width: 1.3.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 6.h,
          ),
        ),
        icon: Icon(
          Icons.logout,
          color: const Color(0xFFDF1C41),
          size: 22.r,
        ),
        label: Text(
          'logout'.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFDF1C41),
          ),
        ),
      ),
    );
  }
}