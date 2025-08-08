import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petemergency/utils/theme/colors.dart';
import '../controller/protocol_controller.dart';

class EmergencyProtocolsScreen extends StatelessWidget {
  EmergencyProtocolsScreen({super.key});
  final ProtocolController controller = Get.put(ProtocolController());

  final List<String> protocols = [
    "CPR (RECOVER)",
    "Heat stroke",
    "Seizures",
    "GDV",
    "Crash cart checklist",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
        ),
        backgroundColor: kTopBackGroundColor,
        title: Text(
          'Emergency Protocols',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Offline-accessible emergency protocols',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                return _buildProtocolCard(protocols[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(String protocolName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        title: Text(
          protocolName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: kPrimaryColor,
        ),
        onTap: () => controller.openProtocol(protocolName),
      ),
    );
  }
}