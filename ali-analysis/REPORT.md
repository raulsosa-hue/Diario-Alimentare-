# Report di Analisi del Codebase

Data: 2026-02-17
Branch: `new-setup-and-analysis` (basato su `main` @ 7c45bd4)

---

## Step 1 — Analisi del Codice

### Panoramica del progetto

App Flutter per iOS — un diario alimentare terapeutico ("Diario Alimentare") che registra pasti, esercizio fisico e note terapeutiche. Scritta in Dart, destinata esclusivamente a iOS.

### Struttura dei file (13 file Dart)

```
lib/
  main.dart                          # Entry point dell'app + tema
  models/
    entry.dart                       # Modello DiaryEntry (piatto, per pasti "extra")
    timeline_event.dart              # Modello TimelineEvent (basato su fasi, inutilizzato)
  pages/
    home_page.dart                   # Schermata home — 4 pulsanti circolari (griglia 2x2)
    add_meal_page.dart               # Form pasto principale (Prima/Pasto/Dopo)
    add_exercise_page.dart           # Form esercizio (Prima/Durante/Dopo)
    add_extra_page.dart              # Form "pasto extra" (piu semplice, modello piatto)
    therapy_note_page.dart           # Pagina nota a testo libero
    export_excel_page.dart           # Export timeline in .xlsx
  services/
    database_service.dart            # DB SQLite (sqflite) — solo schema, non usato dalla UI
    excel_service.dart               # Export CSV da lista DiaryEntry (non usato dalla UI)
    storage_service.dart             # Persistenza SharedPreferences per DiaryEntry
    timeline_store.dart              # Persistenza su file JSON per eventi timeline
```

### Architettura e flusso dati

**Esistono tre sistemi di persistenza separati e non collegati tra loro:**

| Servizio | Storage | Usato da | Modello |
|----------|---------|----------|---------|
| `TimelineStore` | File JSON (`timeline_events.json`) | `AddMealPage`, `AddExercisePage`, `ExportTimelinePage` | `Map<String, dynamic>` grezzo |
| `StorageService` | SharedPreferences | `AddExtraPage` | `DiaryEntry` |
| `DatabaseService` | SQLite (`diario_alimentare.db`) | **Niente** (codice morto) | Schema SQL |

Le pagine pasto principale e esercizio salvano su `TimelineStore` (file JSON). La pagina "pasto extra" salva su `StorageService` (SharedPreferences). Il database SQLite e definito ma mai chiamato da alcuna UI. Anche `ExcelService` (export CSV) e codice morto — l'export attivo usa `ExportTimelinePage` che legge da `TimelineStore` e scrive `.xlsx` tramite il pacchetto `excel`.

**Riepilogo codice morto:**
- `DatabaseService` — intera classe inutilizzata
- `ExcelService` — intera classe inutilizzata
- Modello `TimelineEvent` — mai istanziato
- Modello `DiaryEntry` — usato solo da `AddExtraPage` + `StorageService`

### Schermata home

Quattro pulsanti circolari in una griglia 2x2:
1. **Pasto** -> `AddMealPage`
2. **Esercizio Fisico** -> `AddExercisePage`
3. **Terapia / Note** -> `TherapyNotePage`
4. **Esporta Diario in EXCEL (CSV)** -> `ExportTimelinePage`

Nessuna navigazione verso lo storico, nessuna vista settimanale, nessuna impostazione.

### AddMealPage (form principale, ~777 righe)

Strutturato in tre sezioni che rispecchiano il modello Prima/Evento/Dopo:
- **Prima del pasto**: dove, con chi, sensazioni fisiche, slider intensita emotiva (0-10), selettore emozioni (18 emozioni preset con emoji + testo personalizzato), pensiero
- **Pasto**: dropdown tipo pasto (6 tipi), ora inizio, ora fine, cosa ho mangiato
- **Dopo il pasto**: sensazioni fisiche, slider intensita emotiva, selettore emozioni, pensiero

Salva una `Map<String, dynamic>` annidata su `TimelineStore`. Il sistema emozioni ha una "regola di prevalenza" — se viene inserito testo personalizzato, le selezioni emoji preset vengono cancellate (e viceversa).

### AddExercisePage (~897 righe)

