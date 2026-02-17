# Codebase Analysis Report

Date: 2026-02-17
Branch: `new-setup-and-analysis` (based on `main` @ 7c45bd4)

---

## Step 1 — Code Analysis

### Project overview

Flutter iOS app — a therapeutic food diary ("Diario Alimentare") that records meals, exercise, and therapy notes. Written in Dart, targets iOS only.

### File structure (13 Dart files)

```
lib/
  main.dart                          # App entry point + theme
  models/
    entry.dart                       # DiaryEntry model (flat, for "extra" meals)
    timeline_event.dart              # TimelineEvent model (phase-based, unused)
  pages/
    home_page.dart                   # Home screen — 4 circular buttons (2x2 grid)
    add_meal_page.dart               # Main meal form (Before/Meal/After)
    add_exercise_page.dart           # Exercise form (Before/During/After)
    add_extra_page.dart              # "Extra meal" form (simpler, flat model)
    therapy_note_page.dart           # Free-text note page
    export_excel_page.dart           # Timeline export to .xlsx
  services/
    database_service.dart            # SQLite DB (sqflite) — schema only, not used by UI
    excel_service.dart               # CSV export from DiaryEntry list (not used by UI)
    storage_service.dart             # SharedPreferences persistence for DiaryEntry
    timeline_store.dart              # JSON file persistence for timeline events
```

### Architecture & data flow

**There are three separate, unconnected persistence systems:**

| Service | Storage | Used by | Model |
|---------|---------|---------|-------|
| `TimelineStore` | JSON file (`timeline_events.json`) | `AddMealPage`, `AddExercisePage`, `ExportTimelinePage` | Raw `Map<String, dynamic>` |
| `StorageService` | SharedPreferences | `AddExtraPage` | `DiaryEntry` |
| `DatabaseService` | SQLite (`diario_alimentare.db`) | **Nothing** (dead code) | SQL schema |

The main meal and exercise pages save to `TimelineStore` (JSON file). The "extra meal" page saves to `StorageService` (SharedPreferences). The SQLite database is defined but never called from any UI. The `ExcelService` (CSV export) is also dead code — the actual export uses `ExportTimelinePage` which reads from `TimelineStore` and writes `.xlsx` via the `excel` package.

**Dead code summary:**
- `DatabaseService` — entire class unused
- `ExcelService` — entire class unused
- `TimelineEvent` model — never instantiated
- `DiaryEntry` model — only used by `AddExtraPage` + `StorageService`

### Home screen

Four circular buttons in a 2x2 grid:
1. **Pasto** → `AddMealPage`
2. **Esercizio Fisico** → `AddExercisePage`
3. **Terapia / Note** → `TherapyNotePage`
4. **Esporta Diario in EXCEL (CSV)** → `ExportTimelinePage`

No navigation back to history, no weekly view, no settings.

### AddMealPage (main form, ~777 lines)

Structured in three sections matching the Before/Event/After model:
- **Prima del pasto**: where, with whom, physical sensations, emotional intensity slider (0-10), emotion picker (18 preset emotions with emoji + custom text), thought
- **Pasto**: meal type dropdown (6 types), start time, end time, what I ate
- **Dopo il pasto**: physical sensations, emotional intensity slider, emotion picker, thought

Saves a nested `Map<String, dynamic>` to `TimelineStore`. Emotion system has a "prevalence rule" — if custom text is entered, preset emoji selections are cleared (and vice versa).

### AddExercisePage (~897 lines)

Structured similarly:
- **Esercizio**: exercise type (10 presets + custom), duration (stepper, 5-min increments)
- **Intenzione (prima)**: 4 intention presets (wellness, emotion management, burning/compensating, control/punishment), intensity slider, emotions, thought
- **Esito (dopo)**: 4 outcome presets, physical sensations, intensity slider, emotions, thought

Also saves to `TimelineStore`.

### AddExtraPage (~190 lines)

Simpler flat form (category dropdown, what, where, with whom, mood, notes). Uses `DiaryEntry` model + `StorageService` (SharedPreferences). **This data is completely invisible to the export page** since export reads from `TimelineStore`, not `StorageService`.

### TherapyNotePage (~172 lines)

Free-text input with a "Save" button. **Save does nothing** — it only shows a SnackBar saying "Salvato" but does not persist the text anywhere. The `_save()` method has a comment: "Per ora: conferma visiva. (Salvataggio vero lo facciamo dopo, se vuoi)".

### ExportTimelinePage (~313 lines)

