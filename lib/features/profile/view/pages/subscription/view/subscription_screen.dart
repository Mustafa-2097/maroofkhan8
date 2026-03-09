import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/controller/subscription_controller.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/widgets/subscription_bottom_sheet.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final controller = Get.put(SubscriptionController());

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
                          icon: Icon(
                            Icons.arrow_back,
                            color: isDark ? Colors.white : Colors.black,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'SUBSCRIPTION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
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
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.subscriptionPlans.isEmpty) {
                        return const Center(
                          child: Text("No Subscription Plans available"),
                        );
                      }

                      return SingleChildScrollView(
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
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.blackColor,
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
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[600],
                                    // color: Colors.grey[600],
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
                                          padding: EdgeInsets.only(
                                            bottom: 20.h,
                                          ),
                                          child: card,
                                        ),
                                      )
                                      .toList(),
                                ),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                      );
                    }),
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
    return controller.subscriptionPlans.map((plan) {
      return _buildPlanCard(
        context: context,
        cardWidth: cardWidth,
        title: plan.title ?? 'No Title',
        price: '${plan.price ?? 0}',
        previousPrice: plan.previousPrice != null
            ? '${plan.previousPrice}'
            : null,
        type: plan.type ?? 'PLAN',
        features: plan.features ?? [],
        isMostPopular: plan.title?.toLowerCase() == 'premium',
        onSeeMore: () {
          if (plan.id != null) {
            controller.fetchSingleSubscriptionPlan(plan.id!);
            showSubscriptionBottomSheet(context);
          }
        },
      );
    }).toList();
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required double cardWidth,
    required String title,
    required String price,
    String? previousPrice,
    required String type,
    required List<String> features,
    bool isMostPopular = false,
    required VoidCallback onSeeMore,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1.2,
        ),
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
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.primaryColorLight,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
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
                      if (previousPrice != null) ...[
                        Text(
                          '\$$previousPrice',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      Text(
                        '\$$price',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '/$type',
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          SizedBox(height: 10.h),

          // Features
          ...features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildFeatureRow(feature),
            ),
          ),

          // See more button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSeeMore,
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
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check, color: AppColors.primaryColorLight, size: 18.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
