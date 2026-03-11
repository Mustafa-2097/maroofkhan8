import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:maroofkhan8/core/utils/localization_utils.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/view/subscription_screen.dart';
import 'package:maroofkhan8/features/profile/view/widgets/profile_list.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          tr("profile"), // "PROFILE",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// User Image
              Obx(
                () => CircleAvatar(
                  radius: 50,
                  backgroundColor: isDark
                      ? const Color(0xFF494358)
                      : Colors.grey.shade200,
                  backgroundImage: controller.avatar.value.isNotEmpty
                      ? NetworkImage(controller.avatar.value)
                      : null,
                  child: controller.avatar.value.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              /// Name + Username
              Obx(
                () => Text(
                  controller.name.value,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Obx(
                () => Text(
                  controller.email.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 22),

              /// Status box (Plan)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                child: Column(
                  children: [
                    Obx(() {
                      // Hide upgrade button and center text if user has any active subscription
                      if (controller.isSubscribed.value) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr("your_plan_status"), // "Your Plan Status",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (controller.currentPlanType.value ??
                                        controller.currentPlan.value ??
                                        "")
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr("your_plan_status"), // "Your Plan Status",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          InkWell(
                            onTap: () => Get.to(() => SubscriptionPage()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tr("upgrade"), // "Upgrade",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Obx(() {
                                String planKey = controller.isSubscribed.value
                                    ? (controller.currentPlan.value ??
                                          "basic_plan")
                                    : "free_plan";
                                return Text(
                                  tr(planKey),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const Spacer(),
                        Obx(() {
                          if (!controller.isSubscribed.value) {
                            return Text(
                              tr("Inactive"),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: const Color.fromARGB(
                                      255,
                                      153,
                                      21,
                                      11,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                            );
                          }
                          return Text(
                            tr("Active"),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        }),
                      ],
                    ),
                    // Subscription end date row (only for subscribed users)
                    Obx(() {
                      if (!controller.isSubscribed.value ||
                          controller.subscriptionEndDate.value == null) {
                        return const SizedBox.shrink();
                      }
                      final endDate = controller.subscriptionEndDate.value!;
                      // Localized date format: day/month/year
                      final formattedDate =
                          "${localizeDigits(endDate.day.toString().padLeft(2, '0'), context)}"
                          "/${localizeDigits(endDate.month.toString().padLeft(2, '0'), context)}"
                          "/${localizeDigits(endDate.year.toString(), context)}";

                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Expires on',
                                // tr("subscription_expires_on"),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white60
                                          : Colors.black54,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                formattedDate,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Personal Info List
              const ProfileList(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
