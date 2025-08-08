import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/constant/const.dart';
import 'package:petemergency/utils/theme/colors.dart';

import '../controller/education_and_quiz_controller.dart';

class EducationAndQuizScreen extends StatelessWidget {
  final EducationAndQuizController controller =
  Get.put(EducationAndQuizController());
  final bool backOn;

  EducationAndQuizScreen({super.key, required this.backOn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBar(
          leading: backOn ? IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
            onPressed: () => Get.back(),
          ) : null,
          automaticallyImplyLeading: false,
          backgroundColor: kTopBackGroundColor,
          elevation: 0,
          title: Text('Education & Quiz',style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.w600),),
          centerTitle: true,
        ),
      ),
      body: Obx(() {
        if (controller.quizCompleted.value) {
          return _buildResultsScreen();
        }
        return _buildQuestionScreen();
      }),
      bottomNavigationBar: Obx(() {
        if (controller.quizCompleted.value) return SizedBox.shrink();
        return _buildBottomNavBar();
      }),
    );
  }

  Widget _buildQuestionScreen() {
    final currentQuestion = controller.selectedQuestions[controller.currentQuestionIndex.value];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: controller.progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              minHeight: 8,
            ),
            SizedBox(height: 20),

            Text(
              'Pet Emergency Quiz',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            Center(
              child: Image.asset(
                ImageUrl.cat_dog,
                height: 200,
              ),
            ),
            SizedBox(height: 20),

            // Question Text
            Text(
              currentQuestion['question'],
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 24),

            // Options Grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: currentQuestion['options'].length,
              itemBuilder: (context, index) {
                final option = currentQuestion['options'][index];
                return Obx(() {
                  final isSelected = controller.selectedOption.value == option;
                  return OutlinedButton(
                    onPressed: () => controller.selectOption(option),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xFFBFD5E4) : Colors.white,
                      side: BorderSide(color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 20),

            // Explanation (if shown)
            Obx(() {
              if (controller.showExplanation.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(thickness: 2),
                    SizedBox(height: 10),
                    Text(
                      'Explanation:',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.currentExplanation.value,
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Obx(() {
        final isNextButton = !controller.showExplanation.value;
        return ElevatedButton(
          onPressed: () {
            if (controller.selectedOption.isNotEmpty) {
              controller.submitAnswer();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            minimumSize: Size(double.infinity, 50.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            controller.showExplanation.value ? 'Continue' : 'Submit Answer',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResultsScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Your Score:',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${controller.score.value}/${controller.selectedQuestions.length}',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${((controller.score.value / controller.selectedQuestions.length) * 100).round()}% Correct',
              style: TextStyle(
                fontSize: 24.sp,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Reset quiz with new random questions
                controller.selectRandomQuestions();
                controller.currentQuestionIndex.value = 0;
                controller.score.value = 0;
                controller.selectedOption.value = '';
                controller.quizCompleted.value = false;
                controller.showExplanation.value = false;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Take New Quiz',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}