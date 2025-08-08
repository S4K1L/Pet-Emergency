import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../views/authentication/auth_gate.dart';

class PetEmergency extends StatelessWidget {
  const PetEmergency({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (_, __) =>
            GetMaterialApp(
              title: 'Pet Emergency',
              debugShowCheckedModeBanner: false,
              home: AuthGate(),
            )
    );
  }
}
