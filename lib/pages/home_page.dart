import 'package:flutter/material.dart';

import '../styles.dart';
import 'add_exercise_page.dart';
import 'add_meal_page.dart';
import 'diary_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color _background = Color(0xFFFCFBF7);

  static const Color _green = Color(0xFF4F9B55);
  static const Color _greenDark = Color(0xFF2F6F36);

  static const Color _mealColor = Color(0xFFE99A45);
  static const Color _mealLight = Color(0xFFFFF4E6);

  static const Color _exerciseColor = Color(0xFF63B85D);
  static const Color _exerciseLight = Color(0xFFF0FAEE);

  static const Color _diaryColor = Color(0xFF5B9BD5);
  static const Color _diaryLight = Color(0xFFF0F7FF);

  static const Color _textDark = Color(0xFF27312B);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final horizontalPadding = (size.width * 0.075).clamp(22.0, 32.0);
    final topPadding = (size.height * 0.055).clamp(34.0, 58.0);
    final cardGap = (size.height * 0.023).clamp(15.0, 22.0);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 115,
              right: -55,
              child: _DecorativeLeaf(),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                28,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      70,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _HomeHeader(),

                    SizedBox(
                      height: (size.height * 0.06).clamp(38.0, 60.0),
                    ),

                    _HomeActionCard(
                      title: 'PASTO',
                      subtitle: 'Mangia, senti e\nannota',
                      icon: Icons.restaurant_rounded,
                      accentColor: _mealColor,
                      backgroundColor: _mealLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddMealPage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: cardGap),

                    _HomeActionCard(
                      title: 'ESERCIZIO',
                      subtitle: 'Allenati, senti e\nannota',
                      icon: Icons.directions_run_rounded,
                      accentColor: _exerciseColor,
                      backgroundColor: _exerciseLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddExercisePage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: cardGap),

                    _HomeActionCard(
                      title: 'DIARIO',
                      subtitle: 'Attività, emozioni\ne pensieri',
                      icon: Icons.menu_book_rounded,
                      accentColor: _diaryColor,
                      backgroundColor: _diaryLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DiaryPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final titleSize = (width * 0.073).clamp(26.0, 31.0);
    final subtitleSize = (width * 0.052).clamp(18.0, 21.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mi Ascolto',
              textAlign: TextAlign.center,
              style: DS.pageTitle.copyWith(
                fontSize: titleSize,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                color: HomePage._greenDark,
                letterSpacing: 0.2,
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.eco_rounded,
              color: HomePage._green,
              size: 30,
            ),
          ],
        ),

        const SizedBox(height: 32),

        Text(
          'Ascolta il tuo corpo,\nsegui le tue emozioni',
          textAlign: TextAlign.center,
          style: DS.navLabel.copyWith(
            fontSize: subtitleSize,
            height: 1.35,
            fontWeight: FontWeight.w600,
            color: HomePage._greenDark.withOpacity(0.78),
          ),
        ),
      ],
    );
  }
}

class _HomeActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<_HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<_HomeActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final cardHeight = (width * 0.34).clamp(130.0, 150.0);
    final circleSize = (width * 0.18).clamp(64.0, 78.0);
    final iconSize = (circleSize * 0.50).clamp(32.0, 39.0);

    final titleFontSize = (width * 0.040).clamp(19.0, 22.0);

    // Qui è la modifica principale: sottotitoli più piccoli
    final subtitleFontSize = (width * 0.005).clamp(13.0, 14.5);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.975 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: cardHeight,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.85),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(_pressed ? 0.10 : 0.16),
                blurRadius: _pressed ? 12 : 22,
                offset: _pressed ? const Offset(0, 5) : const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(_pressed ? 0.04 : 0.07),
                blurRadius: _pressed ? 10 : 18,
                offset: _pressed ? const Offset(0, 4) : const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),

              const SizedBox(width: 22),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DS.pageTitle.copyWith(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w900,
                        color: widget.accentColor,
                        letterSpacing: 0.8,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      widget.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DS.navLabel.copyWith(
                        fontSize: subtitleFontSize,
                        height: 1.22,
                        fontWeight: FontWeight.w600,
                        color: HomePage._textDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                color: widget.accentColor.withOpacity(0.85),
                size: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeLeaf extends StatelessWidget {
  const _DecorativeLeaf();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.18,
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            children: [
              Positioned(
                right: 30,
                top: 8,
                child: Transform.rotate(
                  angle: -0.65,
                  child: Container(
                    width: 54,
                    height: 100,
                    decoration: BoxDecoration(
                      color: HomePage._green,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 50,
                child: Transform.rotate(
                  angle: 0.9,
                  child: Container(
                    width: 48,
                    height: 92,
                    decoration: BoxDecoration(
                      color: HomePage._green,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}