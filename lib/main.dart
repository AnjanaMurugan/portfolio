import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AnjanaMuruganPortfolio());
}

class AnjanaMuruganPortfolio extends StatelessWidget {
  const AnjanaMuruganPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anjana Murugan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  int _currentSection = 0;
  Offset _mousePosition = Offset.zero;

  final List<GlobalKey> _sectionKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero).dy;
      if (pos < 300 && pos > -300) {
        if (_currentSection != i) {
          setState(() => _currentSection = i);
        }
        break;
      }
    }
  }

  void _scrollTo(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero).dy;
    _scrollController.animateTo(
      _scrollController.offset + pos - 100,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1024;

    return Scaffold(
      body: MouseRegion(
        onHover: (event) => setState(() => _mousePosition = event.position),
        child: Stack(
          children: [
            // Base background
            Container(color: const Color(0xFF0F172A)),

            // Mouse spotlight effect
            if (isDesktop)
              CustomPaint(
                painter: _SpotlightPainter(_mousePosition),
                size: Size.infinite,
              ),

            // Content
            isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar - Fixed
        SizedBox(
          width: 600,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 120,
              right: 60,
              top: 120,
              bottom: 120,
            ),
            child: _LeftSidebar(
              currentSection: _currentSection,
              onSectionTap: _scrollTo,
            ),
          ),
        ),

        // Right content - Scrollable
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 120,
                right: 120,
                bottom: 120,
                left: 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutSection(key: _sectionKeys[0]),
                  const SizedBox(height: 160),
                  _ExperienceSection(key: _sectionKeys[1]),
                  const SizedBox(height: 160),
                  _ProjectsSection(key: _sectionKeys[2]),
                  const SizedBox(height: 160),
                  _ContactSection(key: _sectionKeys[3]),
                  const SizedBox(height: 100),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MobileHeader(),
            const SizedBox(height: 80),
            _AboutSection(key: _sectionKeys[0]),
            const SizedBox(height: 120),
            _ExperienceSection(key: _sectionKeys[1]),
            const SizedBox(height: 120),
            _ProjectsSection(key: _sectionKeys[2]),
            const SizedBox(height: 120),
            _ContactSection(key: _sectionKeys[3]),
            const SizedBox(height: 60),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Built with Flutter',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.4),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          ' 2025 Anjana Murugan',
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// 
// RESUME HELPER  view & download
// 

Future<void> openResume(BuildContext context) async {
  const assetPath = 'assets/resume/AnjanaMFlutterDev.pdf';

  if (kIsWeb) {
    // Flutter Web: asset is served at this relative URL by the dev/build server
    final uri = Uri.parse(assetPath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showResumeError(context);
    }
  } else {
    // Mobile / Desktop: copy asset to temp dir then open with system viewer
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/AnjanaMFlutterDev.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      final uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showResumeError(context);
      }
    } catch (e) {
      debugPrint('Resume open error: $e');
      _showResumeError(context);
    }
  }
}

Future<void> downloadResume(BuildContext context) async {
  const assetPath = 'assets/resume/AnjanaMFlutterDev.pdf';

  if (kIsWeb) {
    // On web, trigger browser download via an anchor with the download attribute
    // using url_launcher to open the asset URL  browser will prompt save-as
    // because we append ?download=1 which forces a new navigation.
    // The simplest cross-browser approach: open in new tab; user presses Ctrl+S.
    final uri = Uri.parse(assetPath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showResumeError(context);
    }
  } else {
    // Mobile / Desktop: save to Downloads folder
    try {
      final byteData = await rootBundle.load(assetPath);

      Directory? saveDir;
      if (Platform.isAndroid) {
        // Use the public Downloads directory on Android
        saveDir = Directory('/storage/emulated/0/Download');
        if (!await saveDir.exists()) {
          saveDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        // iOS: save to Documents (accessible via Files app)
        saveDir = await getApplicationDocumentsDirectory();
      } else {
        // Desktop: save to system Downloads
        saveDir = await getDownloadsDirectory();
      }

      saveDir ??= await getTemporaryDirectory();

      final file = File('${saveDir.path}/AnjanaMFlutterDev.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resume saved to ${file.path}'),
            backgroundColor: const Color(0xFF1E293B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Also open it so user sees the file immediately
      final uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Resume download error: $e');
      _showResumeError(context);
    }
  }
}

void _showResumeError(BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Could not open resume. Please try again.'),
      backgroundColor: Color(0xFF1E293B),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// 

// Spotlight painter for mouse effect
class _SpotlightPainter extends CustomPainter {
  final Offset position;

  _SpotlightPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF5EEAD4).withOpacity(0.15),
          const Color(0xFF5EEAD4).withOpacity(0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: 600));

    canvas.drawCircle(position, 600, paint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      position != oldDelegate.position;
}

// Left Sidebar
class _LeftSidebar extends StatelessWidget {
  final int currentSection;
  final void Function(int) onSectionTap;

  const _LeftSidebar({
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        const Text(
          'Anjana Murugan',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE2E8F0),
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),

        // Title
        const Text(
          'Senior Flutter Developer',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE2E8F0),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),

        // Tagline
        Text(
          'I build pixel-perfect, high-performance\nmobile experiences for Android and iOS.',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF94A3B8),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 60),

        // Navigation
        ...[
          ('ABOUT', 0),
          ('EXPERIENCE', 1),
          ('PROJECTS', 2),
          ('CONTACT', 3),
        ].map(
              (item) => _NavItem(
            label: item.$1,
            active: currentSection == item.$2,
            onTap: () => onSectionTap(item.$2),
          ),
        ),

        const Spacer(),

        // Social Links
        Row(
          children: [
            _SocialIcon(
              icon: Icons.link,
              url: 'https://github.com/AnjanaMurugan',
              label: 'GitHub',
            ),
            const SizedBox(width: 20),
            _SocialIcon(
              icon: Icons.business_center,
              url: 'https://www.linkedin.com/in/anjana-murugan-7a15841a1/',
              label: 'LinkedIn',
            ),
            const SizedBox(width: 20),
            _SocialIcon(
              icon: Icons.email,
              url: '  mailto:anjana.murugan27@gmail.com',
              label: 'Email',
            ),
          ],
        ),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.active || _hover ? 64 : 32,
                height: 1,
                color: widget.active || _hover
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF475569),
              ),
              const SizedBox(width: 16),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: widget.active || _hover
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String label;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.label,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -4.0 : 0.0, 0.0),
          child: Icon(
            widget.icon,
            color: _hover ? const Color(0xFF5EEAD4) : const Color(0xFF94A3B8),
            size: 24,
          ),
        ),
      ),
    );
  }
}

