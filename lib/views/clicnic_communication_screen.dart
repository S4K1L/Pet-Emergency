import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petemergency/utils/theme/colors.dart';
import '../controller/clinic_communication_controller.dart';

class ClinicCommunicationScreen extends StatelessWidget {
  final ClinicCommunicationController controller = Get.put(ClinicCommunicationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kTopBackGroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Clinic Communication',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildStatusHeader(),
            _buildShiftNotesSection(),
            Expanded(child: _buildMessagesList()),
            _buildMessageInput(),
          ],
        );
      }),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusButton(
            icon: Icons.note,
            label: 'Shift Notes',
            onTap: _showShiftNotesDialog,
          ),
          _buildCrashCartStatus(),
          _buildStatusButton(
            icon: Icons.warning,
            label: 'Emergency',
            onTap: _showEmergencyDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24.sp, color: kPrimaryColor),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCrashCartStatus() {
    return Obx(() {
      final status = controller.crashCartStatus.value;
      Color statusColor;

      switch (status) {
        case 'Needs restocking':
          statusColor = Colors.orange;
          break;
        case 'In use':
          statusColor = Colors.red;
          break;
        default:
          statusColor = Colors.green;
      }

      return InkWell(
        onTap: _showCrashCartDialog,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medical_services, size: 24.sp, color: statusColor),
            SizedBox(height: 4.h),
            Text(
              'Crash Cart',
              style: TextStyle(fontSize: 12.sp),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 10.sp,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildShiftNotesSection() {
    return Obx(() => Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(vertical: 4.h),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, size: 16.sp, color: Colors.blue),
              SizedBox(width: 8.w),
              Text(
                'SHIFT NOTES',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit, size: 16.sp),
                onPressed: _showShiftNotesDialog,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            controller.shiftNotes.value.isNotEmpty
                ? controller.shiftNotes.value
                : 'No shift notes entered yet',
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    ));
  }

  Widget _buildMessagesList() {
    return Obx(() => ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        return _buildMessageItem(message);
      },
    ));
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final isSystem = message['isSystem'] == true;
    final isEmergency = message['isEmergency'] == true;
    final isCurrentUser = message['senderId'] == controller.currentUserId;

    if (isSystem) {
      return _buildSystemMessage(message);
    }

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        decoration: BoxDecoration(
          color: isEmergency
              ? Colors.red.shade50
              : (isCurrentUser ? kPrimaryColor.withOpacity(0.1) : Colors.white),
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: isEmergency ? Colors.red.shade200 : Colors.grey.shade200,
          ),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEmergency) _buildEmergencyHeader(),
            Text(message['text'], style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 4.h),
            Text(
              '${message['sender']} • ${_formatTimestamp(message['timestamp'])}',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMessage(Map<String, dynamic> message) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Text(
          message['text'],
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyHeader() {
    return Row(
      children: [
        Icon(Icons.warning, size: 16.sp, color: Colors.red),
        SizedBox(width: 4.w),
        Text(
          'EMERGENCY',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.w),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () => controller.sendMessage(false),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return DateFormat('h:mm a').format(timestamp.toDate());
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  void _showShiftNotesDialog() {
    controller.shiftNotesController.text = controller.shiftNotes.value;
    Get.dialog(
      AlertDialog(
        title: Text('Edit Shift Notes'),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller.shiftNotesController,
            maxLines: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter shift notes...',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            onPressed: controller.updateShiftNotes,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCrashCartDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Update Crash Cart Status'),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusRadio(
              value: 'Complete',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            _buildStatusRadio(
              value: 'Needs restocking',
              icon: Icons.warning,
              color: Colors.orange,
            ),
            _buildStatusRadio(
              value: 'In use',
              icon: Icons.error,
              color: Colors.red,
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildStatusRadio({
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return RadioListTile(
      value: value,
      groupValue: controller.crashCartStatus.value,
      onChanged: (value) => controller.updateCrashCart(value.toString()),
      title: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8.w),
          Text(value),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Send Emergency Alert', style: TextStyle(color: Colors.red)),
        content: TextField(
          controller: controller.messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Describe the emergency...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.sendMessage(true);
              Get.back();
            },
            child: Text('Send Alert'),
          ),
        ],
      ),
    );
  }
}