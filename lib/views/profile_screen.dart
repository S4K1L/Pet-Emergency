import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/theme/colors.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFFBFD5E4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isEditing.value ? Icons.close : Icons.edit,
                color: kPrimaryColor,
              ),
              onPressed: controller.toggleEdit,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: kPrimaryColor.withOpacity(0.2),
                backgroundImage: controller.photoUrl.value.isNotEmpty
                    ? NetworkImage(controller.photoUrl.value)
                    : null,
                child: controller.photoUrl.value.isEmpty
                    ? Icon(Icons.person, size: 60.r, color: kPrimaryColor)
                    : null,
              ),
              SizedBox(height: 32.h),
              _buildProfileForm(),
              SizedBox(height: 32.h),
              Obx(() {
                return controller.isEditing.value
                    ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    : SizedBox.shrink();
              }),
              SizedBox(height: 24.h),
              TextButton(
                onPressed: controller.logout,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileForm() {
    return Obx(() {
      return Column(
        children: [
          // Name
          TextFormField(
            controller: controller.nameController,
            readOnly: !controller.isEditing.value,
            decoration: InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person, color: kPrimaryColor),
              suffixIcon: !controller.isEditing.value ? Icon(Icons.lock, color: kPrimaryColor) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Email (always read-only)
          TextFormField(
            controller: controller.emailController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email, color: kPrimaryColor),
              suffixIcon: Icon(Icons.lock, color: kPrimaryColor),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Phone
          TextFormField(
            controller: controller.phoneController,
            readOnly: !controller.isEditing.value,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
              suffixIcon: !controller.isEditing.value ? Icon(Icons.lock, color: kPrimaryColor) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      );
    });
  }
}
