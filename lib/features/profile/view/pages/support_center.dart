import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/support_controller.dart';

class SupportCenter extends StatelessWidget {
  SupportCenter({super.key});
  final controller = Get.put(SupportCenterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SUPPORT CENTER",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
          child: ListView.separated(
            itemCount: controller.faqList.length,
            separatorBuilder: (_, _) => Divider(
              thickness: 1.3.w,
              color: Colors.black12,
              height: 40.h,
            ),
            itemBuilder: (context, index) {
              return Obx(() {
                final isExpanded =
                    controller.expandedIndex.value == index;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          controller.toggleExpand(index),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              controller.faqList[index]["title"]!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isExpanded
                                    ? Colors.black54
                                    : Colors.black,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 28.r,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      SizedBox(height: 10.h),
                      Text(
                        controller.faqList[index]["content"]!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Colors.black87,
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
