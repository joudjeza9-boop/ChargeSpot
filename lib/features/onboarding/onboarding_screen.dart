import 'package:flutter/material.dart';

import '../auth/auth_screen.dart';

class _OnboardPage {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// صفحات التعريف (النقاط الثلاث بالتصميم)
const _pages = <_OnboardPage>[
  _OnboardPage(
    icon: Icons.ev_station_rounded,
    title: 'Power Up Your Drive',
    subtitle: 'Find stations, book chargers, and track your charging sessions.',
  ),
  _OnboardPage(
    icon: Icons.map_rounded,
    title: 'Find Stations Nearby',
    subtitle: 'Search and filter charging stations close to you in seconds.',
  ),
  _OnboardPage(
    icon: Icons.calendar_month_rounded,
    title: 'Book & Track',
    subtitle: 'Reserve a charger and follow your charging session live.',
  ),
];

/// Onboarding: تعريف بالتطبيق مع Skip و Get Started
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A3A47), Color(0xFF04141A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  // Skip
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 12),
                      child: TextButton(
                        onPressed: _goToAuth,
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),

                  // الصفحات (تتحرك بالسحب)
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                    ),
                  ),

                  // النقاط
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _index ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? kCyan
                                : const Color(0x4DFFFFFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Get Started
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _goToAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCyan,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // مكان صورة الشاحن (استبدلها بصورة من الـ assets)
          Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x3322D3EE), Color(0x0022D3EE)],
              ),
            ),
            child: Icon(
              page.icon,
              size: 110,
              color: kCyan,
              shadows: const [Shadow(color: kCyan, blurRadius: 30)],
            ),
          ),
          const SizedBox(height: 36),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}
