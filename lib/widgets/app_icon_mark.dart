import 'package:flutter/material.dart';

class AppIconMark extends StatelessWidget {
  final double size;
  final double opacity;
  final bool withBackground;
  final Color? color;

  const AppIconMark({
    super.key,
    this.size = 32,
    this.opacity = 1,
    this.withBackground = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final image = Opacity(
      opacity: opacity,
      child: Image.asset(
        'assets/icons/app_icon_foreground.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        color: color,
        colorBlendMode: BlendMode.srcIn,
        filterQuality: FilterQuality.high,
      ),
    );

    if (!withBackground) return image;

    return Container(
      width: size + 12,
      height: size + 12,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(child: image),
    );
  }
}