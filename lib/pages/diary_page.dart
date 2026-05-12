import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/meal.dart';
import '../models/exercise.dart';
import '../repository/diary_repository.dart';
import '../services/pdf_diary_export.dart';
import '../widgets/app_icon_mark.dart';
import '../widgets/common_buttons.dart';
import '../widgets/diary_meal_card.dart';
import '../widgets/diary_exercise_card.dart';
import '../widgets/week_expansion_card.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final DiaryRepository _repository = DiaryRepository();

  bool _isLoading = true;
  List<DiaryWeekGroup> _weekGroups = [];
  DateTime? _sharingWeek;

  static const Color _pageBg = Color(0xFFFCFAF5);
  static const Color _textDark = Color(0xFF22312B);
  static const Color _textMuted = Color(0xFF6A746E);
  static const Color _green = Color(0xFF5B9E4D);
  static const Color _greenDark = Color(0xFF173D2C);
  static const Color _greenSoft = Color(0xFFF1F8EF);

  Widget _topHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Mi Ascolto',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: _green,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 1),
                    AppIconMark(
                      size: 40,
                      color: _green,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Diario',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              height: 1.05,
              fontWeight: FontWeight.w900,
              color: _greenDark,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Rileggi i tuoi momenti con calma',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: _greenSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: _green,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Nessuna registrazione',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Quando salverai un pasto o un esercizio, lo ritroverai qui organizzato per settimane e giorni.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                  color: _textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: _green,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final entries = await _repository.getDiaryEntries();
      final groups = buildDiaryWeekGroups(entries);

      if (!mounted) return;

      setState(() {
        _weekGroups = groups;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _shareWeek(DiaryWeekGroup group) async {
    if (_sharingWeek != null) return;

    setState(() => _sharingWeek = group.monday);

    try {
      final meals = <Meal>[];
      final exercises = <Exercise>[];

      for (final day in group.days) {
        for (final entry in day.entries) {
          switch (entry) {
            case MealDiaryEntry(meal: final m):
              meals.add(m);
            case ExerciseDiaryEntry(exercise: final e):
              exercises.add(e);
          }
        }
      }

      final bytes = await generateWeeklyDiaryPdf(
        monday: group.monday,
        meals: meals,
        exercises: exercises,
      );

      if (!mounted) return;

      await Printing.sharePdf(
        bytes: bytes,
        filename:
        'diario_${group.monday.year}_${twoDigit(group.monday.month)}_${twoDigit(group.monday.day)}.pdf',
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore durante la creazione del PDF'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sharingWeek = null);
      }
    }
  }

  void _openEntryDetail(DiaryEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.42),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.84,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFCF7),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 28),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Dettaglio evento',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          color: _greenDark,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Qui trovi tutte le informazioni salvate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _textMuted,
                        ),
                      ),

                      const SizedBox(height: 14),

                      switch (entry) {
                        MealDiaryEntry(meal: final meal) =>
                            DiaryMealCard(meal: meal),

                        ExerciseDiaryEntry(exercise: final exercise) =>
                            DiaryExerciseCard(exercise: exercise),
                      },
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = (width * 0.055).clamp(18.0, 26.0);

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 90,
              right: -34,
              child: Opacity(
                opacity: 0.10,
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 120,
                  color: _green
                )
              ),
            ),

            Column(
              children: [
                _topHeader(),

                Expanded(
                  child: _isLoading
                      ? _loadingState()
                      : _weekGroups.isEmpty
                      ? Transform.translate(offset: const Offset(0, -70), child: _emptyState(),)
                      : RefreshIndicator(
                    color: _green,
                    backgroundColor: Colors.white,
                    onRefresh: _loadData,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        8,
                        horizontalPadding,
                        28,
                      ),
                      itemCount: _weekGroups.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final group = _weekGroups[index];

                        return WeekExpansionCard(
                          group: group,
                          initiallyExpanded: index == 0,
                          isSharing: _sharingWeek == group.monday,
                          onShare: () => _shareWeek(group),
                          onEntryTap: _openEntryDetail,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}