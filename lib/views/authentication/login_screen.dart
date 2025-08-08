import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/constant/const.dart';
import 'package:petemergency/utils/theme/colors.dart';
import 'package:petemergency/views/authentication/register_screen.dart';

import '../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              // Header
              Center(
                child: Image.asset(
                  ImageUrl.cat_dog,
                  height: 200.h,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16.h),

              // Email Field
              Obx(() => TextField(
                controller: authController.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: authController.errorMessage.value.isNotEmpty &&
                      authController.errorMessage.value.contains('email')
                      ? authController.errorMessage.value
                      : null,
                  prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              )),
              SizedBox(height: 20.h),

              // Password Field
              Obx(() => TextField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: authController.errorMessage.value.isNotEmpty &&
                      authController.errorMessage.value.contains('password')
                      ? authController.errorMessage.value
                      : null,
                  prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              )),
              // SizedBox(height: 8.h),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {
              //       // Add forgot password functionality
              //     },
              //     child: Text(
              //       'Forgot Password?',
              //       style: TextStyle(color: kPrimaryColor),
              //     ),
              //   ),
              // ),
              SizedBox(height: 26.h),

              // Login Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => authController.login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: kWhiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
              SizedBox(height: 24.h),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[400])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text('OR', style: TextStyle(color: Colors.grey[600],fontSize: 18.sp)),
                  ),
                  Expanded(child: Divider(color: Colors.grey[400])),
                ],
              ),
              SizedBox(height: 8.h),

              // Register Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600],fontSize: 14.sp),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => RegisterScreen(),transition: Transition.rightToLeft),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600, fontSize: 14.sp
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}