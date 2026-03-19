import 'package:flutter/material.dart';

/// Centralized design system for consistent visual appearance across all screens.
abstract final class DS {
  // ========================
  // COLORS
  // ========================

  // --- Borders & shadows ---
  static const Color borderLight = Color(0x22000000);
  static const Color borderSubtle = Color(0x14000000);
  static const Color borderEmphasis = Color(0x55000000);
  static const Color borderFaint = Color(0x1A000000);

  static const Color shadow = Color(0x14000000);

  // --- Accent ---
  static const Color accent = Color(0xFF1D7A6A);
  static const Color accentDark = Color(0xFF00695C);

  // --- Surfaces ---
  static const Color surfaceWhite65 = Color(0xA6FFFFFF); // ~0.65 alpha
  static const Color surfaceWhite85 = Color(0xD9FFFFFF); // ~0.85 alpha
  static const Color surfaceWhite35 = Color(0x59FFFFFF); // ~0.35 alpha
  static const Color surfaceMuted = Color(0xFFF3F5F9);

  // --- Chips ---
  static const Color chipSelectedMeal = Color(0xFFBFE3D8);
  static const Color chipSelectedExercise = Color(0x2200A86B);

  // --- Text colors ---
  static const Color textPrimary = Colors.black87;
  static const Color textDark = Color(0xC7000000); // ~0.78 alpha
  static const Color textMuted = Color(0xBF000000); // ~0.75 alpha

  // ========================
  // TEXT STYLES
  // ========================

  /// Page title — main screen headings ("DIARIO ALIMENTARE")
  static const TextStyle pageTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    color: textPrimary,
  );

  /// Body text — card-level labels, field values, text input content
  /// ("Data e ora:", date/time values, TextField style)
  static const TextStyle bodyText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  /// Body text bold — emphasized card labels, button labels, dropdown items
  /// ("Tipo pasto:", "Cambia data/ora")
  static const TextStyle bodyTextBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  /// Section label — segment/section headers, sub-section titles,
  /// slider labels, emotion block titles
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  /// Chip label — selectable option chip text
  static const TextStyle chipLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Emoji text — emoji display in chips
  static const TextStyle emojiText = TextStyle(
    fontSize: 18,
  );

  /// FilterChip label — emotion FilterChip text (uses default size)
  static const TextStyle filterChipLabel = TextStyle(
    fontWeight: FontWeight.w700,
  );

  /// Caption bold — small secondary labels (time card title)
  static const TextStyle captionBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: textPrimary,
  );

  /// Caption — secondary informational text ("Scelta attiva")
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Display large — prominent numeric/time values
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  /// Display medium — medium value displays (duration value)
  static const TextStyle displayMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );

  /// Control button — stepper +/- buttons
  static const TextStyle controlButton = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );

  /// Primary action button — save/submit buttons
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  /// Secondary action button — less prominent actions (export)
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Navigation label — home screen circle button labels
  static const TextStyle navLabel = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w900,
    color: textPrimary,
    height: 1.15,
  );

  // ========================
  // COMMON DECORATIONS
  // ========================

  static const BoxShadow cardShadow = BoxShadow(
    blurRadius: 10,
    offset: Offset(0, 6),
    color: shadow,
  );

  // ========================
  // SPACING
  // ========================

  static const double chipWrapSpacing = 6.0;
  static const double chipWrapRunSpacing = 6.0;

  // ========================
  // RADII
  // ========================

  static const double radiusCard = 18.0;
  static const double radiusField = 16.0;
  static const double radiusChip = 22.0;
  static const double radiusPill = 999.0;
}
