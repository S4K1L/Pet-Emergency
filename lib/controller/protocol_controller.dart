import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ProtocolController extends GetxController {
  final Map<String, String> _protocolFiles = {
    "CPR (RECOVER)": "assets/cpr.pdf",
    "Heat stroke": "assets/heat_stroke.pdf",
    "Seizures": "assets/seizures.pdf",
    "GDV": "assets/gdv.pdf",
    "Crash cart checklist": "assets/crash_cart.pdf",
  };

  Future<void> openProtocol(String protocolName) async {
    try {
      // Check if file exists in assets
      final pdfPath = _protocolFiles[protocolName];
      if (pdfPath == null) throw Exception('Protocol not found');

      // Load the PDF from assets
      final byteData = await rootBundle.load(pdfPath);

      // Create temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$protocolName.pdf');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Open the file
      await OpenFile.open(tempFile.path);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open protocol: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}