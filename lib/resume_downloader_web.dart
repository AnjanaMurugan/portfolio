// Web implementation using dart:html
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void downloadResume() {
  final anchor = html.AnchorElement(
    href: 'assets/resume/AnjanaMFlutterDev.pdf',
  )
    ..setAttribute('download', 'Anjana_Murugan_Flutter_Resume.pdf')
    ..style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}