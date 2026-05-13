import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({
    super.key,
    required this.nextPage,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color _background = Color(0xFFFCFAF5);
  static const Color _primaryGreen = Color(0xFF55C76A);
  static const Color _darkGreen = Color(0xFF18382B);
  static const Color _mutedText = Color(0xFF76827A);

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: _background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => widget.nextPage,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
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
      backgroundColor: _background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCFAF5),
              Color(0xFFF7FBF4),
              Color(0xFFFCFAF5),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;

              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: isLandscape
                      ? _landscapeContent(constraints)
                      : _portraitContent(constraints),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _portraitContent(BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight - 48,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logoBox(
              boxSize: 152,
              iconSize: 108,
              radius: 42,
            ),

            const SizedBox(height: 34),

            const Text(
              'Mi Ascolto',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 44,
                height: 1.05,
                fontWeight: FontWeight.w900,
                color: _darkGreen,
                letterSpacing: -1.2,
              ),
            ),

            const SizedBox(height: 14),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Ascolta il tuo corpo, segui le tue emozioni',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: _mutedText,
                ),
              ),
            ),

            const SizedBox(height: 44),

            _loader(
              size: 34,
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _landscapeContent(BoxConstraints constraints) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 14,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 760,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logoBox(
                boxSize: 118,
                iconSize: 82,
                radius: 34,
              ),

              const SizedBox(width: 34),

              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mi Ascolto',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 40,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        color: _darkGreen,
                        letterSpacing: -1.1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Ascolta il tuo corpo, segui le tue emozioni',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: _mutedText,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _loader(
                      size: 30,
                      strokeWidth: 3.6,
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

  Widget _logoBox({
    required double boxSize,
    required double iconSize,
    required double radius,
  }) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withOpacity(0.16),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/icons/app_icon_foreground.png',
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _loader({
    required double size,
    required double strokeWidth,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: const AlwaysStoppedAnimation<Color>(
          _primaryGreen,
        ),
        backgroundColor: _primaryGreen.withOpacity(0.16),
      ),
    );
  }
}