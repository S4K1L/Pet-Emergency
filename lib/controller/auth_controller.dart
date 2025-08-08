import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petemergency/utils/components/custome_bottom_bar.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  final emailController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerNameController = TextEditingController();
  final passwordController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var errorMessage = ''.obs;
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        // User is signed in
        user.value = await _getUserData(firebaseUser.uid);
      } else {
        // User is signed out
        user.value = null;
      }
    });
  }

  Future<UserModel> _getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        // Create user document if it doesn't exist
        UserModel newUser = UserModel.fromFirebaseUser(_auth.currentUser!);
        await _firestore.collection('users').doc(uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Existing methods updated with user data handling
  Future<void> login() async {
    try {
      isLoading(true);
      errorMessage('');
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      user.value = await _getUserData(credential.user!.uid);
      Get.offAll(()=> UserCustomBottomBar());
    } on FirebaseAuthException catch (e) {
      errorMessage(_getErrorMessage(e.code));
    } finally {
      isLoading(false);
    }
  }

  Future<void> register() async {
    try {
      if (registerPasswordController.value != confirmPasswordController.value) {
        throw FirebaseAuthException(
          code: 'passwords-mismatch',
          message: 'Passwords do not match',
        );
      }

      isLoading(true);
      errorMessage('');
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text.trim(),
      );

      // Create user document in Firestore
      UserModel newUser = UserModel.fromFirebaseUser(credential.user!);
      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toMap());
      user.value = newUser;
      Get.offAll(()=> UserCustomBottomBar());
    } on FirebaseAuthException catch (e) {
      errorMessage(_getErrorMessage(e.code));
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user.value = null;
  }


  Future<void> updateProfile({String? displayName, String? phoneNumber}) async {
    try {
      if (_auth.currentUser == null) return;

      // Update Firebase Auth profile
      await _auth.currentUser!.updateDisplayName(displayName);

      // Update Firestore document
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'displayName': displayName,
        'phoneNumber': phoneNumber,
      });

      // Refresh user data
      user.value = await _getUserData(_auth.currentUser!.uid);
    } catch (e) {
      errorMessage('Failed to update profile: $e');
    }
  }

  // Existing error message method
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'passwords-mismatch':
        return 'Passwords do not match';
      default:
        return 'An error occurred. Please try again';
    }
  }


}