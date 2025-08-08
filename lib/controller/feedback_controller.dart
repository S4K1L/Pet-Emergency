import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxString feedbackText = ''.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool showThankYou = false.obs;
  final RxList<Map<String, dynamic>> feedbackList = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingFeedback = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    try {
      isLoadingFeedback.value = true;
      _firestore
          .collection('feedback')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        feedbackList.value = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'text': data['text'] ?? '',
            'user': data['userName'] ?? 'Anonymous',
            'timestamp': data['timestamp']?.toDate(),
          };
        }).toList();
        isLoadingFeedback.value = false;
      });
    } catch (e) {
      isLoadingFeedback.value = false;
      Get.snackbar('Error', 'Failed to load feedback: ${e.toString()}');
    }
  }

  Future<void> submitFeedback() async {
    if (feedbackText.value.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your feedback');
      return;
    }

    try {
      isSubmitting.value = true;
      final user = _auth.currentUser;

      await _firestore.collection('feedback').add({
        'text': feedbackText.value.trim(),
        'userId': user?.uid,
        'userName': user?.displayName ?? 'Anonymous',
        'timestamp': FieldValue.serverTimestamp(),
      });

      feedbackText.value = '';
      showThankYou.value = true;
      await Future.delayed(Duration(seconds: 2));
      showThankYou.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit feedback: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> openGoogleForm() async {
    const googleFormUrl = 'https://docs.google.com/forms/d/e/YOUR_FORM_ID/viewform';
    if (await canLaunch(googleFormUrl)) {
      await launch(googleFormUrl);
    } else {
      Get.snackbar('Error', 'Could not open the feedback form');
    }
  }
}