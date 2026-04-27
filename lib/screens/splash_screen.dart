import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'parameter_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleIn = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slideUp = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ParameterScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SplashBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _fadeIn,
                    child: ScaleTransition(
                      scale: _scaleIn,
                      child: _HealthcareIcon(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Transform.translate(
                    offset: Offset(0, _slideUp.value),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          const Text(
                            'DiabRisk',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 56,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                              letterSpacing: -1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Skrining Risiko Diabetes Tipe 2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Deteksi dini untuk kesehatan optimal Anda',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeIn,
                    child: const _PagerDots(activeIndex: 1),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthcareIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryTeal],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.favorite,
        color: Colors.white,
        size: 56,
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE3F2FD),
            const Color(0xFFF0F8FF),
            AppColors.backgroundColor,
          ],
        ),
      ),
      child: Stack(
        children: const [
          _SoftWave(top: -50, left: -70, size: 210, opacity: 0.12),
          _SoftWave(top: 130, left: 80, size: 240, opacity: 0.08),
          _SoftWave(bottom: 150, right: -80, size: 260, opacity: 0.10),
          _SoftWave(bottom: -40, left: -60, size: 220, opacity: 0.08),
          _DecorativePlus(top: 96, right: 32, size: 40),
          _DecorativePlus(top: 264, left: 40, size: 22),
          _DecorativePlus(bottom: 92, right: 50, size: 26),
          _DecorativePlus(bottom: 36, left: 44, size: 18),
        ],
      ),
    );
  }
}

class _SoftWave extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  const _SoftWave({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DecorativePlus extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? right;
  final double? left;
  final double size;

  const _DecorativePlus({
    this.top,
    this.bottom,
    this.right,
    this.left,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryTeal.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _PagerDots extends StatelessWidget {
  final int activeIndex;

  const _PagerDots({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: activeIndex == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: activeIndex == index
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
