import 'package:flutter/material.dart';

import '../auth/auth_screen.dart' show appName, kCyan;
import '../onboarding/onboarding_screen.dart';

/// Splash: شعار + شريط تحميل ثم ينتقل لشاشة Onboarding تلقائيًا
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // مدة الـ Splash (غيّرها إذا تبي أطول أو أقصر)
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  );

  @override
  void initState() {
    super.initState();
    _ctrl.forward().whenComplete(_next);
  }

  void _next() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A3A47), Color(0xFF04141A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              // الشعار
              const Icon(
                Icons.bolt_rounded,
                size: 84,
                color: kCyan,
                shadows: [Shadow(color: kCyan, blurRadius: 30)],
              ),
              const SizedBox(height: 8),
              const Text(
                appName,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(flex: 3),
              // مكان صورة السيارة (استبدلها بصورة من الـ assets)
              const Icon(
                Icons.directions_car_filled_rounded,
                size: 120,
                color: Color(0x6622D3EE),
                shadows: [Shadow(color: Color(0x6622D3EE), blurRadius: 40)],
              ),
              const Spacer(flex: 2),
              const Text(
                'Charge Fast. Drive Far.',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 16),
              // شريط التحميل
              SizedBox(
                width: 110,
                height: 4,
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _ctrl.value,
                      minHeight: 4,
                      color: kCyan,
                      backgroundColor: const Color(0x3322D3EE),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
