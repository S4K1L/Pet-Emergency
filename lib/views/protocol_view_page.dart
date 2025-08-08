// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class ProtocolViewerPage extends StatefulWidget {
//   final String title;
//   final String fileName;
//
//   const ProtocolViewerPage({super.key, required this.title, required this.fileName});
//
//   @override
//   State<ProtocolViewerPage> createState() => _ProtocolViewerPageState();
// }
//
// class _ProtocolViewerPageState extends State<ProtocolViewerPage> {
//   String? localPath;
//   bool isPDF = false;
//   late final WebViewController _webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted);
//
//     _loadProtocol();
//   }
//
//   Future<void> _loadProtocol() async {
//     final isHtml = widget.fileName.endsWith('.html');
//     final filePath = 'assets/protocols/${widget.fileName}';
//
//     if (isHtml) {
//       // Load from Flutter asset
//       _webViewController.loadFlutterAsset(filePath);
//     } else {
//       // For PDF
//       try {
//         final byteData = await rootBundle.load(filePath);
//         final tempDir = await getTemporaryDirectory();
//         final file = File('${tempDir.path}/${widget.fileName}');
//         await file.writeAsBytes(byteData.buffer.asUint8List());
//         setState(() {
//           localPath = file.path;
//           isPDF = true;
//         });
//       } catch (e) {
//         print("Error loading PDF: $e");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: const Color(0xFFBFD9EC),
//       ),
//       body: isPDF
//           ? (localPath == null
//           ? const Center(child: CircularProgressIndicator())
//           : PDFView(filePath: localPath!))
//           : WebViewWidget(controller: _webViewController),
//     );
//   }
// }
