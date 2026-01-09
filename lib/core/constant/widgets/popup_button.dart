import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';

class PopupButton extends StatelessWidget {
  final VoidCallback onTap;
  const PopupButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      color: Colors.white,
      icon: Icon(Icons.more_horiz, size: 24.r, color: AppColors.boxTextColor),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "details",
          child: GestureDetector(
            onTap: onTap,
            child: Text("Details"),
          ),
        ),
        // Divider Style Item
        PopupMenuItem(
          enabled: false,
          height: 1.h,
          child: Container(height: 1.h, color: Colors.grey.shade300),
        ),
        PopupMenuItem(
          value: "delete",
          child: Text("Delete", style: TextStyle(color: AppColors.redColor)),
        ),
      ],
    );
  }
}
