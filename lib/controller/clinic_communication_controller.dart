import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ClinicCommunicationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString shiftNotes = ''.obs;
  final RxString crashCartStatus = 'Checked and complete'.obs;
  final RxBool isLoading = false.obs;

  // Controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController shiftNotesController = TextEditingController();

  String get currentUserId => _auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    _initializeClinicData();
  }

  Future<void> _initializeClinicData() async {
    try {
      isLoading.value = true;

      // Initialize or get clinic document
      final clinicDoc = await _firestore.collection('clinics').doc('main').get();
      if (!clinicDoc.exists) {
        await _setupNewClinic();
      }

      // Load data
      await _loadClinicData();
      _setupMessagesListener();

    } catch (e) {
      Get.snackbar('Error', 'Initialization failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _setupNewClinic() async {
    await _firestore.collection('clinics').doc('main').set({
      'shiftNotes': '',
      'crashCartStatus': 'Checked and complete',
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': _auth.currentUser?.uid ?? 'system',
    });
  }

  Future<void> _loadClinicData() async {
    final doc = await _firestore.collection('clinics').doc('main').get();
    if (doc.exists) {
      shiftNotes.value = doc.data()?['shiftNotes'] ?? '';
      crashCartStatus.value = doc.data()?['crashCartStatus'] ?? 'Checked and complete';
      shiftNotesController.text = shiftNotes.value;
    }
  }

  void _setupMessagesListener() {
    _firestore
        .collection('clinics')
        .doc('main')
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendMessage(bool isEmergency) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Not authenticated');
      if (messageController.text.isEmpty) return;

      await _firestore
          .collection('clinics')
          .doc('main')
          .collection('messages')
          .add({
        'text': messageController.text,
        'sender': user.displayName ?? 'Anonymous',
        'senderId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'isEmergency': isEmergency,
        'isSystem': false,
      });

      messageController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
    }
  }

  Future<void> updateShiftNotes() async {
    try {
      if (shiftNotesController.text.isEmpty) return;

      await _firestore.collection('clinics').doc('main').update({
        'shiftNotes': shiftNotesController.text,
        'notesUpdatedAt': FieldValue.serverTimestamp(),
        'notesUpdatedBy': _auth.currentUser?.uid,
      });

      // Post system message
      await sendSystemMessage('Shift notes were updated');

      shiftNotes.value = shiftNotesController.text;
      Get.back();
      Get.snackbar('Success', 'Shift notes updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update notes: ${e.toString()}');
    }
  }

  Future<void> updateCrashCart(String status) async {
    try {
      await _firestore.collection('clinics').doc('main').update({
        'crashCartStatus': status,
        'crashCartUpdatedAt': FieldValue.serverTimestamp(),
        'crashCartUpdatedBy': _auth.currentUser?.uid,
      });

      // Post system message
      await sendSystemMessage('Crash cart status changed to: $status');

      crashCartStatus.value = status;
      Get.back();
      Get.snackbar('Success', 'Crash cart updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update crash cart: ${e.toString()}');
    }
  }

  Future<void> sendSystemMessage(String text) async {
    await _firestore
        .collection('clinics')
        .doc('main')
        .collection('messages')
        .add({
      'text': text,
      'sender': 'System',
      'timestamp': FieldValue.serverTimestamp(),
      'isEmergency': false,
      'isSystem': true,
    });
  }
}