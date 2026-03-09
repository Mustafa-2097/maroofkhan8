import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/view/PaymentWebView.dart';
import 'package:maroofkhan8/core/utils/snackbar_utils.dart';
import 'package:maroofkhan8/features/profile/controller/profile_controller.dart';
import '../controller/subscription_controller.dart';

void showSubscriptionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        final plan = controller.selectedPlan.value;
        if (plan == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                "Failed to load plan details",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
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
                          color: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              '/${plan.type ?? 'PLAN'}',
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
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
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Feature Items
                    ..._buildFeatureList(context, plan.features ?? []),
                    SizedBox(height: 16.h),

                    // Buy Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (plan.id == null) {
                            Get.snackbar("Error", "Invalid plan selected");
                            return;
                          }

                          final profileController =
                              Get.find<ProfileController>();
                          if (profileController.isSubscribed.value) {
                            if (profileController.currentPlan.value
                                    ?.toLowerCase() ==
                                plan.title?.toLowerCase()) {
                              Get.snackbar(
                                "Already Subscribed",
                                "You are already active on the ${plan.title} plan.",
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                              return;
                            }
                          }

                          // Show loading indicator
                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          try {
                            final sessionUrl = await controller
                                .createCheckoutSession(plan.id!);

                            // Always close loading dialog before navigating or showing snackbar
                            if (Get.isDialogOpen ?? false) Get.back();

                            if (sessionUrl != null) {
                              final result = await Get.to(
                                () => PaymentWebView(url: sessionUrl),
                              );
                              if (result == true) {
                                // Refresh user data to get the latest subscription status
                                profileController.fetchUserData();
                                // Close the bottom sheet wrapper if needed
                                if (Get.isBottomSheetOpen ?? false) {
                                  Get.back();
                                }
                              }
                            } else {
                              // Use consistent snackbar design
                              Get.snackbar(
                                "Error",
                                "Could not create payment session",
                                backgroundColor: AppColors.redColor.withOpacity(
                                  0.9,
                                ),
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            // Ensure dialog is closed even on error
                            if (Get.isDialogOpen ?? false) Get.back();
                            // Show error snackbar manually after dialog closes
                            SnackbarUtils.showSnackbar(
                              "Error",
                              e.toString(),
                              isError: true,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
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

  List<Widget> _buildFeatureList(BuildContext context, List<String> features) {
    return features
        .map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
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
                    feature,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
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
