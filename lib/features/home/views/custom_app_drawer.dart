import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppDrawer extends StatelessWidget {
  final void Function()? onLogoutTap;
  const CustomAppDrawer({super.key, this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Drawer(
      width: sw * 0.8,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        children: [
          Container(
            height: sh * 0.8,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: sw*0.076),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Personal Info Section
                    Text(
                      'personal_info'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _DrawerItem(
                      icon: Icons.person_outline,
                      label: 'Personal Data',
                      //onTap: () => Get.to(() => PersonalData()),
                    ),
                    _DrawerItem(
                      icon: Icons.star_border,
                      label: 'Bookmarks',
                      //onTap: () => Get.to(() => BookmarkScreen()),
                    ),
                    _DrawerItem(
                      icon: Icons.notifications,
                      label: 'Notification',
                      //onTap: () => Get.to(() => NotificationPage()),
                    ),
                    _DrawerItem(
                      icon: Icons.subscriptions_outlined,
                      label: 'Subscription',
                      //onTap: () => Get.to(() => SubscriptionPage()),
                    ),
                    _DrawerItem(
                      icon: Icons.payment_outlined,
                      label: 'Payment History',
                     // onTap: () => Get.to(() => PaymentHistoryPage()),
                    ),
                
                    SizedBox(height: 18.h),
                
                    /// General Section
                    Text(
                      'General',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
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
                    Text(
                      'about'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _DrawerItem(
                      icon: Icons.contact_mail_outlined,
                      label: 'Contact Us',
                      //onTap: () => Get.to(() => ContactUsPage()),
                    ),
                    _DrawerItem(
                      icon: Icons.help_outline,
                      label: 'Support Center',
                      //onTap: () => Get.to(() => SupportCenterPage()),
                    ),
                    _DrawerItem(
                      icon: Icons.lock_outline,
                      label: 'Privacy & Policy',
                      //onTap: () => Get.to(() => TermsConditionsPage()),
                    ),
                
                    SizedBox(height: 18.h),
                
                    /// Logout Button
                    SizedBox(
                      child: OutlinedButton.icon(
                        onPressed: () => showLogoutBottomSheet(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFDF1C41), width: 1.3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
                        ),
                        icon: Icon(Icons.logout, color: Color(0xFFDF1C41), size: 22.r, fontWeight: FontWeight.bold),
                        label: Text(
                          'logout'.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onTap;

  const _DrawerItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: Colors.black),
            SizedBox(width: 16.w),
            Text(
              label.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF0F1720), // dark background
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// WARNING ICON
            Container(
              height: 64,
              width: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5A5A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "LOGOUT",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            const Text(
              "Are you sure you want to log out? "
                  "You will need to sign in again to access your account.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            /// BUTTONS
            Row(
              children: [
                /// LOGOUT
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF5A5A)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: handle logout
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Color(0xFFFF5A5A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                /// CANCEL
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
