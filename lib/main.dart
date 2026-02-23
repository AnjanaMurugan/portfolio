import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'resume_downloader_stub.dart'
if (dart.library.html) 'resume_downloader_web.dart';

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
        scaffoldBackgroundColor: const Color(0xFF060A0F),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────

const _kAccent = Color(0xFFB8FF57); // lime-green electric
const _kBg = Color(0xFF060A0F);
const _kSurface = Color(0xFF0D1520);
const _kBorder = Color(0xFF1A2535);
const _kTextPrimary = Color(0xFFEDF2FF);
const _kTextSecondary = Color(0xFF6B7D93);

const String _aboutText =
    'Senior Flutter developer with 4+ years crafting cross-platform '
    'mobile applications that feel native on every device. I obsess over '
    'performance, architecture, and the fine details that separate good apps '
    'from great ones.\n\n'
    'Currently at NGXP Technologies, leading development of Smart Yacht — a '
    'complex offline-first system — and NORA School Suite, a multi-role '
    'platform serving parents, teachers, and drivers.\n\n'
    'My stack: Flutter · Dart · Hive · Firebase · Bloc/Provider · REST APIs. '
    'I write clean code, obsess over pixel-perfect UIs, and ship on time.';

final List<_ExpData> _experiences = [
  _ExpData(
    period: '2025 — Present',
    role: 'Senior Flutter Developer',
    company: 'NGXP Technologies',
    description:
    'Lead cross-platform development for enterprise clients. Built '
        'Smart Yacht with offline-first Hive architecture and NORA School '
        'Suite with real-time Firebase features and multi-role access control.',
    tech: ['Flutter', 'Dart', 'Hive', 'Provider', 'Firebase', 'Azure DevOps'],
    current: true,
  ),
  _ExpData(
    period: '2022 — 2025',
    role: 'Flutter Developer',
    company: 'Cocoalabs PVT LTD',
    description:
    'Developed NGO crowdfunding app with Razorpay integration and a '
        'Naturopathy consultation platform. Implemented clean architecture '
        'with Bloc and optimized app startup time by 40%.',
    tech: ['Flutter', 'Firebase', 'Bloc', 'Razorpay', 'REST API'],
  ),
  _ExpData(
    period: '2021 — 2022',
    role: 'Flutter Developer',
    company: 'Globosoft Solutions',
    description:
    'Transitioned from iOS to Flutter, delivering a Grocery Delivery '
        'App with real-time order tracking via Google Maps and push '
        'notifications.',
    tech: ['Flutter', 'Firebase', 'Provider', 'Google Maps API'],
  ),
];

final List<_ProjectData> _projects = [
  _ProjectData(
    index: '01',
    title: 'Smart Yacht',
    description:
    'Comprehensive yacht management system with offline-first '
        'architecture, real-time monitoring, expense tracking, and '
        'detailed analytics dashboards.',
    tech: ['Flutter', 'Hive', 'Provider', 'Charts', 'Azure DevOps'],
    published: false,
  ),
  _ProjectData(
    index: '02',
    title: 'NORA School Suite',
    description:
    'Three role-based mobile apps for parents, teachers, and drivers '
        'with real-time messaging, attendance tracking, and live location '
        'features.',
    tech: ['Flutter', 'Firebase', 'FCM', 'Provider', 'Google Maps'],
    published: true,
  ),
  _ProjectData(
    index: '03',
    title: 'Choose My Fresh',
    description:
    'Full-featured grocery delivery app with Razorpay payment gateway, '
        'Google Maps live tracking, and real-time order status updates.',
    tech: ['Flutter', 'Bloc', 'Razorpay', 'Firebase', 'Google Maps'],
    published: true,
  ),
];

class _ExpData {
  final String period, role, company, description;
  final List<String> tech;
  final bool current;
  const _ExpData({
    required this.period,
    required this.role,
    required this.company,
    required this.description,
    required this.tech,
    this.current = false,
  });
}

class _ProjectData {
  final String index, title, description;
  final List<String> tech;
  final bool published;
  const _ProjectData({
    required this.index,
    required this.title,
    required this.description,
    required this.tech,
    required this.published,
  });
}