Reads all events from `TimelineStore`, generates an Excel `.xlsx` file with columns: Data, Ora, Tipo evento, Categoria, Intenzione, Emozioni, Intensita emotiva, Sensazioni fisiche, Pensiero, Esito/Dopo, Note libere. Uses `share_plus` to share the file via iOS share sheet.

Has robust field-resolution logic (`_pickAny` / `_pickPath`) that tries multiple key paths to extract data from the heterogeneous event maps.

### Code quality issues

1. **Three persistence systems that don't talk to each other** — architectural fragmentation
2. **Dead code**: `DatabaseService`, `ExcelService`, `TimelineEvent` model are all unused
3. **TherapyNotePage doesn't save** — user sees "Salvato" but nothing is persisted
4. **AddExtraPage data is siloed** — saved to SharedPreferences, invisible to export
5. **Inconsistent indentation** throughout (mix of 0-indent and 2-indent within classes)
6. **Italian comments with unescaped apostrophes** cause Dart syntax errors in several files (`dell'app`, `d'animo`, `un'emozione`, `l'intensità`, `l'esercizio`)
7. **Case-sensitive import bug**: `Timeline_store.dart` vs actual `timeline_store.dart`
8. **`database_service.dart`**: methods outside class body (missing closing brace), `data_record` column doesn't match `data` schema column, `seedTestPastoIfEmpty` calls `database` getter recursively (infinite loop risk)
9. **No error handling** on TimelineStore file I/O
10. **`withOpacity` deprecated** — used extensively across exercise, home, and therapy pages

### Dependencies

- `flutter` (SDK)
- `shared_preferences` — used only by `AddExtraPage`
- `path_provider` — used by `TimelineStore` and `ExcelService`
- `excel` — used by `ExportTimelinePage`
- `share_plus` — used by `ExportTimelinePage`
- `sqflite` + `path` — used only by dead `DatabaseService`

---

## Step 2 — Comparison with Product Owner's Description

### Claim-by-claim verification

| Claim | Reality | Status |
|-------|---------|--------|
| App solo iOS | Correct. Only iOS build config used. | Confirmed |
| Offline-first, dati salvati localmente | Partially true. `TimelineStore` saves to a JSON file. But `TherapyNotePage` doesn't save at all, and `AddExtraPage` saves to a separate silo. | Partially true |
| Nessun backend, nessun cloud | Correct. No network code whatsoever. | Confirmed |
| Registra Pasti | Yes, `AddMealPage` works and saves to `TimelineStore`. | Confirmed |
| Registra Esercizio fisico | Yes, `AddExercisePage` works and saves to `TimelineStore`. | Confirmed |
| Registra Terapia / Note | **No.** `TherapyNotePage` has UI but `_save()` doesn't persist anything. | Not working |
| Struttura Prima / Evento / Dopo | Yes for meals (Prima/Pasto/Dopo) and exercise (Intenzione+prima/Esercizio/Esito+dopo). | Confirmed |
| Dati: emozioni, intensita emotiva | Yes — emotion pickers and intensity sliders in both meal and exercise forms. | Confirmed |
| Dati: sensazioni fisiche | Yes — text fields for physical sensations in both forms. | Confirmed |
| Dati: pensieri | Yes — thought text fields in both Before and After sections. | Confirmed |
| Dati: intenzione | Only in exercise form (4 presets). Not in meal form. | Partial |
| Export in Excel come timeline | Yes, `ExportTimelinePage` generates `.xlsx` with timeline columns. | Confirmed |

### What the product owner missed or may not realize

1. **Therapy notes are fake-saved** — the UI confirms save but nothing is persisted. If the app is used therapeutically, any therapy notes entered are lost on app close.
2. **"Extra meal" data is siloed** — `AddExtraPage` exists in code (and `AddMealPage` has a "Pasti aggiuntivi" option in its dropdown) but `AddExtraPage` saves to a completely different storage system. Its data never appears in the timeline export.
3. **SQLite database is scaffolded but not wired** — there's a full SQL schema for `pasti` with 30+ columns that mirrors the meal form structure, but no UI code uses it. The `seedTestPastoIfEmpty` method has an infinite recursion bug (calls `database` getter which calls itself).
4. **No history view exists** — there is no way to review past entries within the app. The only way to see data is via the Excel export.

### What I found that the product owner didn't mention