Strutturato in modo simile:
- **Esercizio**: tipo esercizio (10 preset + personalizzato), durata (stepper, incrementi di 5 min)
- **Intenzione (prima)**: 4 preset di intenzione (benessere, gestione emozioni, bruciare/compensare, controllo/punizione), slider intensita, emozioni, pensiero
- **Esito (dopo)**: 4 preset esito, sensazioni fisiche, slider intensita, emozioni, pensiero

Anche questo salva su `TimelineStore`.

### AddExtraPage (~190 righe)

Form piatto piu semplice (dropdown categoria, cosa, dove, con chi, umore, note). Usa il modello `DiaryEntry` + `StorageService` (SharedPreferences). **Questi dati sono completamente invisibili alla pagina export** poiche l'export legge da `TimelineStore`, non da `StorageService`.

### TherapyNotePage (~172 righe)

Input a testo libero con pulsante "Salva". **Il salvataggio non fa nulla** — mostra solo una SnackBar con "Salvato" ma non persiste il testo in alcun modo. Il metodo `_save()` ha un commento: "Per ora: conferma visiva. (Salvataggio vero lo facciamo dopo, se vuoi)".

### ExportTimelinePage (~313 righe)

Legge tutti gli eventi da `TimelineStore`, genera un file Excel `.xlsx` con colonne: Data, Ora, Tipo evento, Categoria, Intenzione, Emozioni, Intensita emotiva, Sensazioni fisiche, Pensiero, Esito/Dopo, Note libere. Usa `share_plus` per condividere il file tramite il foglio di condivisione iOS.

Ha una logica robusta di risoluzione campi (`_pickAny` / `_pickPath`) che prova percorsi multipli per estrarre dati dalle mappe eterogenee degli eventi.

### Problemi di qualita del codice

1. **Tre sistemi di persistenza che non comunicano tra loro** — frammentazione architetturale
2. **Codice morto**: `DatabaseService`, `ExcelService`, modello `TimelineEvent` sono tutti inutilizzati
3. **TherapyNotePage non salva** — l'utente vede "Salvato" ma nulla viene persistito
4. **I dati di AddExtraPage sono isolati** — salvati in SharedPreferences, invisibili all'export
5. **Indentazione inconsistente** in tutto il codice (mix di 0-indent e 2-indent dentro le classi)
6. **Commenti in italiano con apostrofi non escaped** causano errori di sintassi Dart in diversi file (`dell'app`, `d'animo`, `un'emozione`, `l'intensita`, `l'esercizio`)
7. **Bug import case-sensitive**: `Timeline_store.dart` vs il file effettivo `timeline_store.dart`
8. **`database_service.dart`**: metodi fuori dal corpo della classe (manca parentesi graffa di chiusura), colonna `data_record` non corrisponde alla colonna `data` dello schema, `seedTestPastoIfEmpty` chiama il getter `database` ricorsivamente (rischio loop infinito)
9. **Nessuna gestione errori** sull'I/O file di TimelineStore
10. **`withOpacity` deprecato** — usato estensivamente nelle pagine esercizio, home e terapia

### Dipendenze

- `flutter` (SDK)
- `shared_preferences` — usato solo da `AddExtraPage`
- `path_provider` — usato da `TimelineStore` e `ExcelService`
- `excel` — usato da `ExportTimelinePage`
- `share_plus` — usato da `ExportTimelinePage`
- `sqflite` + `path` — usati solo dal `DatabaseService` morto

---

## Step 2 — Confronto con la Descrizione del Product Owner

### Verifica claim per claim

