import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/theme/colors.dart';
import '../controller/triage_controller.dart';

class TriageToolScreen extends StatelessWidget {
  final TriageController controller = Get.put(TriageController());
  final bool backOn;

  TriageToolScreen({super.key, required this.backOn,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kTopBackGroundColor,
        title: Text('Triage Tool',style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.w600),),
        centerTitle: true,
        leading: backOn ? IconButton(
          icon: Icon(Icons.arrow_back_ios,color: kPrimaryColor,),
          onPressed: () {
            if (controller.currentStep.value == TriageStep.species) {
              Navigator.pop(context);
            } else {
              controller.restartTriage();
            }
          },
        ) : null,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        switch (controller.currentStep.value) {
          case TriageStep.species:
            return _buildSpeciesSelection();
          case TriageStep.complaint:
            return _buildComplaintSelection();
          case TriageStep.questions:
            return _buildQuestionFlow();
          case TriageStep.result:
            return _buildResult();
          default:
            return _buildSpeciesSelection();
        }
      }),
    );
  }

  Widget _buildSpeciesSelection() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1 of 4',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            'What species is your pet?',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              children: controller.speciesList.map((species) {
                return _buildSelectionCard(
                  title: species,
                  icon: _getSpeciesIcon(species),
                  onTap: () => controller.selectSpecies(species),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintSelection() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2 of 4',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            'What is the main concern?',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView(
              children: controller.complaintList.map((complaint) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildListOption(
                    title: complaint,
                    onTap: () => controller.selectComplaint(complaint),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionFlow() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3 of 4',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please answer:',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.currentQuestion.value,
                  style: TextStyle(fontSize: 20.sp, height: 1.4),
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        onPressed: () => controller.answerQuestion(true),
                        child: Text('YES', style: TextStyle(fontSize: 18.sp)),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        onPressed: () => controller.answerQuestion(false),
                        child: Text('NO', style: TextStyle(fontSize: 18.sp)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Question ${controller.questionIndex.value + 1} of ${controller.questions.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 4 of 4',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: controller.getResultColor().withOpacity(0.1),
              border: Border.all(
                color: controller.getResultColor(),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'TRIAGE RESULT',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: controller.getResultColor(),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  controller.triageResult.value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: controller.getResultColor(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Recommended Action:',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Text(
            controller.suggestedAction.value,
            style: TextStyle(fontSize: 16.sp, height: 1.5),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: Size(double.infinity, 50.h),
            ),
            onPressed: controller.restartTriage,
            child: Text('Start New Triage', style: TextStyle(fontSize: 18.sp,color: kWhiteColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40.w, color: kPrimaryColor),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListOption({required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 16.sp)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
        onTap: onTap,
      ),
    );
  }

  IconData _getSpeciesIcon(String species) {
    switch (species) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.catching_pokemon;
      default:
        return Icons.help_outline;
    }
  }
}