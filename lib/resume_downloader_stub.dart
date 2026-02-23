// Stub implementation for non-web platforms (macOS, iOS, Android)
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadResume() async {
  try {
    // Load the PDF bytes from Flutter assets
    final byteData = await rootBundle.load('assets/resume/AnjanaMFlutterDev.pdf');
    final bytes = byteData.buffer.asUint8List();

    // Write to a temp file so the OS can open it
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/Anjana_Murugan_Flutter_Resume.pdf');
    await file.writeAsBytes(bytes, flush: true);

    // Open with system default PDF viewer
    final uri = Uri.file(file.path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (e) {
    debugPrint('Resume open error: $e');
  }
}