// ─────────────────────────────────────────────────────────
// HOME PAGE
// ─────────────────────────────────────────────────────────

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  final _scrollCtrl = ScrollController();
  final List<GlobalKey> _keys = List.generate(4, (_) => GlobalKey());
  int _activeSection = 0;
  Offset _mouse = Offset.zero;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  void _onScroll() {
    for (int i = 0; i < _keys.length; i++) {
      final ctx = _keys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final y = box.localToGlobal(Offset.zero).dy;
      if (y < 350 && y > -200) {
        if (_activeSection != i) setState(() => _activeSection = i);
        break;
      }
    }
  }

  void _scrollTo(int i) {
    final ctx = _keys[i].currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final y = box.localToGlobal(Offset.zero).dy;
    _scrollCtrl.animateTo(
      _scrollCtrl.offset + y - 120,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= 1024;

    return Scaffold(
      backgroundColor: _kBg,
      body: MouseRegion(
        onHover: (e) => setState(() => _mouse = e.position),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Stack(
            children: [
              // Noise grain overlay (CSS-like)
              Positioned.fill(child: _GrainOverlay()),
              // Glow spotlight
              if (isDesktop)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GlowPainter(_mouse),
                  ),
                ),
              // Decorative grid lines
              Positioned.fill(child: CustomPaint(painter: _GridPainter())),
              // Main content
              isDesktop ? _desktopLayout() : _mobileLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopLayout() {
    return Row(
      children: [
        // Fixed sidebar
        SizedBox(
          width: 520,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 96, top: 96, bottom: 96, right: 48),
            child: _Sidebar(
              active: _activeSection,
              onNav: _scrollTo,
            ),
          ),
        ),
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            child: Padding(
              padding:
              const EdgeInsets.only(top: 96, right: 96, bottom: 120, left: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionAbout(key: _keys[0]),
                  _divider(),
                  _SectionExperience(key: _keys[1]),
                  _divider(),
                  _SectionProjects(key: _keys[2]),
                  _divider(),
                  _SectionContact(key: _keys[3]),
                  const SizedBox(height: 80),
                  _footer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileLayout() {
    return SingleChildScrollView(
      controller: _scrollCtrl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MobileHero(),
            const SizedBox(height: 80),
            _SectionAbout(key: _keys[0]),
            _divider(),
            _SectionExperience(key: _keys[1]),
            _divider(),
            _SectionProjects(key: _keys[2]),
            _divider(),
            _SectionContact(key: _keys[3]),
            const SizedBox(height: 60),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Container(height: 1, color: _kBorder),
    );
  }

  Widget _footer() => Text(
    'Designed & built with Flutter · © 2025 Anjana Murugan',
    style: TextStyle(
      fontSize: 12,
      color: _kTextSecondary.withOpacity(0.5),
      letterSpacing: 0.5,
    ),
  );

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────
// PAINTERS
// ─────────────────────────────────────────────────────────

class _GlowPainter extends CustomPainter {
  final Offset pos;
  _GlowPainter(this.pos);

  @override
  void paint(Canvas c, Size s) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          _kAccent.withOpacity(0.06),
          _kAccent.withOpacity(0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(Rect.fromCircle(center: pos, radius: 700));
    c.drawCircle(pos, 700, paint);
  }

  @override
  bool shouldRepaint(_GlowPainter old) => old.pos != pos;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final paint = Paint()
      ..color = const Color(0xFF1A2535).withOpacity(0.4)
      ..strokeWidth = 0.5;
    const step = 80.0;
    for (double x = 0; x < s.width; x += step) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), paint);
    }
    for (double y = 0; y < s.height; y += step) {
      c.drawLine(Offset(0, y), Offset(s.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

class _GrainOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _GrainPainter()),
    );
  }
}

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final rng = math.Random(42);
    final paint = Paint()..color = Colors.white.withOpacity(0.025);
    for (int i = 0; i < 6000; i++) {
      c.drawCircle(
        Offset(rng.nextDouble() * s.width, rng.nextDouble() * s.height),
        rng.nextDouble() * 0.8,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GrainPainter _) => false;
}

// ─────────────────────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final int active;
  final void Function(int) onNav;
  const _Sidebar({required this.active, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status chip
        _StatusChip(),
        const SizedBox(height: 32),

        // Name
        const Text(
          'Anjana\nMurugan',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 52,
            fontWeight: FontWeight.w800,
            color: _kTextPrimary,
            height: 1.05,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 20),

        // Role with accent
        Row(
          children: [
            Container(width: 3, height: 20, color: _kAccent),
            const SizedBox(width: 12),
            const Text(
              'Senior Flutter Developer',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _kAccent,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Text(
          'Pixel-perfect mobile experiences\nfor Android & iOS.',
          style: TextStyle(
            fontSize: 15,
            color: _kTextSecondary,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 56),

        // Nav
        ...[
          ('About', 0),
          ('Experience', 1),
          ('Projects', 2),
          ('Contact', 3),
        ].map((e) => _NavRow(
          label: e.$1,
          index: e.$2,
          active: active == e.$2,
          onTap: () => onNav(e.$2),
        )),

        const Spacer(),

        // Socials
        _SocialRow(),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _kAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _kAccent.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: _kAccent,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _kAccent.withOpacity(0.6), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Open to opportunities',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _kAccent,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatefulWidget {
  final String label;
  final int index;
  final bool active;
  final VoidCallback onTap;

  const _NavRow({
    required this.label,
    required this.index,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.active || _hover;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: highlight ? 48 : 24,
                height: 1.5,
                color: highlight ? _kAccent : _kBorder,
              ),
              const SizedBox(width: 14),
              Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: highlight ? _kTextPrimary : _kTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialBtn(
          label: 'GH',
          url: 'https://github.com/AnjanaMurugan',
        ),
        const SizedBox(width: 12),
        _SocialBtn(
          label: 'LI',
          url: 'https://linkedin.com/in/anjana-murugan',
        ),
        const SizedBox(width: 12),
        _SocialBtn(
          label: 'ML',
          url: 'mailto:anjana.murugan27@gmail.com',
        ),
      ],
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final String label, url;
  const _SocialBtn({required this.label, required this.url});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hover ? _kAccent.withOpacity(0.1) : _kSurface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _hover ? _kAccent.withOpacity(0.5) : _kBorder,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: _hover ? _kAccent : _kTextSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MOBILE HERO
// ─────────────────────────────────────────────────────────

class _MobileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusChip(),
        const SizedBox(height: 24),
        const Text(
          'Anjana Murugan',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: _kTextPrimary,
            height: 1.1,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(width: 3, height: 18, color: _kAccent),
            const SizedBox(width: 10),
            const Text(
              'Senior Flutter Developer',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _kAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Pixel-perfect mobile experiences for Android & iOS.',
          style: TextStyle(fontSize: 15, color: _kTextSecondary, height: 1.6),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 24, height: 1, color: _kAccent),
        const SizedBox(width: 12),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
            color: _kAccent,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// ABOUT
// ─────────────────────────────────────────────────────────

class _SectionAbout extends StatelessWidget {
  const _SectionAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SLabel('About'),
        const SizedBox(height: 28),
        Text(
          _aboutText,
          style: TextStyle(
            fontSize: 16,
            height: 1.8,
            color: _kTextSecondary,
          ),
        ),
        const SizedBox(height: 40),
        // Skills grid
        _SkillsGrid(),
      ],
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  final List<String> skills = const [
    'Flutter', 'Dart', 'Firebase', 'Hive',
    'Bloc', 'Provider', 'REST API', 'Google Maps',
    'Razorpay', 'FCM', 'Azure DevOps', 'Git',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((s) => _SkillTag(s)).toList(),
    );
  }
}

class _SkillTag extends StatefulWidget {
  final String label;
  const _SkillTag(this.label);

  @override
  State<_SkillTag> createState() => _SkillTagState();
}

class _SkillTagState extends State<_SkillTag> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _hover ? _kAccent.withOpacity(0.12) : _kSurface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _hover ? _kAccent.withOpacity(0.6) : _kBorder,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _hover ? _kAccent : _kTextSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// EXPERIENCE
// ─────────────────────────────────────────────────────────

class _SectionExperience extends StatelessWidget {
  const _SectionExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SLabel('Experience'),
        const SizedBox(height: 32),
        ..._experiences.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ExpCard(data: e),
        )),
        const SizedBox(height: 32),
        _ResumeBtn(),
      ],
    );
  }
}

class _ExpCard extends StatefulWidget {
  final _ExpData data;
  const _ExpCard({required this.data});

  @override
  State<_ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<_ExpCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hover ? _kSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hover ? _kBorder : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                d.period,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _kTextSecondary,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${d.role} · ${d.company}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _hover ? _kAccent : _kTextPrimary,
                          ),
                        ),
                      ),
                      if (d.current)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _kAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                                color: _kAccent.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'NOW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _kAccent,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    d.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.65,
                      color: _kTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: d.tech
                        .map((t) => _MiniChip(t))
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

class _MiniChip extends StatelessWidget {
  final String label;
  const _MiniChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _kAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _kAccent,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Resume download helper ──────────────────────────────
void _downloadResume() => downloadResume();

class _ResumeBtn extends StatefulWidget {
  @override
  State<_ResumeBtn> createState() => _ResumeBtnState();
}

class _ResumeBtnState extends State<_ResumeBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _downloadResume(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _hover ? _kAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _hover ? _kAccent : _kBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View Full Résumé',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _hover ? _kBg : _kTextPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.north_east,
                size: 14,
                color: _hover ? _kBg : _kTextPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PROJECTS
// ─────────────────────────────────────────────────────────

class _SectionProjects extends StatelessWidget {
  const _SectionProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SLabel('Projects'),
        const SizedBox(height: 32),
        ..._projects.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ProjectCard(data: p),
        )),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData data;
  const _ProjectCard({required this.data});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.data;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hover ? _kSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hover ? _kBorder : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index number
            SizedBox(
              width: 40,
              child: Text(
                p.index,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: _hover
                      ? _kAccent.withOpacity(0.4)
                      : _kBorder,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _hover ? _kAccent : _kTextPrimary,
                          ),
                        ),
                      ),
                      if (p.published)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F4C1A),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                                color: const Color(0xFF1E8C3A)),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4ADE80),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.65,
                      color: _kTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: p.tech.map((t) => _MiniChip(t)).toList(),
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