// Mobile Header
class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Anjana Murugan',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE2E8F0),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Senior Flutter Developer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE2E8F0),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'I build pixel-perfect, high-performance mobile experiences for Android and iOS.',
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xFF94A3B8),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// About Section
class _AboutSection extends StatelessWidget {
  const _AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('ABOUT'),
        const SizedBox(height: 24),
        Text(
          'I\'m a senior Flutter developer with 4+ years of experience building cross-platform mobile applications. I specialize in creating pixel-perfect, high-performance apps with clean architecture and modern state management patterns.\n\n'
              'Currently, I work at NGXP Technologies, where I lead the development of complex mobile applications including Smart Yacht (a comprehensive yacht management system) and NORA School Suite (a multi-app school management platform).\n\n'
              'My expertise spans offline-first architecture with Hive, real-time features with Firebase, payment integration with Razorpay, and seamless API integrations. I\'m passionate about writing clean, maintainable code and creating delightful user experiences.\n\n'
              'Outside of work, you can find me exploring new Flutter packages, contributing to open-source projects, and staying up-to-date with the latest mobile development trends.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

// Experience Section
class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('EXPERIENCE'),
        const SizedBox(height: 24),
        _ExperienceCard(
          period: '2025  Present',
          title: 'Senior Flutter Developer',
          company: 'NGXP Technologies',
          description:
          'Lead cross-platform development with Flutter & Dart. Built Smart Yacht app with offline-first architecture using Hive. Developed School Management System with real-time features and multi-role access.',
          tech: [
            'Flutter',
            'Dart',
            'Hive',
            'Provider',
            'Firebase',
            'Azure DevOps',
          ],
          current: true,
        ),
        const SizedBox(height: 16),
        _ExperienceCard(
          period: '2022  2025',
          title: 'Flutter Developer',
          company: 'Cocoalabs PVT LTD',
          description:
          'Developed NGO app with Razorpay integration and Naturopathy consultation platform. Optimized app performance and implemented RESTful APIs with clean architecture patterns.',
          tech: ['Flutter', 'Firebase', 'Bloc', 'Razorpay', 'REST API'],
        ),
        const SizedBox(height: 16),
        _ExperienceCard(
          period: '2021  2022',
          title: 'Flutter Developer',
          company: 'Globosoft Solutions',
          description:
          'Transitioned from iOS to Flutter development. Built Grocery Delivery App with real-time tracking, modern UI, and seamless user experience.',
          tech: ['Flutter', 'Firebase', 'Provider', 'Google Maps API'],
        ),
        const SizedBox(height: 40),
        _ViewResumeButton(),
      ],
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final String period;
  final String title;
  final String company;
  final String description;
  final List<String> tech;
  final bool current;

