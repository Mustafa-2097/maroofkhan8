import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maroofkhan8/core/constant/widgets/primary_button.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18.r),
            ),
          ),
        ),
        title: Text(
          "Profile Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            /// --- Profile Image Section ---
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: const NetworkImage(
                          'https://via.placeholder.com/150'), // Replace with your image
                    ),
                  ),
                  Positioned(
                    right: 5.w,
                    bottom: 5.h,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            /// --- Form Fields ---
            _buildLabel("Full Name"),
            _buildTextField(hintText: "User"),

            _buildLabel("Phone number"),
            _buildTextField(hintText: "12345678"),

            _buildLabel("Email"),
            _buildTextField(hintText: "hussainigaladimau@gmail.com"),

            _buildLabel("Country / Region"),
            _buildDropdownField("Bangladesh"),

            _buildLabel("Gender"),
            _buildDropdownField("Men"),

            _buildLabel("Date of Birth"),
            _buildTextField(
              hintText: "--/--/----",
              suffixIcon: Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 20.r),
            ),

            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Save Changes"),
              ),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }

  /// Helper widget for the labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Helper widget for standard Text Fields
  Widget _buildTextField({required String hintText, Widget? suffixIcon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 15.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  /// Helper widget for Dropdown Fields
  Widget _buildDropdownField(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15.sp),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 24.r),
        ],
      ),
    );
  }
}
