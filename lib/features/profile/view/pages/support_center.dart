import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/support_controller.dart';

class SupportCenter extends StatelessWidget {
  SupportCenter({super.key});
  final controller = Get.put(SupportCenterController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SUPPORT CENTER",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ListView.separated(
            itemCount: controller.faqList.length,
            separatorBuilder: (_, _) => Divider(
              thickness: 1,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              height: 40,
            ),
            itemBuilder: (context, index) {
              return Obx(() {
                final isExpanded = controller.expandedIndex.value == index;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleExpand(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              controller.faqList[index]["title"]!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: isExpanded
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 16),
                      Text(
                        controller.faqList[index]["content"]!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ],
                );
              });
            },
          ),
        ),
      ),
    );
  }
}