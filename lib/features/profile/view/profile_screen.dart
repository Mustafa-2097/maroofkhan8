import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                        return Center(
                          child: Text(
                            tr("your_plan_status"), // "Your Plan Status",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
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
                            return const SizedBox.shrink();
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