// ─────────────────────────────────────────────────────────
// CONTACT
// ─────────────────────────────────────────────────────────

class _SectionContact extends StatelessWidget {
  const _SectionContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SLabel('Contact'),
        const SizedBox(height: 28),
        const Text(
          'Let\'s build something great together.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _kTextPrimary,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'I\'m currently open to new Flutter roles and freelance '
              'projects. Whether you have a question, a project idea, or '
              'just want to connect — my inbox is open.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: _kTextSecondary,
          ),
        ),
        const SizedBox(height: 40),
        _ContactRow(
          icon: Icons.mail_outline_rounded,
          label: 'anjana.murugan27@gmail.com',
          url: 'mailto:anjana.murugan27@gmail.com',
        ),
        const SizedBox(height: 16),
        _ContactRow(
          icon: Icons.phone_outlined,
          label: '+91 7012 733 764',
          url: 'tel:+917012733764',
        ),
        const SizedBox(height: 16),
        _ContactRow(
          icon: Icons.location_on_outlined,
          label: 'Kochi, Kerala, India',
          url: null,
        ),
      ],
    );
  }
}

class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? url;
  const _ContactRow({required this.icon, required this.label, this.url});

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final clickable = widget.url != null;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: clickable ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: clickable
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
              size: 18,
              color: _hover && clickable ? _kAccent : _kTextSecondary,
            ),
            const SizedBox(width: 14),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 15,
                color: _hover && clickable ? _kAccent : _kTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (clickable) ...[
              const SizedBox(width: 6),
              AnimatedSlide(
                offset: _hover ? const Offset(0.15, -0.15) : Offset.zero,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.north_east,
                  size: 12,
                  color: _hover ? _kAccent : _kTextSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}