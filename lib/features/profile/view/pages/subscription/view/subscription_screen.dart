import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/controller/subscription_controller.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/widgets/subscription_bottom_sheet.dart';
import 'package:maroofkhan8/features/profile/controller/profile_controller.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          tr('subscription').toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final horizontalPadding = constraints.maxWidth * 0.05;

            return Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.subscriptionPlans.isEmpty) {
                      return Center(child: Text(tr("no_subscription_plans")));
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
                              tr('subscribe_to_premium'),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                tr('subscription_subtitle'),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).disabledColor,
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
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildPlanCards(BuildContext context, bool isWide) {
    final cardWidth = isWide ? 400.w : double.infinity;
    final profileController = Get.find<ProfileController>();

    return controller.subscriptionPlans.map((plan) {
      final bool isCurrent =
          profileController.currentPlan.value?.toLowerCase() ==
          plan.title?.toLowerCase();

      return _buildPlanCard(
        context: context,
        cardWidth: cardWidth,
        title: _getLocalizedPlanTitle(plan.title),
        price: '${plan.price ?? 0}',
        previousPrice: plan.previousPrice != null
            ? '${plan.previousPrice}'
            : null,
        type: plan.type ?? 'PLAN',
        features: plan.features ?? [],
        isMostPopular: plan.title?.toLowerCase() == 'premium',
        isCurrent: isCurrent,
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
    bool isCurrent = false,
    required VoidCallback onSeeMore,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isCurrent) ...[
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      tr("current_plan"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '/$type',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Divider(color: Theme.of(context).dividerColor),
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
                tr('see_more'),
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryColorDark
                      : AppColors.primaryColorLight,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: isDark
                      ? AppColors.primaryColorDark
                      : AppColors.primaryColorLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedPlanTitle(String? title) {
    if (title == null) return 'No Title';
    final lowercaseTitle = title.toLowerCase();
    if (lowercaseTitle.contains('premium')) return tr('premium_plan');
    if (lowercaseTitle.contains('basic')) return tr('basic_plan');
    if (lowercaseTitle.contains('free')) return tr('free_plan');
    return title;
  }

  Widget _buildFeatureRow(String text) {
    return Builder(
      builder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
              size: 18.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
