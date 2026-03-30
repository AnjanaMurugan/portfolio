// Add this import at the top of main.dart (alongside existing imports):
// import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
class _ViewResumeButton extends StatefulWidget {
  @override
  State<_ViewResumeButton> createState() => _ViewResumeButtonState();
}

class _ViewResumeButtonState extends State<_ViewResumeButton> {
  bool _hover = false;

  Future<void> _downloadResume() async {
    if (kIsWeb) {
      // On Flutter Web, use the full asset URL served by the web server
      final uri = Uri.parse('assets/resume/AnjanaMFlutterDev.pdf');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      // On mobile, load from assets and open via temp file
      try {
        final byteData = await rootBundle.load('assets/resume/AnjanaMFlutterDev.pdf');
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/AnjanaMFlutterDev.pdf');
        await file.writeAsBytes(byteData.buffer.asUint8List());
        final uri = Uri.file(file.path);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        debugPrint('Error opening resume: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _downloadResume,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View Full Rsum',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _hover
                    ? const Color(0xFF5EEAD4)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()
                ..translate(_hover ? 4.0 : 0.0, _hover ? -4.0 : 0.0, 0.0),
              child: Icon(
                Icons.arrow_outward,
                size: 16,
                color: _hover
                    ? const Color(0xFF5EEAD4)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}