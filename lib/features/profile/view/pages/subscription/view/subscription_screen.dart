import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/widgets/subscription_bottom_sheet.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withValues(alpha: 0.95),
                    backgroundColor,
                    backgroundColor,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade50,
                    Colors.grey.shade100,
                    Colors.white,
                  ],
                ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final horizontalPadding = constraints.maxWidth * 0.05;

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'SUBSCRIPTION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 40.w), // For symmetry
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              'SUBSCRIBE TO PREMIUM',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),

                            // Subtitle
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 100.w : 20.w,
                              ),
                              child: Text(
                                'Enjoy watching Full-HD videos, without restrictions and without ads',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // Subscription Plans
                            if (isWide)
                              Wrap(
                                spacing: 20.w,
                                runSpacing: 20.h,
                                alignment: WrapAlignment.center,
                                children: _buildPlanCards(context, isWide),
                              )
                            else
                              Column(
                                children: _buildPlanCards(context, isWide)
                                    .map(
                                      (card) => Padding(
                                        padding: EdgeInsets.only(bottom: 20.h),
                                        child: card,
                                      ),
                                    )
                                    .toList(),
                              ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlanCards(BuildContext context, bool isWide) {
    final cardWidth = isWide ? 400.w : double.infinity;
    return [
      _buildPlanCard(
        context: context,
        cardWidth: cardWidth,
        originalPrice: '\$9.99',
        discountedPrice: '\$7.99',
        savePercent: '20%',
      ),
      _buildPlanCard(
        context: context,
        cardWidth: cardWidth,
        originalPrice: '\$9.99',
        discountedPrice: '\$7.99',
        savePercent: '20%',
        isMostPopular: true,
      ),
    ];
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required double cardWidth,
    required String originalPrice,
    required String discountedPrice,
    required String savePercent,
    bool isMostPopular = false,
  }) {
    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Section
          Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/subscription_logo.png",
                  color: AppColors.primaryColorLight,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        originalPrice,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        discountedPrice,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '/Duration-30 days',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Save $savePercent',
                    style: TextStyle(
                      color: AppColors.primaryColorLight,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: 10.h),

          // Features
          _buildFeatureRow("Full Qur'an (Arabic + Transliteration)."),
          SizedBox(height: 12.h),
          _buildFeatureRow('Audio Recitation (Multiple Qaris).'),
          SizedBox(height: 12.h),
          _buildFeatureRow('Full Hadith Collections.'),
          SizedBox(height: 12.h),

          // See more button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                showSubscriptionBottomSheet(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'See more',
                style: TextStyle(
                  color: AppColors.primaryColorLight,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryColorLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: AppColors.primaryColorLight, size: 18.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