1. The emotion system in `AddMealPage` is quite sophisticated — 18 preset emotions with a custom-text override that has "prevalence rules" (choosing custom clears presets and vice versa).
2. The exercise form includes therapeutic intention presets that distinguish between healthy motivations ("Benessere/Energia") and potentially concerning ones ("Bruciare/Rimediare al cibo", "Controllo/Punizione") — this is therapeutically meaningful design.
3. There are actually two different export systems in code: `ExcelService` (CSV, dead code) and `ExportTimelinePage` (xlsx, active). Only the xlsx one works.

---

## Step 3 — Future Roadmap Analysis

### Request 1: Persistenza locale dei dati

**Current state:** Meals and exercises persist via `TimelineStore` (JSON file). Therapy notes don't persist at all. Extra meals persist in SharedPreferences but are isolated.

**Gap:** Medium. The JSON-file approach works for meals/exercise, but:
- `TherapyNotePage._save()` must be connected to `TimelineStore`
- `AddExtraPage` should be migrated to `TimelineStore` or removed
- The dead `DatabaseService` / `StorageService` / `ExcelService` should be deleted to avoid confusion

**Recommendation:** Consolidate all persistence into `TimelineStore` as the single source of truth. Delete the three unused services. This is the prerequisite for everything else.

### Request 2: Storico settimanale interno

**Current state:** No history view exists. Zero screens for reviewing past data.

**Gap:** Large. This requires:
- A new page (e.g., `WeeklyHistoryPage`) accessible from home
- Week navigation (prev/next week)
- Grouped timeline view showing meals, exercise, and therapy notes in chronological order
- Visual distinction of Prima/Evento/Dopo phases
- Read access to `TimelineStore.events` filtered by date range

**Recommendation:** Build this after Request 1 (unified persistence). The `TimelineStore` already provides `List<Map<String, dynamic>> events` — add date filtering and build a scrollable grouped list. Consider using `TimelineEvent` model (currently dead code) or a similar typed wrapper to make rendering cleaner.

### Request 3: Evoluzione del tasto ESERCIZIO

**Current state:** `AddExercisePage` already captures:
- Exercise type + duration (objective)
- Intention before (4 therapeutic presets)
- Intensity + emotions + thought (before)
- Outcome (4 presets) + physical sensations + intensity + emotions + thought (after)

**Gap:** Small-to-medium. The exercise form is already therapeutically structured. The main gaps:
- No "During" section (the product owner asks for Prima/Durante/Dopo, current form has Prima+Esercizio/Dopo)
- Exercise data flows to `TimelineStore` and export already work
- The intention presets are therapeutically appropriate (includes warning-level items like "Bruciare / Rimediare al cibo")

**Recommendation:** This is closer to done than the product owner may think. Add a "Durante" section if the therapist wants data captured mid-exercise. Ensure all exercise fields appear properly in the weekly history view (Request 2) and export (Request 5).

### Request 4: Evoluzione del tasto TERAPIA / NOTE

**Current state:** `TherapyNotePage` is a free-text input that **doesn't save**.

**Gap:** Large (functionally broken). Requires:
- Connect `_save()` to `TimelineStore` with `type: 'therapy'`, date, and the note text
- No structural changes needed — the product owner explicitly says "scrittura completamente libera" and "nessuna trasformazione in compiti o moduli strutturati", which matches the current simple text field
- Notes must appear in timeline and export

**Recommendation:** Simplest fix of all five requests. Wire `_save()` to `TimelineStore.addEntry()` with the date and text content. Add a `type: 'Terapia/Note'` field so the export and history pages can recognize it.

### Request 5: Export dati (settimanale)

**Current state:** `ExportTimelinePage` exports ALL events as a single xlsx file. No date filtering. No weekly scoping.

**Gap:** Medium. Requires:
- Week selector (or auto-detect current week)
- Filter `TimelineStore.events` by week before generating the xlsx
- The export column structure is already good and extensible
- The `_pickAny` / `_pickPath` field resolution handles heterogeneous event types well

**Recommendation:** Add a week picker to `ExportTimelinePage`. The existing export logic is solid and already handles both meal and exercise event shapes. Once therapy notes are saved (Request 4), add a path resolution for therapy events. The product owner asks for "estendibile in futuro all'export mensile" — this naturally follows from parameterizing the date range filter.

### Suggested implementation order

1. **Request 1** (persistence) — prerequisite for everything; consolidate into `TimelineStore`, delete dead code
2. **Request 4** (therapy notes) — smallest change, high impact (currently broken)
3. **Request 3** (exercise evolution) — already mostly done, minor additions
4. **Request 2** (weekly history) — largest new feature, builds on unified persistence
5. **Request 5** (weekly export) — extends existing export with date filtering, natural companion to Request 2
