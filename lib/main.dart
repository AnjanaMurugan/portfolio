import 'dart:math' as math;
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AnjanaMuruganPortfolio());
}

class AnjanaMuruganPortfolio extends StatelessWidget {
  const AnjanaMuruganPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anjana Murugan • Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF02569B),
        scaffoldBackgroundColor: Colors.transparent,
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

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentSection = 0;
  late AnimationController _floatController;
  late AnimationController _flutterLogoController;

  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _flutterLogoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  void _onScroll() {
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero).dy;
      if (pos < 240 && pos > -240) {
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
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Flutter-themed gradient background
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, _) {
              final t = _floatController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(t * math.pi * 2 * 0.3) * 0.5,
                      math.cos(t * math.pi * 2 * 0.25) * 0.4,
                    ),
                    radius: 1.8 + math.sin(t * math.pi * 2 * 0.15) * 0.3,
                    colors: const [
                      Color(0xFF001E3C), // Deep blue
                      Color(0xFF003A6F), // Flutter blue
                      Color(0xFF00243F), // Dark blue
                      Color(0xFF0D1B2A), // Almost black
                    ],
                    stops: const [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating Flutter-colored particles
          ...List.generate(8, (i) {
            final colors = [
              const Color(0xFF02569B), // Flutter blue
              const Color(0xFF13B9FD), // Flutter light blue
              const Color(0xFF0553B1), // Flutter dark blue
              const Color(0xFF027DFD), // Sky blue
            ];
            final phase = i * 0.785; // ~45° apart
            return AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final t = _floatController.value * math.pi * 2 + phase;
                final x = math.sin(t * 0.6) * 220 + math.cos(t * 1.1) * 80;
                final y = math.cos(t * 0.75) * 280 + math.sin(t * 0.9) * 100;
                final size = 150 + math.sin(t * 2.2 + i) * 80;
                final opacity = 0.1 + 0.08 * math.sin(t * 3 + i);

                return Positioned(
                  left: MediaQuery.sizeOf(context).width * (0.1 + (i % 4) * 0.25) + x,
                  top: MediaQuery.sizeOf(context).height * (0.1 + (i ~/ 4) * 0.4) + y,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colors[i % colors.length].withOpacity(0.6),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors[i % colors.length].withOpacity(0.4),
                            blurRadius: 140,
                            spreadRadius: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Animated Flutter logo watermark
          Positioned(
            right: -100,
            top: MediaQuery.sizeOf(context).height * 0.2,
            child: AnimatedBuilder(
              animation: _flutterLogoController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _flutterLogoController.value * math.pi * 2,
                  child: Opacity(
                    opacity: 0.03,
                    child: Icon(
                      Icons.flutter_dash,
                      size: 500,
                      color: const Color(0xFF13B9FD),
                    ),
                  ),
                );
              },
            ),
          ),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Glassmorphic AppBar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: const Color(0xFF02569B).withOpacity(0.15),
                elevation: 0,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF02569B).withOpacity(0.1),
                            const Color(0xFF13B9FD).withOpacity(0.05),
                          ],
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF13B9FD).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF13B9FD).withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'AM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                actions: MediaQuery.sizeOf(context).width > 880
                    ? [
                  ...List.generate(
                    5,
                        (i) => _NavItem(
                      label: ['Home', 'Experience', 'Projects', 'Skills', 'Contact'][i],
                      active: _currentSection == i,
                      onTap: () => _scrollTo(i),
                    ),
                  ),
                  const SizedBox(width: 48),
                ]
                    : [
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                    color: const Color(0xFF0D1B2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: const Color(0xFF13B9FD).withOpacity(0.3),
                      ),
                    ),
                    onSelected: _scrollTo,
                    itemBuilder: (_) => List.generate(
                      5,
                          (i) => PopupMenuItem(
                        value: i,
                        child: Text(
                          ['Home', 'Experience', 'Projects', 'Skills', 'Contact'][i],
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),

              // Side dots navigation
              SliverPersistentHeader(
                floating: true,
                delegate: _SideDotsDelegate(
                  current: _currentSection,
                  onTap: _scrollTo,
                ),
              ),

              SliverToBoxAdapter(child: HeroSection(key: _sectionKeys[0])),
              SliverToBoxAdapter(child: ExperienceSection(key: _sectionKeys[1])),
              SliverToBoxAdapter(child: ProjectsSection(key: _sectionKeys[2])),
              SliverToBoxAdapter(child: SkillsSection(key: _sectionKeys[3])),
              SliverToBoxAdapter(child: ContactSection(key: _sectionKeys[4])),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _floatController.dispose();
    _flutterLogoController.dispose();
    super.dispose();
  }
}

