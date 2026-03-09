import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';

class PremiumSubscriptionPage extends StatelessWidget {
  const PremiumSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    const Color primaryBrown = AppColors.primaryColorLight;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.05,
                  vertical: sh * 0.05,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'Premium Subscription',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Serif',
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Feature List
                    _buildFeatureItem(
                      icon: Icons.all_inclusive,
                      text: 'Unlimited AI Murshid Interaction',
                    ),
                    _buildFeatureItem(
                      icon: Icons.edit_note_rounded,
                      text: 'Full access to all Auliya Allah Content',
                    ),
                    _buildFeatureItem(
                      icon: Icons.audio_file_outlined,
                      text: 'Audio downloads',
                      showDownloadIcon: true,
                    ),
                    _buildFeatureItem(
                      icon: Icons.cloud_off_outlined,
                      text: 'Complete offline access',
                    ),

                    SizedBox(height: 40.h),

                    // Upgrade Button
                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle upgrade logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBrown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Upgrade to premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    bool showDownloadIcon = false,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Row(
            children: [
              // Circular Icon Container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColorLight,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Icon(icon, color: Colors.white, size: 24.sp),
                    if (showDownloadIcon)
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 12,
                      ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Feature Text
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: isDark ? Colors.grey[300] : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Serif',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
