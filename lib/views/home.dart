import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/theme/colors.dart';
import 'package:petemergency/views/education_and_quiz.dart';
import '../utils/widgets/menu_card.dart';
import 'clicnic_communication_screen.dart';
import 'emergency_protocols.dart';
import 'feed_back.dart';
import 'triage_tool_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor, // Light background color
      appBar: AppBar(
        backgroundColor: kTopBackGroundColor, // Blue top bar
        title: Text('Pet Emergency',style: TextStyle(fontWeight: FontWeight.w600,color: kPrimaryColor,fontSize: 22.sp),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  MenuCard(
                    onPress: () {
                      Get.to(()=> TriageToolScreen(backOn: true,),transition: Transition.rightToLeft);
                    },
                    icon: Icons.medical_services,
                    title: 'Triage\nTool',
                  ),
                  MenuCard(
                    onPress: () {
                      Get.to(()=> EmergencyProtocolsScreen(),transition: Transition.rightToLeft);
                    },
                    icon: Icons.description,
                    title: 'Emergency\nProtocols',
                  ),
                  MenuCard(
                    onPress: () {
                      Get.to(()=> EducationAndQuizScreen(backOn: true),transition: Transition.rightToLeft);
                    },
                    icon: Icons.school,
                    title: 'Education\n& Quiz',
                  ),
                  MenuCard(
                    onPress: () {
                      Get.to(()=> ClinicCommunicationScreen(),transition: Transition.rightToLeft);
                    },
                    icon: CupertinoIcons.chat_bubble_fill,
                    title: 'Clinic\nCommunication',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            VerticalMenuCard(
              onPress: () {
                Get.to(()=> FeedbackScreen(backOn: true),transition: Transition.rightToLeft);
              },
              icon: Icons.textsms_rounded,
              title: 'Feedback',
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

