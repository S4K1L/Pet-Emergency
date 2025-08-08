import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/theme/colors.dart';
import '../../controller/auth_controller.dart';
import '../../utils/constant/const.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  RegisterScreen({super.key});

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
              SizedBox(height: 60.h),
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
                  onPressed: () => Get.back(),
                ),
              ),
              Center(child: Image.asset(ImageUrl.cat_dog, height: 200.h)),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Fill in your details to continue',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 16.h),

              // Email Field
              Obx(
                () => TextField(
                  controller: _authController.registerNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    errorText:
                        _authController.errorMessage.value.isNotEmpty &&
                                _authController.errorMessage.value.contains(
                                  'name',
                                )
                            ? _authController.errorMessage.value
                            : null,
                    prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Obx(
                () => TextField(
                  controller: _authController.registerEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        _authController.errorMessage.value.isNotEmpty &&
                                _authController.errorMessage.value.contains(
                                  'email',
                                )
                            ? _authController.errorMessage.value
                            : null,
                    prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Password Field
              Obx(
                () => TextField(
                  controller: _authController.registerPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText:
                        _authController.errorMessage.value.isNotEmpty &&
                                _authController.errorMessage.value.contains(
                                  'password',
                                )
                            ? _authController.errorMessage.value
                            : null,
                    prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Confirm Password Field
              Obx(
                () => TextField(
                  controller: _authController.confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText:
                        _authController.errorMessage.value.isNotEmpty &&
                                _authController.errorMessage.value.contains(
                                  'match',
                                )
                            ? _authController.errorMessage.value
                            : null,
                    prefixIcon: Icon(Icons.lock_outline, color: kPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Register Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _authController.isLoading.value
                            ? null
                            : () => _authController.register(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child:
                        _authController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: kWhiteColor,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