| Claim | Realta | Stato |
|-------|--------|-------|
| App solo iOS | Corretto. Solo configurazione build iOS utilizzata. | Confermato |
| Offline-first, dati salvati localmente | Parzialmente vero. `TimelineStore` salva su file JSON. Ma `TherapyNotePage` non salva affatto, e `AddExtraPage` salva in un silo separato. | Parziale |
| Nessun backend, nessun cloud | Corretto. Nessun codice di rete presente. | Confermato |
| Registra Pasti | Si, `AddMealPage` funziona e salva su `TimelineStore`. | Confermato |
| Registra Esercizio fisico | Si, `AddExercisePage` funziona e salva su `TimelineStore`. | Confermato |
| Registra Terapia / Note | **No.** `TherapyNotePage` ha la UI ma `_save()` non persiste nulla. | Non funzionante |
| Struttura Prima / Evento / Dopo | Si per i pasti (Prima/Pasto/Dopo) e l'esercizio (Intenzione+prima/Esercizio/Esito+dopo). | Confermato |
| Dati: emozioni, intensita emotiva | Si — selettori emozioni e slider intensita in entrambi i form pasto e esercizio. | Confermato |
| Dati: sensazioni fisiche | Si — campi testo per sensazioni fisiche in entrambi i form. | Confermato |
| Dati: pensieri | Si — campi testo pensiero nelle sezioni Prima e Dopo. | Confermato |
| Dati: intenzione | Solo nel form esercizio (4 preset). Non nel form pasto. | Parziale |
| Export in Excel come timeline | Si, `ExportTimelinePage` genera `.xlsx` con colonne timeline. | Confermato |

### Cosa il product owner potrebbe non sapere o ha tralasciato