  const _ExperienceCard({
    required this.period,
    required this.title,
    required this.company,
    required this.description,
    required this.tech,
    this.current = false,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hover
              ? const Color(0xFF1E293B).withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period
            SizedBox(
              width: 120,
              child: Text(
                widget.period,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(width: 24),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.title}  ${widget.company}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _hover
                                ? const Color(0xFF5EEAD4)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      if (widget.current)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5EEAD4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF5EEAD4).withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'Current',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5EEAD4),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.tech
                        .map((t) => _TechChip(label: t))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF5EEAD4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5EEAD4),
        ),
      ),
    );
  }
}

// 
// VIEW RSUM BUTTON  with View + Download actions
// 

class _ViewResumeButton extends StatefulWidget {
  @override
  State<_ViewResumeButton> createState() => _ViewResumeButtonState();
}

class _ViewResumeButtonState extends State<_ViewResumeButton> {
  bool _hoverView = false;
  bool _hoverDownload = false;
  bool _loading = false;

  static const _assetPath = 'assets/resume/AnjanaMFlutterDev.pdf';

  // Opens the PDF in a new browser tab (web) or system PDF viewer (mobile)
  Future<void> _view() async {
    setState(() => _loading = true);
    try {
      if (kIsWeb) {
        final uri = Uri.parse(_assetPath);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        final file = await _extractToTemp();
        final uri = Uri.file(file.path);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Resume view error: $e');
      _showSnack('Could not open resume.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Saves PDF to Downloads folder (mobile/desktop) or opens in new tab (web)
  Future<void> _download() async {
    setState(() => _loading = true);
    try {
      if (kIsWeb) {
        // Web: open asset URL  browser shows native save/download dialog
        final uri = Uri.parse(_assetPath);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        final byteData = await rootBundle.load(_assetPath);
        final saveDir = await _resolveDownloadDir();
        final file = File('${saveDir.path}/AnjanaMFlutterDev.pdf');
        await file.writeAsBytes(byteData.buffer.asUint8List());
        _showSnack('Saved to ${file.path}');

        // Open the saved file immediately
        final uri = Uri.file(file.path);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Resume download error: $e');
      _showSnack('Download failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<File> _extractToTemp() async {
    final byteData = await rootBundle.load(_assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/AnjanaMFlutterDev.pdf');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<Directory> _resolveDownloadDir() async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) dir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      // iOS: Documents folder is accessible via the Files app
      dir = await getApplicationDocumentsDirectory();
    } else if (Platform.isMacOS) {
      // macOS sandbox: try Downloads (requires entitlement), fall back to Documents
      try {
        final downloads = await getDownloadsDirectory();
        if (downloads != null) {
          // Test write permission before committing
          final testFile = File('${downloads.path}/.flutter_write_test');
          await testFile.writeAsString('test');
          await testFile.delete();
          dir = downloads;
        }
      } catch (_) {
        // Entitlement not granted  fall back to sandbox-safe Documents dir
        dir = await getApplicationDocumentsDirectory();
        _showSnack('Saved to Documents (Finder  Go  Documents)');
      }
    } else {
      // Windows / Linux
      dir = await getDownloadsDirectory();
    }
    return dir ?? await getTemporaryDirectory();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //  View button 
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hoverView = true),
          onExit: (_) => setState(() => _hoverView = false),
          child: GestureDetector(
            onTap: _loading ? null : _view,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                    color: _hoverView
                        ? const Color(0xFF5EEAD4)
                        : const Color(0xFFE2E8F0),
                  ),
                  child: const Text('View Full Rsum'),
                ),
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()
                    ..translate(
                      _hoverView ? 4.0 : 0.0,
                      _hoverView ? -4.0 : 0.0,
                      0.0,
                    ),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 16,
                    color: _hoverView
                        ? const Color(0xFF5EEAD4)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 24),

        //  Download button 
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hoverDownload = true),
          onExit: (_) => setState(() => _hoverDownload = false),
          child: GestureDetector(
            onTap: _loading ? null : _download,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _hoverDownload
                    ? const Color(0xFF5EEAD4).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _hoverDownload
                      ? const Color(0xFF5EEAD4)
                      : const Color(0xFF475569),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _loading
                      ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF5EEAD4),
                    ),
                  )
                      : Icon(
                    Icons.download_rounded,
                    size: 16,
                    color: _hoverDownload
                        ? const Color(0xFF5EEAD4)
                        : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lexend',
                      color: _hoverDownload
                          ? const Color(0xFF5EEAD4)
                          : const Color(0xFF94A3B8),
                    ),
                    child: const Text('Download'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 

// Projects Section
class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('PROJECTS'),
        const SizedBox(height: 24),
        _ProjectCard(
          title: 'Smart Yacht',
          description:
          'Comprehensive yacht management system with offline-first architecture, real-time monitoring, expense tracking, and detailed analytics.',
          tech: ['Flutter', 'Hive', 'Provider', 'Charts', 'Azure DevOps'],
        ),
        const SizedBox(height: 16),
        _ProjectCard(
          title: 'NORA School Suite',
          description:
          'Three role-based mobile apps for parents, teachers, and drivers with real-time messaging, attendance tracking, and live location features.',
          tech: ['Flutter', 'Firebase', 'FCM', 'Provider', 'Google Maps'],
          published: true,
        ),
        const SizedBox(height: 16),
        _ProjectCard(
          title: 'Choose My Fresh',
          description:
          'Full-featured grocery delivery app with Razorpay payment integration, Google Maps tracking, and real-time order updates.',
          tech: ['Flutter', 'Bloc', 'Razorpay', 'Firebase', 'Google Maps'],
          published: true,
        ),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;
  final bool published;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.tech,
    this.published = false,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hover
              ? const Color(0xFF1E293B).withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _hover
                          ? const Color(0xFF5EEAD4)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                if (widget.published)
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF5EEAD4),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tech.map((t) => _TechChip(label: t)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Contact Section
class _ContactSection extends StatelessWidget {
  const _ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('CONTACT'),
        const SizedBox(height: 24),
        Text(
          'I\'m currently looking for new opportunities and my inbox is always open. Whether you have a question or just want to say hi, I\'ll try my best to get back to you!',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 32),
        _ContactLink(
          icon: Icons.email,
          label: 'anjana.murugan27@gmail.com',
          url: 'mailto:anjana.murugan27@gmail.com',
        ),
        const SizedBox(height: 16),
        _ContactLink(
          icon: Icons.phone,
          label: '+91 7012733764',
          url: 'tel:+917012733764',
        ),
        const SizedBox(height: 16),
        const _ContactLink(
          icon: Icons.location_on,
          label: 'Kochi, Kerala, India',
        ),
      ],
    );
  }
}

class _ContactLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? url;

  const _ContactLink({required this.icon, required this.label, this.url});

  @override
  State<_ContactLink> createState() => _ContactLinkState();
}

class _ContactLinkState extends State<_ContactLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.url != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isClickable
            ? () async {
          final uri = Uri.parse(widget.url!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
            : null,
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 20,
              color: _hover && isClickable
                  ? const Color(0xFF5EEAD4)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                color: _hover && isClickable
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

// Section Title
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: Color(0xFFE2E8F0),
      ),
    );
  }
}