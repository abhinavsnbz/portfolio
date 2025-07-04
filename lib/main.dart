import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abhinav S Nair | Flutter Developer',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.cyanAccent,
        ),
        useMaterial3: true,
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
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'projects': GlobalKey(),
    'experience': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
  };

  bool _showNavBar = false;
  late AnimationController _backgroundAnimationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showNavBar) {
      setState(() {
        _showNavBar = true;
      });
    } else if (_scrollController.offset <= 100 && _showNavBar) {
      setState(() {
        _showNavBar = false;
      });
    }
  }

  void _scrollToSection(String sectionKey) {
    final context = _sectionKeys[sectionKey]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      body: Stack(
        children: [
          // Animated Background with Geometric Shapes
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter: GeometricBackgroundPainter(
                  animation: _backgroundAnimationController,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                size: Size(screenWidth, screenHeight * 2),
              );
            },
          ),

          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      key: _sectionKeys['home'],
                      child: HeroSection(
                        height: screenHeight,
                        onScrollToAbout: () => _scrollToSection('about'),
                      ).animate().fade(duration: 700.ms).slideY(begin: 0.3),
                    ),

                    const SizedBox(height: 60),
                    SectionWrapper(
                      sectionKey: _sectionKeys['about']!,
                      child: const AboutSection(),
                    ),

                    const SizedBox(height: 60),
                    SectionWrapper(
                      sectionKey: _sectionKeys['skills']!,
                      child: const SkillsSection(),
                    ),

                    const SizedBox(height: 60),
                    SectionWrapper(
                      sectionKey: _sectionKeys['projects']!,
                      child: const ProjectsSection(),
                    ),

                    const SizedBox(height: 60),
                    SectionWrapper(
                      sectionKey: _sectionKeys['experience']!,
                      child: const ExperienceSection(),
                    ),

                    const SizedBox(height: 60),
                    SectionWrapper(
                      sectionKey: _sectionKeys['education']!,
                      child: const EducationSection(),
                    ),

                    const SizedBox(height: 60),
                    SectionWrapper(
                      sectionKey: _sectionKeys['contact']!,
                      child: const ContactSection(),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          // Floating Navigation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _showNavBar ? 20 : -80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.grey[900]!.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem('Home', 'home'),
                    _buildNavItem('About', 'about'),
                    _buildNavItem('Skills', 'skills'),
                    _buildNavItem('Projects', 'projects'),
                    _buildNavItem('Experience', 'experience'),
                    _buildNavItem('Education', 'education'),
                    _buildNavItem('Contact', 'contact'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button for scroll to top
      floatingActionButton: AnimatedOpacity(
        opacity: _showNavBar ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.tealAccent, Colors.cyanAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
              );
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            mini: true,
            elevation: 0,
            child: const Icon(Icons.keyboard_arrow_up),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, String sectionKey) {
    return GestureDetector(
      onTap: () => _scrollToSection(sectionKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.tealAccent.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.tealAccent,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GeometricBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final double screenWidth;
  final double screenHeight;

  GeometricBackgroundPainter({
    required this.animation,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Base gradient background
    final bgGradient = LinearGradient(
      colors: [
        const Color(0xFF0A0E13),
        const Color(0xFF1A1F2E),
        const Color(0xFF2D3748),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = bgGradient.createShader(bgRect);
    canvas.drawRect(bgRect, paint);

    // Floating geometric shapes
    _drawFloatingShapes(canvas, size);

    // Grid pattern
    _drawGridPattern(canvas, size);

    // Animated orbs
    _drawAnimatedOrbs(canvas, size);
  }

  void _drawFloatingShapes(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Hexagon
    final hexCenter = Offset(
      size.width * 0.8 + math.sin(animation.value * 2 * math.pi) * 30,
      size.height * 0.3 + math.cos(animation.value * 2 * math.pi) * 20,
    );
    _drawHexagon(
      canvas,
      hexCenter,
      60,
      paint..color = Colors.tealAccent.withOpacity(0.1),
    );

    // Triangle
    final triCenter = Offset(
      size.width * 0.1 + math.cos(animation.value * 2 * math.pi * 0.7) * 25,
      size.height * 0.6 + math.sin(animation.value * 2 * math.pi * 0.7) * 15,
    );
    _drawTriangle(
      canvas,
      triCenter,
      50,
      paint..color = Colors.cyanAccent.withOpacity(0.08),
    );

    // Diamond
    final diamondCenter = Offset(
      size.width * 0.9 + math.sin(animation.value * 2 * math.pi * 1.3) * 20,
      size.height * 0.8 + math.cos(animation.value * 2 * math.pi * 1.3) * 30,
    );
    _drawDiamond(
      canvas,
      diamondCenter,
      40,
      paint..color = Colors.purpleAccent.withOpacity(0.06),
    );

    // Additional shapes
    final circleCenter = Offset(
      size.width * 0.2 + math.cos(animation.value * 2 * math.pi * 0.5) * 35,
      size.height * 0.2 + math.sin(animation.value * 2 * math.pi * 0.5) * 25,
    );
    canvas.drawCircle(
      circleCenter,
      35,
      paint..color = Colors.blueAccent.withOpacity(0.05),
    );
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Add shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(path, shadowPaint);
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size / 2);
    path.lineTo(center.dx - size / 2, center.dy + size / 2);
    path.lineTo(center.dx + size / 2, center.dy + size / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size, center.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawGridPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent.withOpacity(0.03)
      ..strokeWidth = 1;

    // Vertical lines
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawAnimatedOrbs(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Large orb
    final orbCenter1 = Offset(
      size.width * 0.7 + math.sin(animation.value * 2 * math.pi * 0.3) * 100,
      size.height * 0.4 + math.cos(animation.value * 2 * math.pi * 0.3) * 60,
    );

    final gradient1 = RadialGradient(
      colors: [
        Colors.tealAccent.withOpacity(0.2),
        Colors.tealAccent.withOpacity(0.05),
        Colors.transparent,
      ],
    );
    paint.shader = gradient1.createShader(
      Rect.fromCircle(center: orbCenter1, radius: 120),
    );
    canvas.drawCircle(orbCenter1, 120, paint);

    // Medium orb
    final orbCenter2 = Offset(
      size.width * 0.3 + math.cos(animation.value * 2 * math.pi * 0.8) * 80,
      size.height * 0.7 + math.sin(animation.value * 2 * math.pi * 0.8) * 50,
    );

    final gradient2 = RadialGradient(
      colors: [
        Colors.cyanAccent.withOpacity(0.15),
        Colors.cyanAccent.withOpacity(0.03),
        Colors.transparent,
      ],
    );
    paint.shader = gradient2.createShader(
      Rect.fromCircle(center: orbCenter2, radius: 80),
    );
    canvas.drawCircle(orbCenter2, 80, paint);
  }

  @override
  bool shouldRepaint(GeometricBackgroundPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final GlobalKey sectionKey;

  const SectionWrapper({
    super.key,
    required this.child,
    required this.sectionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.02), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child.animate().fade(duration: 600.ms).slideY(begin: 0.2),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final double height;
  final VoidCallback onScrollToAbout;

  const HeroSection({
    super.key,
    required this.height,
    required this.onScrollToAbout,
  });

  void launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
            Color(0xFF0F2027),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.tealAccent.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Hi, I\'m',
                  style: const TextStyle(fontSize: 28, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.tealAccent.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  'Abhinav S Nair',
                  style: GoogleFonts.orbitron(
                    fontSize: 48,
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.tealAccent.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 500.ms).slideY(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Flutter Developer | Mobile App Engineer',
                style: TextStyle(fontSize: 18, color: Colors.white60),
              ),
              const SizedBox(height: 30),

              // 🌐 Social Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.tealAccent,
                    ),
                    tooltip: 'Instagram',
                    onPressed: () => launchURL(
                      'https://www.instagram.com/abinav.sn?igsh=cGVsb2hwZmZjZGx4',
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.tealAccent,
                    ),
                    tooltip: 'LinkedIn',
                    onPressed: () => launchURL(
                      'https://www.linkedin.com/in/abhinav-s-nair-711b4820b?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.tealAccent,
                    ),
                    tooltip: 'WhatsApp',
                    onPressed: () => launchURL('https://wa.me/917012185604'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Download Resume Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.tealAccent, Colors.cyanAccent],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.tealAccent.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        const url = 'assets/resume/Resume.pdf';
                        html.AnchorElement anchor =
                            html.AnchorElement(href: url)
                              ..setAttribute(
                                'download',
                                'Abhinav_S_Nair_Resume.pdf',
                              )
                              ..click();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Download Resume'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: onScrollToAbout,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.tealAccent),
                        foregroundColor: Colors.tealAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Learn More'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),
              GestureDetector(
                onTap: onScrollToAbout,
                child: Column(
                  children: [
                    const Text(
                      'Scroll Down',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.tealAccent,
                          size: 30,
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .moveY(
                          begin: 0,
                          end: 10,
                          duration: 1000.ms,
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent,
          shadows: [
            Shadow(
              color: Colors.tealAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.3), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'About Me'),
          SizedBox(height: 10),
          Text(
            'I am a passionate Flutter Developer with over 2 years of experience in mobile application development. '
            'I specialize in building clean, scalable, and high-performing applications, optimizing app performance, and integrating APIs. '
            'Additionally, I have knowledge of web development technologies like HTML and CSS and continuously strive to learn new tools and techniques.',
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.3), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'Skills'),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SkillChip(label: 'Flutter'),
              SkillChip(label: 'Dart'),
              SkillChip(label: 'GetX'),
              SkillChip(label: 'BLoC'),
              SkillChip(label: 'Provider'),
              SkillChip(label: 'Firebase'),
              SkillChip(label: 'SQLite'),
              SkillChip(label: 'Hive'),
              SkillChip(label: 'Git & GitHub'),
              SkillChip(label: 'REST API'),
              SkillChip(label: 'HTML & CSS'),
            ],
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.withOpacity(0.3), Colors.teal.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.transparent,
        labelStyle: const TextStyle(color: Colors.tealAccent),
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.3), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'Projects'),
          SizedBox(height: 10),
          ProjectCard(title: 'Chatbot App', subtitle: 'GetX + Hive'),
          ProjectCard(
            title: 'AI Body Detection',
            subtitle: 'Mediapipe + Provider',
          ),
          ProjectCard(
            title: 'LMS App',
            subtitle: 'Flutter + Firebase + YouTube',
          ),
          ProjectCard(
            title: 'Love Birds App',
            subtitle: 'Bloc + Sqflite + QR Code',
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const ProjectCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.tealAccent)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      ),
    );
  }
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'Experience'),
          SizedBox(height: 10),
          Text(
            'BzAnalytics Pvt Ltd — Associate Software Developer',
            style: TextStyle(color: Colors.white),
          ),
          Text('May 2023 - Present', style: TextStyle(color: Colors.white70)),
          Text('• Developed and maintained Flutter mobile apps.'),
          Text('• Collaborated on AI body detection and LMS apps.'),
          SizedBox(height: 20),
          Text(
            'BzAnalytics Pvt Ltd — Intern',
            style: TextStyle(color: Colors.white),
          ),
          Text('Jan 2023 - Apr 2023', style: TextStyle(color: Colors.white70)),
          Text('• Supported UI/UX and Flutter app development.'),
        ],
      ),
    );
  }
}

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'Education'),
          SizedBox(height: 10),
          Text(
            'B.Tech Mechanical, 2017-2021',
            style: TextStyle(color: Colors.white),
          ),
          Text('APJ Abdul Kalam Technological University'),
          Text('Heera College of Engineering and Technology'),
          SizedBox(height: 10),
          Text(
            'Computer Science, 2015-2017',
            style: TextStyle(color: Colors.white),
          ),
          Text('SNVHSS Anad Higher Secondary'),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C5364), Color(0xFF203A43), Color(0xFF0F2027)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'Contact'),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.tealAccent),
              SizedBox(width: 8),
              Text('+91 7012185604'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, color: Colors.tealAccent),
              SizedBox(width: 8),
              Text('abhinavsnvvh@gmail.com'),
            ],
          ),
        ],
      ),
    );
  }
}