1. **Le note terapeutiche hanno un salvataggio finto** — la UI conferma il salvataggio ma nulla viene persistito. Se l'app viene usata a supporto terapeutico, qualsiasi nota inserita va persa alla chiusura dell'app.
2. **I dati dei "pasti extra" sono isolati** — `AddExtraPage` esiste nel codice (e `AddMealPage` ha un'opzione "Pasti aggiuntivi" nel dropdown) ma `AddExtraPage` salva su un sistema di storage completamente diverso. I suoi dati non compaiono mai nell'export timeline.
3. **Il database SQLite e predisposto ma non collegato** — c'e uno schema SQL completo per `pasti` con 30+ colonne che rispecchia la struttura del form pasto, ma nessun codice UI lo utilizza. Il metodo `seedTestPastoIfEmpty` ha un bug di ricorsione infinita (chiama il getter `database` che richiama se stesso).
4. **Non esiste alcuna vista storico** — non c'e modo di rivedere le voci passate dentro l'app. L'unico modo per vedere i dati e tramite l'export Excel.

### Cosa ho trovato che il product owner non ha menzionato

1. Il sistema emozioni in `AddMealPage` e piuttosto sofisticato — 18 emozioni preset con override testo personalizzato che ha "regole di prevalenza" (scegliere il personalizzato cancella i preset e viceversa).
2. Il form esercizio include preset di intenzione terapeutica che distinguono tra motivazioni sane ("Benessere/Energia") e potenzialmente preoccupanti ("Bruciare/Rimediare al cibo", "Controllo/Punizione") — questo e un design terapeuticamente significativo.
3. Esistono in realta due sistemi di export diversi nel codice: `ExcelService` (CSV, codice morto) e `ExportTimelinePage` (xlsx, attivo). Solo quello xlsx funziona.

---

## Step 3 — Analisi Roadmap Futura

### Richiesta 1: Persistenza locale dei dati

**Stato attuale:** Pasti ed esercizi persistono tramite `TimelineStore` (file JSON). Le note terapeutiche non persistono affatto. I pasti extra persistono in SharedPreferences ma sono isolati.

**Gap:** Medio. L'approccio file JSON funziona per pasti/esercizio, ma:
- `TherapyNotePage._save()` deve essere collegato a `TimelineStore`
- `AddExtraPage` dovrebbe essere migrato a `TimelineStore` o rimosso
- I servizi morti `DatabaseService` / `StorageService` / `ExcelService` dovrebbero essere eliminati per evitare confusione

**Raccomandazione:** Consolidare tutta la persistenza in `TimelineStore` come unica fonte di verita. Eliminare i tre servizi inutilizzati. Questo e il prerequisito per tutto il resto.

### Richiesta 2: Storico settimanale interno

**Stato attuale:** Non esiste alcuna vista storico. Zero schermate per rivedere i dati passati.

**Gap:** Grande. Richiede:
- Una nuova pagina (es. `WeeklyHistoryPage`) accessibile dalla home
- Navigazione per settimana (settimana precedente/successiva)
- Vista timeline raggruppata che mostri pasti, esercizio e note terapeutiche in ordine cronologico
- Distinzione visiva delle fasi Prima/Evento/Dopo
- Accesso in lettura a `TimelineStore.events` filtrato per intervallo di date

**Raccomandazione:** Costruire dopo la Richiesta 1 (persistenza unificata). Il `TimelineStore` fornisce gia `List<Map<String, dynamic>> events` — aggiungere filtro per data e costruire una lista raggruppata scorrevole. Considerare l'uso del modello `TimelineEvent` (attualmente codice morto) o un wrapper tipizzato simile per rendere il rendering piu pulito.

### Richiesta 3: Evoluzione del tasto ESERCIZIO

**Stato attuale:** `AddExercisePage` cattura gia:
- Tipo esercizio + durata (oggettivo)
- Intenzione prima (4 preset terapeutici)
- Intensita + emozioni + pensiero (prima)
- Esito (4 preset) + sensazioni fisiche + intensita + emozioni + pensiero (dopo)

**Gap:** Piccolo-medio. Il form esercizio e gia strutturato terapeuticamente. Le lacune principali:
- Nessuna sezione "Durante" (il product owner chiede Prima/Durante/Dopo, il form attuale ha Prima+Esercizio/Dopo)
- Il flusso dati esercizio verso `TimelineStore` e l'export funzionano gia
- I preset di intenzione sono terapeuticamente appropriati (include elementi di avvertimento come "Bruciare / Rimediare al cibo")

**Raccomandazione:** E piu vicino al completamento di quanto il product owner possa pensare. Aggiungere una sezione "Durante" se il terapeuta vuole dati catturati durante l'esercizio. Assicurarsi che tutti i campi esercizio compaiano correttamente nella vista storico settimanale (Richiesta 2) e nell'export (Richiesta 5).

### Richiesta 4: Evoluzione del tasto TERAPIA / NOTE

**Stato attuale:** `TherapyNotePage` e un input a testo libero che **non salva**.

**Gap:** Grande (funzionalmente rotto). Richiede:
- Collegare `_save()` a `TimelineStore` con `type: 'therapy'`, data e testo della nota
- Nessuna modifica strutturale necessaria — il product owner dice esplicitamente "scrittura completamente libera" e "nessuna trasformazione in compiti o moduli strutturati", che corrisponde all'attuale semplice campo di testo
- Le note devono comparire nella timeline e nell'export

**Raccomandazione:** La correzione piu semplice tra tutte e cinque le richieste. Collegare `_save()` a `TimelineStore.addEntry()` con data e contenuto testuale. Aggiungere un campo `type: 'Terapia/Note'` in modo che le pagine export e storico possano riconoscerlo.

### Richiesta 5: Export dati (settimanale)

**Stato attuale:** `ExportTimelinePage` esporta TUTTI gli eventi come singolo file xlsx. Nessun filtro per data. Nessun ambito settimanale.

**Gap:** Medio. Richiede:
- Selettore settimana (o auto-detect settimana corrente)
- Filtrare `TimelineStore.events` per settimana prima di generare l'xlsx
- La struttura delle colonne export e gia buona e estendibile
- La risoluzione campi `_pickAny` / `_pickPath` gestisce bene i tipi di eventi eterogenei

**Raccomandazione:** Aggiungere un selettore settimana a `ExportTimelinePage`. La logica export esistente e solida e gestisce gia sia gli eventi pasto che esercizio. Una volta che le note terapeutiche vengono salvate (Richiesta 4), aggiungere una risoluzione percorso per gli eventi terapia. Il product owner chiede "estendibile in futuro all'export mensile" — questo segue naturalmente dalla parametrizzazione del filtro intervallo date.

### Ordine di implementazione suggerito

1. **Richiesta 1** (persistenza) — prerequisito per tutto il resto; consolidare in `TimelineStore`, eliminare codice morto
2. **Richiesta 4** (note terapia) — modifica piu piccola, alto impatto (attualmente rotto)
3. **Richiesta 3** (evoluzione esercizio) — gia quasi completato, aggiunte minori
4. **Richiesta 2** (storico settimanale) — nuova funzionalita piu grande, si basa sulla persistenza unificata
5. **Richiesta 5** (export settimanale) — estende l'export esistente con filtro date, compagno naturale della Richiesta 2
