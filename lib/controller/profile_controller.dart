import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petemergency/views/authentication/login_screen.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find();

  var isLoading = true.obs;
  var isEditing = false.obs;

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  var photoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initProfile();
  }

  Future<void> _initProfile() async {
    final user = auth.currentUser;
    if (user == null) return;

    try {
      final doc = await firestore.collection('users').doc(user.uid).get();
      final data = doc.data();

      nameController = TextEditingController(text: data?['displayName'] ?? 'No name');
      phoneController = TextEditingController(text: data?['phoneNumber'] ?? 'No phone');
      emailController = TextEditingController(text: user.email ?? 'No email');
      photoUrl.value = data?['photoURL'] ?? '';

      print('Fetched user data: $data');
    } catch (e) {
      nameController = TextEditingController(text: 'No name');
      phoneController = TextEditingController(text: 'No phone');
      emailController = TextEditingController(text: user.email ?? 'No email');
      photoUrl.value = '';
      Get.snackbar(
        'Error',
        'Failed to load profile data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEdit() {
    isEditing.toggle();
  }

  Future<void> updateProfile() async {
    final user = auth.currentUser;
    if (user == null) return;

    try {
      isLoading(true);

      // Update Firebase Auth display name
      await user.updateDisplayName(nameController.text.trim());

      // Update Firestore user document
      await firestore.collection('users').doc(user.uid).update({
        'displayName': nameController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'photoURL': photoUrl.value,
      });

      isEditing(false);
      Get.snackbar(
        'Success',
        'Profile updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: Get.back, child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              await authController.signOut();
              Get.offAll(() => LoginScreen());
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
