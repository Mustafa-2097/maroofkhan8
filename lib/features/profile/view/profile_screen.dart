import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maroofkhan8/features/profile/view/widgets/profile_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "PROFILE",
          style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w), // Standard 24px padding
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),

                /// User Image
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                        radius: 50.r,
                        backgroundColor: theme.colorScheme.surface,
                        child: Icon(Icons.person, size: 55.r, color: theme.disabledColor)
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(Icons.camera_enhance_outlined, size: 16.r, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                /// Name + Username
                Column(
                  children: [
                    Text(
                      "Username",
                      style: theme.textTheme.headlineSmall,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "user.example@gmail.com",
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                    )
                  ],
                ),
                SizedBox(height: 24.h),

                /// Status box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: isDark ? theme.colorScheme.surface : theme.colorScheme.primary.withOpacity(0.1),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Your Plan Status",
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: theme.colorScheme.primary,
                              ),
                              child: Text(
                                "Upgrade",
                                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: isDark ? theme.colorScheme.primary.withOpacity(0.5) : Colors.white,
                                border: isDark ? null : Border.all(color: theme.colorScheme.primary),
                              ),
                              child: Text(
                                "Basic",
                                style: theme.textTheme.labelMedium?.copyWith(
                                    color: isDark ? Colors.white : theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "Plan expire: 12/12/2025",
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 24.h),

                /// Personal Info section (The List)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const ProfileList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}