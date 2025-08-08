import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petemergency/views/education_and_quiz.dart';
import 'package:petemergency/views/feed_back.dart';
import '../../views/profile_screen.dart';
import '../../views/triage_tool_screen.dart';
import '../theme/colors.dart';
import '../../views/home.dart';

class UserCustomBottomBar extends StatefulWidget {
  const UserCustomBottomBar({super.key});

  @override
  State<UserCustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<UserCustomBottomBar> {
  int indexColor = 0;
  final List<Widget> screens = [
    HomePage(),
    TriageToolScreen(backOn: false),
    EducationAndQuizScreen(backOn: false),
    FeedbackScreen(backOn: false),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: screens[indexColor],
      bottomNavigationBar: Container(
        height: 60.sp,
        decoration: BoxDecoration(
          color: const Color(0xFF9CBAD9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationItem(Icons.home, 0),
            _buildBottomNavigationItem(Icons.menu_book, 1),
            _buildBottomNavigationItem(Icons.school, 2),
            _buildBottomNavigationItem(Icons.textsms_rounded, 3),
            _buildBottomNavigationItem(Icons.menu, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index) {
    final bool isSelected = indexColor == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          indexColor = index;
        });
      },
      child: Container(
        width: 50.sp,
        height: 50.sp,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 28.sp,
          color: const Color(0xFF3B5F8A),
        ),
      ),
    );
  }
}
