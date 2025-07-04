import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

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

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroSection(
                  height: screenHeight,
                ).animate().fade(duration: 700.ms).slideY(begin: 0.3),

                const SizedBox(height: 60),
                const SectionWrapper(child: AboutSection()),

                const SizedBox(height: 60),
                const SectionWrapper(child: SkillsSection()),

                const SizedBox(height: 60),
                const SectionWrapper(child: ProjectsSection()),

                const SizedBox(height: 60),
                const SectionWrapper(child: ExperienceSection()),

                const SizedBox(height: 60),
                const SectionWrapper(child: EducationSection()),

                const SizedBox(height: 60),
                const SectionWrapper(child: ContactSection()),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionWrapper extends StatelessWidget {
  final Widget child;
  const SectionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child.animate().fade(duration: 600.ms).slideY(begin: 0.2),
    );
  }
}

class HeroSection extends StatelessWidget {
  final double height;
  const HeroSection({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi, I\'m',
              style: TextStyle(fontSize: 28, color: Colors.white70),
            ),
            Text(
              'Abhinav S Nair',
              style: GoogleFonts.orbitron(
                fontSize: 48,
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fade(duration: 500.ms).slideY(),
            const SizedBox(height: 20),
            Text(
              'Flutter Developer | Mobile App Engineer',
              style: TextStyle(fontSize: 18, color: Colors.white60),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              child: const Text('Download Resume'),
            ).animate().fade(duration: 700.ms),
          ],
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
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.tealAccent,
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(title: 'About Me'),
          SizedBox(height: 10),
          Text(
            'I am a passionate Flutter Developer with over 2 years of experience in mobile application development. '
            'I specialize in building clean, scalable, and high-performing applications, optimizing app performance, and integrating APIs. '
            'Additionally, I have knowledge of web development technologies like HTML and CSS and continuously strive to learn new tools and techniques.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
    return Chip(
      label: Text(label),
      backgroundColor: Colors.teal.withOpacity(0.2),
      labelStyle: const TextStyle(color: Colors.tealAccent),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
