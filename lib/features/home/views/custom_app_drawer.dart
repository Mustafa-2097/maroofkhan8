import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../profile/view/widgets/profile_list.dart';

class CustomAppDrawer extends StatelessWidget {
  final void Function()? onLogoutTap;
  const CustomAppDrawer({super.key, this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Drawer(
      width: sw * 0.8,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        children: [
          Container(
            height: sh * 0.8,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: sw*0.076),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: SafeArea(
              child: ProfileList(),
            ),
          ),
        ],
      ),
    );
  }
}
