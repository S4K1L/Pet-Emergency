import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petemergency/utils/theme/colors.dart';
import '../controller/feedback_controller.dart';

class FeedbackScreen extends StatelessWidget {
  final FeedbackController controller = Get.put(FeedbackController());
  final bool backOn;

  FeedbackScreen({super.key, required this.backOn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kTopBackGroundColor,
        automaticallyImplyLeading: false,
        leading: backOn ? IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
          onPressed: () => Get.back(),
        ) : null,
        title: Text(
          'Feedback',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Feedback Options Section
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'We value your feedback!',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please choose how you would like to provide feedback:',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 30.h),

                  // Google Form Option
                  _buildOptionCard(
                    icon: Icons.description,
                    title: 'Complete Survey',
                    subtitle: 'Open a detailed Google Form survey',
                    onTap: controller.openGoogleForm,
                  ),
                  SizedBox(height: 20.h),

                  // OR divider
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text('OR', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // In-app Feedback Option
                  _buildOptionCard(
                    icon: Icons.feedback,
                    title: 'Quick Feedback',
                    subtitle: 'Share your thoughts directly in the app',
                    onTap: () => _showInAppFeedbackDialog(),
                  ),

                  // Thank you message
                  Obx(() => controller.showThankYou.value
                      ? Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      'Thank you for your feedback!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : SizedBox()),
                ],
              ),
            ),
          ),

          // Feedback List Section
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'Recent Feedback',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() => ListView.builder(
                      padding: EdgeInsets.only(bottom: 20.w),
                      itemCount: controller.feedbackList.length,
                      itemBuilder: (context, index) {
                        final feedback = controller.feedbackList[index];
                        return _buildFeedbackItem(feedback);
                      },
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.w),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(icon, size: 32.w, color: kPrimaryColor),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackItem(Map<String, dynamic> feedback) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                feedback['user'] ?? 'Anonymous',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                feedback['timestamp'] != null
                    ? DateFormat('MMM d, y - h:mm a').format(feedback['timestamp'])
                    : '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            feedback['text'] ?? '',
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  void _showInAppFeedbackDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Share Your Feedback'),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => controller.feedbackText.value = value,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What do you like or what can we improve?',
                border: OutlineInputBorder(),
              ),
            ),
            if (controller.isSubmitting.value)
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: CircularProgressIndicator(),
              ),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            onPressed: () async {
              await controller.submitFeedback();
              Get.back();
            },
            child: Text('Submit', style: TextStyle(color: kWhiteColor)),
          ),
        ],
      ),
    );
  }
}