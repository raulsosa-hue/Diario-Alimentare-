import 'dart:ui';
import 'package:flutter/material.dart';

class TherapyNotePage extends StatefulWidget {
  const TherapyNotePage({super.key});

  @override
  State<TherapyNotePage> createState() => _TherapyNotePageState();
}

class _TherapyNotePageState extends State<TherapyNotePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    // Per ora: conferma visiva. (Salvataggio vero lo facciamo dopo, se vuoi)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salvato')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // TOP BAR
                    SizedBox(
                      height: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                              color: const Color(0xFF2F2F2F),
                              splashRadius: 22,
                            ),
                          ),
                          const Text(
                            'Terapia / Note',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2B2B2B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TEXT AREA
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFE6E6E6),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(fontSize: 20, color: Color(0xFF2B2B2B)),
                            decoration: const InputDecoration(
                              hintText: 'Scrivi qui...',
                              hintStyle: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFB8B8B8),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // SAVE BUTTON
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: SizedBox(
                        width: 320,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.70),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.30),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.save_rounded, size: 28, color: Color(0xFF2E6B6A)),
                              SizedBox(width: 12),
                              Text(
                                'Salva',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2E6B6A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
