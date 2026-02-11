import 'package:flutter/material.dart';
import 'export_excel_page.dart';

import 'add_meal_page.dart';
import 'add_exercise_page.dart';
import 'therapy_note_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // =========================
  // SOLO COLORI (soft + coerenti)
  // =========================
  static const Color _bgTop = Color(0xFFF2F6FB);       // azzurro/grigio molto chiaro
  static const Color _bgBottom = Color(0xFFE9EFF7);    // leggermente più “freddo”
  static const Color _panel = Color(0xFFE7ECF3);       // pannello centrale soft

  static const Color _circleBase = Color(0xFFF7F8FA);  // cerchi chiari coerenti
  static const Color _circleBorder = Color(0xFFFFFFFF);

  static const Color _shadowDark = Color(0x26000000);  // ombra morbida
  static const Color _shadowLight = Color(0x66FFFFFF); // highlight

  // piccoli accenti “soft” per distinguere i 4 cerchi (non invasivi)
  static const Color _tintMeal = Color(0xFFF7E6D6);     // pesca chiaro
  static const Color _tintExercise = Color(0xFFE3F2E7); // verde chiaro
  static const Color _tintTherapy = Color(0xFFEDE7F6);  // lilla chiaro
  static const Color _tintExport = Color(0xFFE1EEF7);   // azzurro chiaro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // sfondo soft coerente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _GlassPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 18),
                    const Text(
                      'DIARIO ALIMENTARE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // griglia 2x2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CircleButton(
                          label: 'Pasto',
                          icon: Icons.restaurant,
                          tint: _tintMeal,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AddMealPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 18),
                        _CircleButton(
                          label: 'Esercizio\nFisico',
                          icon: Icons.fitness_center,
                          tint: _tintExercise,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AddExercisePage()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CircleButton(
                          label: 'Terapia/\nNote',
                          icon: Icons.edit_note,
                          tint: _tintTherapy,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const TherapyNotePage()),
                            );
                          },
                        ),
                        const SizedBox(width: 18),
                        _CircleButton(
                          label: 'Esporta Diario\nin EXCEL\n(CSV)',
                          icon: Icons.download,
                          tint: _tintExport,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ExportTimelinePage()),


                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// PANNELLO “VETRO” (solo colori/ombre soft)
// =========================
class _GlassPanel extends StatelessWidget {
  final Widget child;
  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HomePage._panel.withOpacity(0.75),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: HomePage._shadowDark,
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
          BoxShadow(
            color: HomePage._shadowLight,
            blurRadius: 10,
            offset: Offset(-6, -6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =========================
// CERCHIO (stessa grafica, solo colori)
// =========================
class _CircleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color tint;

  const _CircleButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // base chiara + leggero “tint” per distinguere i 4 cerchi
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HomePage._circleBase,
              Color.lerp(HomePage._circleBase, tint, 0.55)!,
            ],
          ),
          border: Border.all(color: HomePage._circleBorder.withOpacity(0.85), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: HomePage._shadowDark,
              blurRadius: 22,
              offset: Offset(0, 14),
            ),
            BoxShadow(
              color: HomePage._shadowLight,
              blurRadius: 10,
              offset: Offset(-6, -6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: Colors.black87),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
