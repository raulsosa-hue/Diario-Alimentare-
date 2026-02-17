import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    await seedTestPastoIfEmpty();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diario_alimentare.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabella PASTI (1 riga = 1 record pasto = 1 blocco export Excel)
    await db.execute('''
    CREATE TABLE pasti (
      id INTEGER PRIMARY KEY AUTOINCREMENT,

      -- data/ora record
      data TEXT NOT NULL,              -- es: 2026-01-26
      ora_record TEXT NOT NULL,        -- es: 09:52

      -- tipo pasto
      tipo_pasto TEXT NOT NULL,        -- Colazione/Spuntino/Pranzo/Merenda/Cena/Pasti aggiuntivi

      -- CONTESO PRIMA (preset + testo libero eventuale)
      dove_sono TEXT,                 -- preset: casa/lavoro/macchina/in giro/...
      con_chi_sono TEXT,              -- preset: famiglia/da solo/amici/...

      -- PENSIERI / EMOZIONI PRIMA
      intensita_prima INTEGER DEFAULT 0,   -- 0..10
      pensieri_prima TEXT,                -- testo libero (se vuoi)
      e_felice_prima INTEGER DEFAULT 0,
      e_rilassato_prima INTEGER DEFAULT 0,
      e_motivato_prima INTEGER DEFAULT 0,
      e_triste_prima INTEGER DEFAULT 0,
      e_stressato_prima INTEGER DEFAULT 0,
      e_annoiato_prima INTEGER DEFAULT 0,
      e_ansioso_prima INTEGER DEFAULT 0,
      e_paura_prima INTEGER DEFAULT 0,
      e_altro_prima INTEGER DEFAULT 0,
      altro_prima_testo TEXT,

      -- PASTO (compilazione)
      ora_inizio TEXT,                 -- es: 12:30
      ora_fine TEXT,                   -- es: 13:05
      cosa_ho_mangiato TEXT,            -- testo libero
      note_pasto TEXT,

      -- DOPO IL PASTO
      sensazioni_fisiche_dopo TEXT,
      intensita_dopo INTEGER DEFAULT 0,     -- 0..10
      pensieri_dopo TEXT,
      e_felice_dopo INTEGER DEFAULT 0,
      e_rilassato_dopo INTEGER DEFAULT 0,
      e_motivato_dopo INTEGER DEFAULT 0,
      e_triste_dopo INTEGER DEFAULT 0,
      e_stressato_dopo INTEGER DEFAULT 0,
      e_annoiato_dopo INTEGER DEFAULT 0,
      e_ansioso_dopo INTEGER DEFAULT 0,
      e_paura_dopo INTEGER DEFAULT 0,
      e_altro_dopo INTEGER DEFAULT 0,
      altro_dopo_testo TEXT,

      -- FLAG (per Excel: sì/no)
      flag_contesto_prima_ok INTEGER DEFAULT 0,
      flag_pensieri_prima_ok INTEGER DEFAULT 0,
      flag_pasto_ok INTEGER DEFAULT 0,
      flag_dopo_pasto_ok INTEGER DEFAULT 0,

      -- gestione export
      esportato INTEGER DEFAULT 0,          -- 0=no 1=sì
      export_settimana TEXT                -- es: 2026-W05 (utile per export settimanale)
    );
  ''');

    // (Opzionale ma utile) indice per ricerche e export
    await db.execute('CREATE INDEX idx_pasti_data ON pasti (data);');
  }

  Future<void> seedTestPastoIfEmpty() async {
    final db = await database;

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM pasti'),
    ) ?? 0;

    if (count == 0) {
      final now = DateTime.now();
      final data =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final ora =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      await db.insert('pasti', {
        'data': data,
        'ora_record': ora,
        'tipo_pasto': 'Colazione',
        'dove_sono': 'casa',
        'con_chi_sono': 'famiglia',
        'pensieri_prima': 'Test automatico',
        'flag_contesto_prima_ok': 1,
        'flag_pensieri_prima_ok': 1,
        'flag_pasto_ok': 1,
        'flag_dopo_pasto_ok': 1,
        'esportato': 0,
      });

      print("✅ TEST: pasto inserito");
    }
  }
}
