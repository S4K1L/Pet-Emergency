import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petemergency/controller/auth_controller.dart';
import 'core/pet_emergency.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PetEmergency());
}