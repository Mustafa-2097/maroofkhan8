import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/view/PaymentScreen.dart';
import '../controller/subscription_controller.dart';

void showSubscriptionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.primaryColorLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (context) {
      return const SubscriptionBottomSheet();
    },
  );
}

class SubscriptionBottomSheet extends StatelessWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Obx(() {
        if (controller.isSingleLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(50.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final plan = controller.selectedPlan.value;
        if (plan == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(50.0),
              child: Text(
                "Failed to load plan details",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
                width: 60.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        (plan.title ?? 'PLAN').toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Price Section
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/subscription_logo.png",
                          color: Colors.white,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (plan.previousPrice != null) ...[
                              Text(
                                '\$${plan.previousPrice}',
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
                              '\$${plan.price ?? 0}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              '/${plan.type ?? 'PLAN'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Feature Description
                    Text(
                      'Under this package, you will be entitled to these features:',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Feature List Title
                    Text(
                      'Feature List',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Feature Items
                    ..._buildFeatureList(plan.features ?? []),
                    SizedBox(height: 16.h),

                    // Buy Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          //Get.back(); // Close bottom sheet
                          // Then process payment
                          Get.to(() => const PaymentScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h), // Extra padding at bottom
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  List<Widget> _buildFeatureList(List<String> features) {
    return features
        .map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: AppColors.whiteColor, size: 18.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