// ──────────────────────────────────────────────
// Side Dots Delegate
// ──────────────────────────────────────────────

class _SideDotsDelegate extends SliverPersistentHeaderDelegate {
  final int current;
  final void Function(int) onTap;

  _SideDotsDelegate({required this.current, required this.onTap});

  @override
  double get maxExtent => 0;
  @override
  double get minExtent => 0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final active = i == current;
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                margin: const EdgeInsets.symmetric(vertical: 18),
                width: active ? 18 : 10,
                height: active ? 18 : 10,
                decoration: BoxDecoration(
                  gradient: active
                      ? const LinearGradient(
                    colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
                  )
                      : null,
                  color: active ? null : Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: active
                      ? [
                    BoxShadow(
                      color: const Color(0xFF13B9FD).withOpacity(0.8),
                      blurRadius: 28.0,
                      spreadRadius: 6.0,
                    )
                  ]
                      : null, // FIXED: Changed from [] to null to avoid negative values during animation
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SideDotsDelegate oldDelegate) => current != oldDelegate.current;
}

// ──────────────────────────────────────────────
// Modern Nav Item
// ──────────────────────────────────────────────

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextButton(
          onPressed: widget.onTap,
          style: TextButton.styleFrom(
            foregroundColor: widget.active || _hover
                ? const Color(0xFF13B9FD)
                : Colors.white70,
            backgroundColor: widget.active
                ? const Color(0xFF13B9FD).withOpacity(0.12)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Section with Flutter theme
// ──────────────────────────────────────────────

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );
    _slide = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );
    _anim.forward();
  }

  // FIXED: Single, correct implementation of resume download
  Future<void> _downloadResume() async {
    try {
      // Updated URL - check if this path exists in your repository
      final uri = Uri.parse(
          'https://github.com/AnjanaMurugan/portfolio/raw/main/assets/AnjanaMFlutterDev.pdf'
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // If direct download fails, try alternative approach
        await _showResumeOptions();
      }
    } catch (e) {
      // Fallback: Show options to user
      await _showResumeOptions();
    }
  }

  Future<void> _showResumeOptions() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Resume Download',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Please contact me via email to receive my latest resume.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openEmail();
            },
            child: const Text(
              'Send Email',
              style: TextStyle(color: Color(0xFF13B9FD), fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEmail() async {
    final uri = Uri.parse('mailto:anjana.murugan27@gmail.com?subject=Hello%20Anjana');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 640;
    final padding = isMobile ? 32.0 : 96.0;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height - 80),
          padding: EdgeInsets.fromLTRB(padding, 140, padding, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status badge with Flutter colors
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.2),
                      const Color(0xFF059669).withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.7),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Available for new opportunities',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 56),

              // Animated name with gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF13B9FD),
                    Color(0xFF02569B),
                    Color(0xFF13B9FD),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ).createShader(bounds),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: isMobile ? 52 : 88,
                    fontWeight: FontWeight.w900,
                    height: 0.98,
                    letterSpacing: -3.5,
                    color: Colors.white,
                  ),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'ANJANA MURUGAN',
                        speed: const Duration(milliseconds: 85),
                        cursor: '▊',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Role with Flutter icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF13B9FD).withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flutter_dash,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      'Senior Flutter Developer',
                      style: TextStyle(
                        fontSize: isMobile ? 30 : 48,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Experience badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF13B9FD).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF13B9FD).withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  '4+ Years • 10+ Apps • Clean Architecture Expert',
                  style: TextStyle(
                    color: Color(0xFF13B9FD),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Text(
                'Building pixel-perfect, high-performance mobile experiences\n'
                    'with Flutter, Dart, and modern state management • Provider • Bloc • Firebase',
                style: TextStyle(
                  fontSize: isMobile ? 17.5 : 21,
                  height: 1.7,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 64),

              Wrap(
                spacing: 24,
                runSpacing: 20,
                children: [
                  _FlutterButton.primary(
                    label: 'Download Resume',
                    icon: Icons.download_rounded,
                    onPressed: _downloadResume,
                  ),
                  _FlutterButton.secondary(
                    label: 'Get in Touch',
                    icon: Icons.mail_outline_rounded,
                    onPressed: _openEmail,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }
}

// Flutter-themed button
class _FlutterButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _FlutterButton.primary({
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : isPrimary = true;

  const _FlutterButton.secondary({
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : isPrimary = false;

  @override
  State<_FlutterButton> createState() => _FlutterButtonState();
}

class _FlutterButtonState extends State<_FlutterButton> with SingleTickerProviderStateMixin {
  bool _hover = false;
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        transform: Matrix4.identity()
          ..scale(_hover ? 1.06 : 1.0)
          ..rotateZ(_hover ? -0.01 : 0),
        child: Stack(
          children: [
            // Shimmer effect
            if (widget.isPrimary && _hover)
              AnimatedBuilder(
                animation: _shimmer,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment(-1.0 + _shimmer.value * 2, -0.5),
                          end: Alignment(1.0 + _shimmer.value * 2, 0.5),
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.2),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: widget.isPrimary
                        ? const LinearGradient(
                      colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    border: widget.isPrimary
                        ? null
                        : Border.all(
                      color: const Color(0xFF13B9FD),
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: widget.isPrimary
                        ? null
                        : (_hover ? const Color(0xFF13B9FD).withOpacity(0.12) : null),
                    boxShadow: _hover
                        ? [
                      BoxShadow(
                        color: const Color(0xFF13B9FD).withOpacity(0.6),
                        blurRadius: 36,
                        spreadRadius: 8,
                      )
                    ]
                        : widget.isPrimary
                        ? [
                      BoxShadow(
                        color: const Color(0xFF02569B).withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.isPrimary ? Colors.white : const Color(0xFF13B9FD),
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: widget.isPrimary ? Colors.white : const Color(0xFF13B9FD),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }
}

// ──────────────────────────────────────────────
// Experience Section
// ──────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.sizeOf(context).width < 640 ? 32.0 : 96.0;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Experience'),
          const SizedBox(height: 16),
          Text(
            'Building impactful mobile solutions',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 56),
          _ExperienceCard(
            company: 'NGXP Technologies',
            role: 'Senior Flutter Developer',
            period: 'March 2025 - Present',
            location: 'Kochi',
            current: true,
            description: 'Leading cross-platform development with Flutter & Dart. Built Smart Yacht app with offline-first architecture using Hive. Developed School Management System with real-time features.',
            tech: ['Flutter', 'Dart', 'Hive', 'Provider', 'Firebase'],
          ),
          const SizedBox(height: 32),
          _ExperienceCard(
            company: 'Cocoalabs PVT LTD',
            role: 'Flutter Developer',
            period: 'June 2022 - February 2025',
            location: 'Infopark',
            description: 'Developed NGO app with Razorpay integration and Naturopathy consultation platform. Optimized app performance and implemented RESTful APIs.',
            tech: ['Flutter', 'Firebase', 'Bloc', 'Razorpay', 'REST API'],
          ),
          const SizedBox(height: 32),
          _ExperienceCard(
            company: 'Globosoft Solutions',
            role: 'Flutter Developer',
            period: 'March 2021 - May 2022',
            location: 'Kochi',
            description: 'Transitioned from iOS to Flutter. Built Grocery Delivery App with real-time tracking and modern UI.',
            tech: ['Flutter', 'Firebase', 'Provider', 'Google Maps'],
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final String company;
  final String role;
  final String period;
  final String location;
  final String description;
  final List<String> tech;
  final bool current;

  const _ExperienceCard({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _hover ? -12.0 : 0.0, 0.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF13B9FD).withOpacity(_hover ? 0.12 : 0.06),
                const Color(0xFF02569B).withOpacity(_hover ? 0.1 : 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hover
                  ? const Color(0xFF13B9FD).withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: _hover ? 2 : 1,
            ),
            boxShadow: _hover
                ? [
              BoxShadow(
                color: const Color(0xFF13B9FD).withOpacity(0.3),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.company,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.role,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF13B9FD),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.current)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Current',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.period,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.tech
                    .map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF13B9FD).withOpacity(0.2),
                        const Color(0xFF02569B).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF13B9FD).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Color(0xFF13B9FD),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Projects, Skills, Contact sections follow similar Flutter-themed design...
// Implementing simplified versions for space

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.sizeOf(context).width < 640 ? 32.0 : 96.0;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Featured Projects'),
          const SizedBox(height: 56),
          _ProjectCard(
            title: 'Smart Yacht',
            subtitle: 'Yacht Management System',
            description: 'Comprehensive yacht management with offline-first architecture, real-time monitoring, and expense tracking.',
            tech: ['Flutter', 'Hive', 'Provider', 'Charts', 'Azure DevOps'],
            color: const Color(0xFF02569B),
          ),
          const SizedBox(height: 32),
          _ProjectCard(
            title: 'NORA School Suite',
            subtitle: 'School Management Platform',
            description: 'Three role-based apps for parents, teachers, and drivers with real-time messaging and tracking.',
            tech: ['Flutter', 'Firebase', 'Provider', 'FCM', 'Git'],
            color: const Color(0xFF13B9FD),
            hasStoreLinks: true,
          ),
          const SizedBox(height: 32),
          _ProjectCard(
            title: 'Choose My Fresh',
            subtitle: 'E-Commerce Grocery App',
            description: 'Full-featured grocery delivery with Razorpay integration and Google Maps tracking.',
            tech: ['Flutter', 'Razorpay', 'Bloc', 'Firebase', 'Google Maps'],
            color: const Color(0xFF10B981),
            hasStoreLinks: true,
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final List<String> tech;
  final Color color;
  final bool hasStoreLinks;

  const _ProjectCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tech,
    required this.color,
    this.hasStoreLinks = false,
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
        duration: const Duration(milliseconds: 400),
        transform: Matrix4.identity()..translate(0.0, _hover ? -16.0 : 0.0, 0.0),
        child: Container(
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withOpacity(_hover ? 0.15 : 0.08),
                widget.color.withOpacity(_hover ? 0.12 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _hover ? widget.color.withOpacity(0.6) : Colors.white.withOpacity(0.1),
              width: _hover ? 2.5 : 1,
            ),
            boxShadow: _hover
                ? [
              BoxShadow(
                color: widget.color.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.phone_android_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: widget.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.tech
                    .map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ))
                    .toList(),
              ),
              if (widget.hasStoreLinks) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: widget.color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Published on App Store & Play Store',
                      style: TextStyle(
                        color: widget.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.sizeOf(context).width < 640 ? 32.0 : 96.0;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Skills & Expertise'),
          const SizedBox(height: 56),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _SkillCategory(
                title: 'Core',
                icon: Icons.flutter_dash,
                skills: ['Flutter', 'Dart', 'Android', 'iOS'],
                color: const Color(0xFF02569B),
              ),
              _SkillCategory(
                title: 'State Management',
                icon: Icons.swap_horiz_rounded,
                skills: ['Provider', 'Bloc', 'GetX', 'Riverpod'],
                color: const Color(0xFF13B9FD),
              ),
              _SkillCategory(
                title: 'Backend',
                icon: Icons.cloud_rounded,
                skills: ['Firebase', 'REST API', 'GraphQL', 'WebSocket'],
                color: const Color(0xFFEC4899),
              ),
              _SkillCategory(
                title: 'Database',
                icon: Icons.storage_rounded,
                skills: ['Hive', 'SQLite', 'Firestore', 'Shared Preferences'],
                color: const Color(0xFF10B981),
              ),
              _SkillCategory(
                title: 'Payments',
                icon: Icons.payment_rounded,
                skills: ['Razorpay', 'Stripe', 'In-App Purchase'],
                color: const Color(0xFFF59E0B),
              ),
              _SkillCategory(
                title: 'Tools',
                icon: Icons.build_rounded,
                skills: ['VS Code', 'Android Studio', 'Xcode', 'Git', 'Postman'],
                color: const Color(0xFF8B5CF6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillCategory extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> skills;
  final Color color;

  const _SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
    required this.color,
  });

  @override
  State<_SkillCategory> createState() => _SkillCategoryState();
}

class _SkillCategoryState extends State<_SkillCategory> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..translate(0.0, _hover ? -10.0 : 0.0, 0.0),
        width: 280,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(_hover ? 0.2 : 0.1),
              widget.color.withOpacity(_hover ? 0.15 : 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hover ? widget.color.withOpacity(0.5) : Colors.white.withOpacity(0.1),
            width: _hover ? 2 : 1,
          ),
          boxShadow: _hover
              ? [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 28,
              spreadRadius: 4,
            ),
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.color, widget.color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...widget.skills.map((skill) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _sending = false;

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _sending = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message sent! I\'ll get back to you soon.'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _name.clear();
      _email.clear();
      _message.clear();
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.sizeOf(context).width < 640 ? 32.0 : 96.0;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Let\'s Connect'),
          const SizedBox(height: 56),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: MediaQuery.sizeOf(context).width < 900 ? 1 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContactCard(
                      icon: Icons.email_rounded,
                      title: 'Email',
                      value: 'anjana.murugan27@gmail.com',
                      onTap: () => _launch('mailto:anjana.murugan27@gmail.com'),
                    ),
                    const SizedBox(height: 20),
                    _ContactCard(
                      icon: Icons.phone_rounded,
                      title: 'Phone',
                      value: '+91 7012733764',
                      onTap: () => _launch('tel:+917012733764'),
                    ),
                    const SizedBox(height: 20),
                    _ContactCard(
                      icon: Icons.location_on_rounded,
                      title: 'Location',
                      value: 'Kochi, Kerala, India',
                    ),
                  ],
                ),
              ),
              if (MediaQuery.sizeOf(context).width >= 900) const SizedBox(width: 60),
              if (MediaQuery.sizeOf(context).width >= 900)
                Expanded(
                  flex: 3,
                  child: _buildForm(),
                ),
            ],
          ),
          if (MediaQuery.sizeOf(context).width < 900) ...[
            const SizedBox(height: 40),
            _buildForm(),
          ],
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Text(
                  '© 2025 Anjana Murugan',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Built with ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Icon(Icons.flutter_dash, color: Color(0xFF13B9FD), size: 18),
                    Text(
                      ' Flutter',
                      style: TextStyle(
                        color: Color(0xFF13B9FD),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF13B9FD).withOpacity(0.08),
            const Color(0xFF02569B).withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF13B9FD).withOpacity(0.2),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _Field(
              controller: _name,
              label: 'Name',
              hint: 'Your name',
              icon: Icons.person_outline_rounded,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            _Field(
              controller: _email,
              label: 'Email',
              hint: 'your@email.com',
              icon: Icons.email_outlined,
              validator: (v) => v!.isEmpty || !v.contains('@') ? 'Valid email required' : null,
            ),
            const SizedBox(height: 24),
            _Field(
              controller: _message,
              label: 'Message',
              hint: 'Tell me about your project...',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _sending ? null : _send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF13B9FD).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _sending
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Send Message',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF13B9FD).withOpacity(_hover && widget.onTap != null ? 0.15 : 0.08),
                const Color(0xFF02569B).withOpacity(_hover && widget.onTap != null ? 0.12 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hover && widget.onTap != null
                  ? const Color(0xFF13B9FD).withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF13B9FD).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onTap != null)
                const Icon(Icons.arrow_forward_rounded, color: Color(0xFF13B9FD), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(icon, color: const Color(0xFF13B9FD), size: 22),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF13B9FD), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF13B9FD), Color(0xFF02569B), Color(0xFF13B9FD)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -2,
        ),
      ),
    );
  }
}