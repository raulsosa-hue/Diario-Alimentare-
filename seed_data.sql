-- Seed data for diario_alimentare.db
-- Simulates ~6 months of usage (Sep 2025 - Mar 2026)
-- Mix of: empty weeks, meals-only, exercises-only, both, full/partial records

-- Clear existing data
DELETE FROM meals;
DELETE FROM exercises;

-- ============================================================
-- WEEK 1: Sep 22-28, 2025 — First week, just 2 meals, minimal data
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-09-23T06:30:00.000Z', 'Colazione', '08:30', '08:45', 'Caffè e biscotti', '2025-09-23T06:35:00.000Z', '2025-09-23T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, created_at, updated_at)
VALUES ('2025-09-25T11:00:00.000Z', 'Pranzo', '13:00', '13:30', '2025-09-25T11:05:00.000Z', '2025-09-25T11:05:00.000Z');

-- ============================================================
-- WEEK 2: Sep 29 - Oct 5 — Learning the app, partial data
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, created_at, updated_at)
VALUES ('2025-09-29T06:00:00.000Z', 'Colazione', '08:00', '08:20', 'Yogurt con muesli e frutta', 'Casa', '2025-09-29T06:25:00.000Z', '2025-09-29T06:25:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-09-30T11:30:00.000Z', 'Pranzo', '13:00', '13:45', 'Pasta al pomodoro, insalata mista', 4, '😰 Ansia', '2025-09-30T11:35:00.000Z', '2025-09-30T11:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, created_at, updated_at)
VALUES ('2025-10-01T17:00:00.000Z', 'Cena', '19:00', '19:40', 'Pollo alla griglia con verdure', 'Casa', 'Famiglia', '2025-10-01T17:05:00.000Z', '2025-10-01T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, created_at, updated_at)
VALUES ('2025-10-03T14:00:00.000Z', 'Merenda', '16:00', '16:10', '2025-10-03T14:05:00.000Z', '2025-10-03T14:05:00.000Z');

-- ============================================================
-- WEEK 3: Oct 6-12 — EMPTY (forgot to use app)
-- ============================================================

-- ============================================================
-- WEEK 4: Oct 13-19 — 5 meals + 1 exercise, some full records
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-10-13T06:00:00.000Z', 'Colazione', '08:00', '08:25',
  'Pane tostato con marmellata, latte', 'Casa', 'Da solo/a',
  'Leggera fame', 3, '🧘 Calma', 'Giornata tranquilla',
  'Sazio/a ma leggero/a', 2, '😊 Gioia', 'Buon inizio di giornata',
  '2025-10-13T06:30:00.000Z', '2025-10-13T06:30:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-10-13T11:00:00.000Z', 'Pranzo', '13:00', '13:30', 'Risotto ai funghi', '2025-10-13T11:35:00.000Z', '2025-10-13T11:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-10-15T17:00:00.000Z', 'Cena', '19:00', '19:50',
  'Pizza margherita e birra', 'Ristorante',
  5, '😊 Gioia',
  'Molto pieno/a', 3, '😔 Colpa / Rimorso',
  '2025-10-15T17:55:00.000Z', '2025-10-15T17:55:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-10-17T06:00:00.000Z', 'Colazione', '08:00', '08:15', 'Cornetto e cappuccino', '2025-10-17T06:20:00.000Z', '2025-10-17T06:20:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-10-19T11:30:00.000Z', 'Pranzo', '13:30', '14:15',
  'Lasagne della nonna, insalata, tiramisù', 'Casa dei nonni', 'Famiglia',
  2, '😊 Gioia',
  '2025-10-19T11:35:00.000Z', '2025-10-19T11:35:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-10-14T16:00:00.000Z', '🚶‍♂️ Camminata', 30,
  '✅ Benessere / Energia', 2, '🧘 Calma',
  '2025-10-14T16:35:00.000Z', '2025-10-14T16:35:00.000Z');

-- ============================================================
-- WEEK 5: Oct 20-26 — 4 meals + 2 exercises, mix full/partial
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-10-20T06:00:00.000Z', 'Colazione', '08:00', '08:30',
  'Pancakes con miele e frutta fresca', 'Casa',
  'Molta fame, stomaco che brontola', 5, '😰 Ansia', 'Devo mangiare subito',
  'Piacevolmente sazio/a', 2, '😊 Gioia',
  '2025-10-20T06:35:00.000Z', '2025-10-20T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-10-21T11:00:00.000Z', 'Pranzo', '13:00', '13:20', 'Insalata di riso', '2025-10-21T11:25:00.000Z', '2025-10-21T11:25:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-10-23T17:30:00.000Z', 'Cena', '19:30', '20:30',
  'Sushi assortito, edamame, gyoza', 'Ristorante giapponese', 'Amici',
  3, '😊 Gioia',
  4, '😊 Gioia', 'Serata bellissima con gli amici',
  '2025-10-23T17:35:00.000Z', '2025-10-23T17:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-10-25T09:00:00.000Z', 'Spuntino', '11:00', '11:10', 'Mela e noci', '2025-10-25T09:15:00.000Z', '2025-10-25T09:15:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-10-22T07:00:00.000Z', '🏃 Corsa / Running', 45,
  '✅ Benessere / Energia', 4, '😤 Frustrazione',
  '✅ Più libero / leggero', 'Stanchezza piacevole, muscoli caldi',
  2, '😊 Gioia', 'Mi sento molto meglio dopo la corsa',
  '2025-10-22T07:50:00.000Z', '2025-10-22T07:50:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, created_at, updated_at)
VALUES ('2025-10-24T16:00:00.000Z', '🚶‍♂️ Camminata', 20,
  '2025-10-24T16:25:00.000Z', '2025-10-24T16:25:00.000Z');

-- ============================================================
-- WEEK 6: Oct 27 - Nov 2 — Only exercises (3), no meals
-- ============================================================

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-10-27T07:00:00.000Z', '🏋️ Palestra / Pesi', 60,
  '✅ Benessere / Energia', 3, '😐 Apatia', 'Non ho voglia ma ci vado',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2025-10-27T08:05:00.000Z', '2025-10-27T08:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, created_at, updated_at)
VALUES ('2025-10-29T16:30:00.000Z', '🧘 Stretching / Mobilità', 25,
  '🧠 Gestire emozioni / Stress',
  '2025-10-29T17:00:00.000Z', '2025-10-29T17:00:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-01T08:00:00.000Z', '🏃 Corsa / Running', 35,
  '🧠 Gestire emozioni / Stress', 6, '😰 Ansia',
  '✅ Più libero / leggero', 'Respiro più calmo, corpo rilassato',
  3, '🧘 Calma',
  '2025-11-01T08:40:00.000Z', '2025-11-01T08:40:00.000Z');

-- ============================================================
-- WEEK 7: Nov 3-9 — EMPTY
-- ============================================================

-- ============================================================
-- WEEK 8: Nov 10-16 — Rich week, 8 meals + 3 exercises, mostly full
-- ============================================================

-- Monday breakfast
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-11-10T06:30:00.000Z', 'Colazione', '07:30', '07:55',
  'Fette biscottate con burro e marmellata, caffè', 'Casa', 'Da solo/a',
  'Fame normale', 2, '🧘 Calma', 'Giornata di lavoro, nulla di speciale',
  'Sazio/a', 1, '🧘 Calma', 'Pronto/a per la giornata',
  '2025-11-10T07:00:00.000Z', '2025-11-10T07:00:00.000Z');

-- Monday lunch
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-10T11:30:00.000Z', 'Pranzo', '12:30', '13:00',
  'Piadina con prosciutto e mozzarella, frutta', 'Ufficio', 'Colleghi',
  3, '😊 Gioia',
  'Soddisfatto/a', 2, '😊 Gioia',
  '2025-11-10T11:35:00.000Z', '2025-11-10T11:35:00.000Z');

-- Tuesday lunch
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-11-11T11:00:00.000Z', 'Pranzo', '13:00', '13:25',
  'Minestrone con crostini', 'Ufficio',
  4, '😢 Tristezza',
  '2025-11-11T11:30:00.000Z', '2025-11-11T11:30:00.000Z');

-- Wednesday breakfast
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, body_sensations_before, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-12T06:00:00.000Z', 'Colazione', '07:00', '07:20',
  'Cereali con latte, banana', 'Casa',
  'Stanchezza, poco appetito', 5, '😰 Ansia',
  'Leggera nausea', 4, '😰 Ansia',
  '2025-11-12T06:25:00.000Z', '2025-11-12T06:25:00.000Z');

-- Wednesday dinner
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-11-12T18:00:00.000Z', 'Cena', '19:00', '20:00',
  'Pasta carbonara, vino rosso, panna cotta', 'Ristorante', 'Partner',
  'Fame intensa', 6, '😢 Tristezza', 'Giornata difficile, ho bisogno di staccare',
  'Troppo pieno/a, pesantezza', 5, '😔 Colpa / Rimorso', 'Ho mangiato troppo ma ne avevo bisogno',
  '2025-11-12T18:05:00.000Z', '2025-11-12T18:05:00.000Z');

-- Thursday snack
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, emotional_intensity_before, created_at, updated_at)
VALUES ('2025-11-13T09:30:00.000Z', 'Spuntino', '10:30', '10:40',
  'Crackers e formaggio', 2,
  '2025-11-13T09:35:00.000Z', '2025-11-13T09:35:00.000Z');

-- Friday lunch
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-14T11:30:00.000Z', 'Pranzo', '13:00', '14:00',
  'Tagliatelle al ragù, contorno di spinaci', 'Mensa aziendale', 'Colleghi',
  3, '🧘 Calma',
  2, '😊 Gioia',
  '2025-11-14T11:35:00.000Z', '2025-11-14T11:35:00.000Z');

-- Sunday brunch
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-11-16T09:00:00.000Z', 'Colazione', '10:00', '11:00',
  'Uova strapazzate, avocado toast, succo d''arancia, croissant', 'Brunch bar', 'Amici',
  'Rilassato/a, leggera fame', 2, '😊 Gioia', 'Finalmente weekend!',
  'Sazio/a e contento/a', 1, '😊 Gioia', 'Bellissima mattinata',
  '2025-11-16T09:05:00.000Z', '2025-11-16T09:05:00.000Z');

-- Exercises for week 8
INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-11-10T16:30:00.000Z', '🚶‍♂️ Camminata', 40,
  '✅ Benessere / Energia', 3, '🧘 Calma', 'Passeggiata dopo il lavoro',
  '✅ Più libero / leggero', 'Gambe leggere, mente serena',
  1, '🧘 Calma', 'Fa bene stare all''aria aperta',
  '2025-11-10T17:15:00.000Z', '2025-11-10T17:15:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-13T07:00:00.000Z', '🏃 Corsa / Running', 30,
  '🧠 Gestire emozioni / Stress', 5, '😤 Frustrazione',
  '✅ Più libero / leggero',
  2, '😊 Gioia',
  '2025-11-13T07:35:00.000Z', '2025-11-13T07:35:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-15T09:00:00.000Z', '🧘‍♂️ Yoga / Pilates', 50,
  '🧠 Gestire emozioni / Stress', 4, '😰 Ansia',
  '✅ Più libero / leggero', 'Corpo disteso, respiro profondo',
  1, '🧘 Calma',
  '2025-11-15T09:55:00.000Z', '2025-11-15T09:55:00.000Z');

-- ============================================================
-- WEEK 9: Nov 17-23 — 4 meals, partial data
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-11-17T06:30:00.000Z', 'Colazione', '07:30', '07:45', 'Caffè e brioche', '2025-11-17T06:35:00.000Z', '2025-11-17T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, created_at, updated_at)
VALUES ('2025-11-18T11:00:00.000Z', 'Pranzo', '13:00', '13:30', 'Panino con tonno e pomodoro', 'Ufficio', '2025-11-18T11:35:00.000Z', '2025-11-18T11:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-11-20T17:00:00.000Z', 'Cena', '19:00', '19:30', 'Zuppa di lenticchie con pane', 3, '😢 Tristezza', '2025-11-20T17:05:00.000Z', '2025-11-20T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-11-22T14:00:00.000Z', 'Merenda', '16:00', '16:15', 'Cioccolata calda e biscotti', '2025-11-22T14:20:00.000Z', '2025-11-22T14:20:00.000Z');

-- ============================================================
-- WEEK 10: Nov 24-30 — Only meals (5), no exercises
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-24T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Porridge con miele e cannella', 'Casa', 'Da solo/a',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2025-11-24T06:35:00.000Z', '2025-11-24T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, created_at, updated_at)
VALUES ('2025-11-25T11:00:00.000Z', 'Pranzo', '12:30', '13:00', 'Pasta e fagioli', 'Casa', '2025-11-25T11:05:00.000Z', '2025-11-25T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-11-27T17:30:00.000Z', 'Cena', '19:30', '21:00',
  'Arrosto con patate, verdure grigliate, torta di mele', 'Casa', 'Famiglia allargata',
  'Leggera tensione', 4, '😰 Ansia', 'Cena di famiglia, spero vada bene',
  'Molto pieno/a ma soddisfatto/a', 3, '😊 Gioia', 'Alla fine è stata una bella serata',
  '2025-11-27T17:35:00.000Z', '2025-11-27T17:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-11-28T06:00:00.000Z', 'Colazione', '08:00', '08:15', 'Avanzi della torta di mele, caffè', '2025-11-28T06:20:00.000Z', '2025-11-28T06:20:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-11-30T11:00:00.000Z', 'Pranzo', '13:00', '13:45',
  'Polenta con funghi e salsiccia', 'Casa',
  3, '😌 Orgoglio', 2, '😊 Gioia',
  '2025-11-30T11:05:00.000Z', '2025-11-30T11:05:00.000Z');

-- ============================================================
-- WEEK 11: Dec 1-7 — 3 meals + 2 exercises
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-12-01T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Pane con nutella, latte caldo', 'Casa',
  3, '😐 Apatia',
  '2025-12-01T06:35:00.000Z', '2025-12-01T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-03T11:00:00.000Z', 'Pranzo', '13:00', '13:45',
  'Gnocchi al pesto, verdure al vapore', 'Trattoria', 'Colleghi',
  'Fame intensa', 5, '😤 Frustrazione',
  'Sazio/a e più calmo/a', 2, '🧘 Calma',
  '2025-12-03T11:05:00.000Z', '2025-12-03T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-12-05T17:00:00.000Z', 'Cena', '19:00', '19:30', 'Minestrone', '2025-12-05T17:05:00.000Z', '2025-12-05T17:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-02T07:00:00.000Z', '🏋️ Palestra / Pesi', 50,
  '✅ Benessere / Energia', 3, '🧘 Calma',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2025-12-02T07:55:00.000Z', '2025-12-02T07:55:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-12-06T09:00:00.000Z', '🚴 Bici', 60,
  '✅ Benessere / Energia', 2, '😊 Gioia', 'Bella giornata per pedalare',
  '✅ Più libero / leggero', 'Gambe stanche ma energizzato/a',
  1, '😊 Gioia', 'Bellissimo giro in bici',
  '2025-12-06T10:05:00.000Z', '2025-12-06T10:05:00.000Z');

-- ============================================================
-- WEEK 12: Dec 8-14 — EMPTY
-- ============================================================

-- ============================================================
-- WEEK 13: Dec 15-21 — Christmas prep, 6 meals (lots of food)
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, created_at, updated_at)
VALUES ('2025-12-15T06:30:00.000Z', 'Colazione', '07:30', '07:50', 'Pandoro con caffè', 'Casa', '2025-12-15T06:35:00.000Z', '2025-12-15T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2025-12-16T11:00:00.000Z', 'Pranzo', '13:00', '13:40',
  'Tortellini in brodo, cotoletta', 'Casa',
  4, '😰 Ansia',
  '2025-12-16T11:05:00.000Z', '2025-12-16T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-12-17T17:00:00.000Z', 'Cena', '19:30', '21:30',
  'Aperitivo con stuzzichini, bruschette, arancini, olive ascolane, spritz', 'Bar del centro', 'Amici',
  'Nervosismo, stomaco chiuso', 6, '😰 Ansia', 'Cena di Natale con amici, devo essere socievole',
  'Gonfiore, troppo pieno/a', 5, '😔 Colpa / Rimorso', 'Ho esagerato con gli stuzzichini',
  '2025-12-17T17:05:00.000Z', '2025-12-17T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2025-12-18T14:00:00.000Z', 'Merenda', '16:00', '16:15', 'Panettone e cioccolata', '2025-12-18T14:20:00.000Z', '2025-12-18T14:20:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-20T11:00:00.000Z', 'Pranzo', '13:00', '14:00',
  'Pasta al forno, fritto misto, pandoro', 'Casa colleghi', 'Colleghi',
  3, '😊 Gioia', 4, '😊 Gioia',
  '2025-12-20T11:05:00.000Z', '2025-12-20T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-21T17:00:00.000Z', 'Cena', '19:00', '19:45',
  'Vellutata di zucca, pane integrale', 'Casa',
  5, '😔 Colpa / Rimorso',
  'Leggero/a, bene', 2, '🧘 Calma',
  '2025-12-21T17:05:00.000Z', '2025-12-21T17:05:00.000Z');

-- ============================================================
-- WEEK 14: Dec 22-28 — Christmas week, many meals, 1 exercise
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-24T11:00:00.000Z', 'Pranzo', '13:00', '15:00',
  'Antipasti misti, lasagne, arrosto con patate, insalata russa, panettone, frutta secca', 'Casa dei nonni', 'Tutta la famiglia',
  'Fame normale, un po'' emozionato/a', 4, '😊 Gioia',
  'Molto pieno/a, pesantezza', 3, '😊 Gioia',
  '2025-12-24T11:05:00.000Z', '2025-12-24T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-12-25T11:00:00.000Z', 'Pranzo', '12:30', '15:30',
  'Cappelletti in brodo, bollito misto, purè, verdure, pandoro, torrone, frutta', 'Casa', 'Famiglia',
  'Ancora pieno/a da ieri', 5, '❤️ Fame d''amore', 'Il pranzo di Natale è un momento speciale',
  'Pienezza estrema, sonnolenza', 6, '😔 Colpa / Rimorso', 'Ho mangiato tantissimo ma era tutto buonissimo',
  '2025-12-25T11:05:00.000Z', '2025-12-25T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, created_at, updated_at)
VALUES ('2025-12-25T17:00:00.000Z', 'Cena', '20:00', '20:30',
  'Avanzi del pranzo, un po'' di tutto', 'Casa', 4,
  '2025-12-25T17:05:00.000Z', '2025-12-25T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-26T06:00:00.000Z', 'Colazione', '08:00', '08:20',
  'Solo caffè', 'Casa',
  3, '🤢 Disgusto',
  'Stomaco ancora pesante', 3, '😐 Apatia',
  '2025-12-26T06:05:00.000Z', '2025-12-26T06:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, created_at, updated_at)
VALUES ('2025-12-27T11:00:00.000Z', 'Pranzo', '13:00', '13:30', 'Insalata leggera, petto di pollo', 'Casa', '2025-12-27T11:05:00.000Z', '2025-12-27T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-28T17:00:00.000Z', 'Cena', '19:30', '20:30',
  'Pesce al forno con verdure, vino bianco', 'Ristorante', 'Partner',
  3, '😊 Gioia', 2, '😊 Gioia',
  '2025-12-28T17:05:00.000Z', '2025-12-28T17:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2025-12-27T09:00:00.000Z', '🚶‍♂️ Camminata', 60,
  '⚠️ Bruciare / Rimediare al cibo', 6, '😔 Colpa / Rimorso', 'Devo smaltire le abbuffate di Natale',
  '✅ Più libero / leggero', 'Gambe pesanti ma mente più serena',
  3, '🧘 Calma', 'Almeno ho fatto qualcosa',
  '2025-12-27T10:05:00.000Z', '2025-12-27T10:05:00.000Z');

-- ============================================================
-- WEEK 15: Dec 29 - Jan 4 — New Year, mix of meals and exercises
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2025-12-31T17:00:00.000Z', 'Cena', '20:00', '23:30',
  'Cotechino con lenticchie, antipasti vari, spumante, pandoro', 'Casa di amici', 'Amici',
  5, '😊 Gioia', 4, '😊 Gioia',
  '2025-12-31T17:05:00.000Z', '2025-12-31T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, body_sensations_before, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-01-01T10:00:00.000Z', 'Colazione', '12:00', '12:20',
  'Cornetto e caffè', 'Bar',
  'Mal di testa, nausea', 6, '🤢 Disgusto',
  '2026-01-01T10:05:00.000Z', '2026-01-01T10:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-02T11:00:00.000Z', 'Pranzo', '13:00', '13:30',
  'Brodo vegetale, riso in bianco', 'Casa',
  2, '🧘 Calma', 1, '🧘 Calma',
  '2026-01-02T11:05:00.000Z', '2026-01-02T11:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-03T09:00:00.000Z', '🚶‍♂️ Camminata', 45,
  '✅ Benessere / Energia', 3, '🧘 Calma',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-01-03T09:50:00.000Z', '2026-01-03T09:50:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-04T08:00:00.000Z', '🏃 Corsa / Running', 25,
  '⚠️ Bruciare / Rimediare al cibo', 5, '😔 Colpa / Rimorso', 'Troppi stravizi durante le feste',
  '😐 Uguale', 4, '😤 Frustrazione',
  '2026-01-04T08:30:00.000Z', '2026-01-04T08:30:00.000Z');

-- ============================================================
-- WEEK 16: Jan 5-11 — Only exercises (New Year resolutions), 4 exercises
-- ============================================================

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-01-05T07:00:00.000Z', '🏋️ Palestra / Pesi', 60,
  '✅ Benessere / Energia', 4, '😌 Orgoglio', 'Nuovo anno, nuova routine!',
  '✅ Più libero / leggero', 'Muscoli indolenziti ma bene',
  2, '😊 Gioia', 'Ce la posso fare!',
  '2026-01-05T08:05:00.000Z', '2026-01-05T08:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-07T07:00:00.000Z', '🏃 Corsa / Running', 30,
  '✅ Benessere / Energia', 3, '🧘 Calma',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-01-07T07:35:00.000Z', '2026-01-07T07:35:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-09T07:00:00.000Z', '🏋️ Palestra / Pesi', 55,
  '✅ Benessere / Energia', 2, '🧘 Calma',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-01-09T08:00:00.000Z', '2026-01-09T08:00:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-11T09:00:00.000Z', '🧘‍♂️ Yoga / Pilates', 45,
  '🧠 Gestire emozioni / Stress', 4, '😰 Ansia', 'Settimana di rientro al lavoro stressante',
  '✅ Più libero / leggero', 'Corpo rilassato, mente calma',
  1, '🧘 Calma',
  '2026-01-11T09:50:00.000Z', '2026-01-11T09:50:00.000Z');

-- ============================================================
-- WEEK 17: Jan 12-18 — Both meals + exercises, full data
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-01-12T06:30:00.000Z', 'Colazione', '07:30', '08:00',
  'Smoothie di frutta, pane integrale con marmellata', 'Casa', 'Da solo/a',
  'Fame leggera, energia bassa', 3, '🧘 Calma', 'Inizio settimana con buone abitudini',
  'Energia in crescita', 2, '😊 Gioia', 'Mi sento bene dopo una colazione sana',
  '2026-01-12T06:35:00.000Z', '2026-01-12T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-13T11:00:00.000Z', 'Pranzo', '13:00', '13:40',
  'Insalata con quinoa, pollo, avocado', 'Ufficio', 'Colleghi',
  2, '🧘 Calma',
  'Leggero/a e soddisfatto/a', 1, '😊 Gioia',
  '2026-01-13T11:05:00.000Z', '2026-01-13T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-01-15T17:00:00.000Z', 'Cena', '19:30', '20:15',
  'Salmone al forno con patate dolci e broccoli', 'Casa', 'Partner',
  'Fame intensa dopo la palestra', 3, '😊 Gioia',
  'Piacevolmente sazio/a', 2, '😊 Gioia', 'Cena perfetta dopo l''allenamento',
  '2026-01-15T17:05:00.000Z', '2026-01-15T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-17T09:00:00.000Z', 'Spuntino', '11:00', '11:10',
  'Yogurt greco con granola', 'Ufficio',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-01-17T09:05:00.000Z', '2026-01-17T09:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-18T11:00:00.000Z', 'Pranzo', '13:00', '14:00',
  'Penne all''arrabbiata, insalata caprese', 'Trattoria', 'Amici',
  2, '😊 Gioia', 3, '😊 Gioia',
  '2026-01-18T11:05:00.000Z', '2026-01-18T11:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-12T15:00:00.000Z', '🚶‍♂️ Camminata', 50,
  '✅ Benessere / Energia', 2, '😊 Gioia',
  '✅ Più libero / leggero', 'Rilassato/a', 1, '🧘 Calma',
  '2026-01-12T15:55:00.000Z', '2026-01-12T15:55:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-01-15T16:00:00.000Z', '🏋️ Palestra / Pesi', 55,
  '✅ Benessere / Energia', 3, '🧘 Calma',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-01-15T16:00:00.000Z', '2026-01-15T16:00:00.000Z');

-- ============================================================
-- WEEK 18: Jan 19-25 — EMPTY (dropped off)
-- ============================================================

-- ============================================================
-- WEEK 19: Jan 26 - Feb 1 — EMPTY
-- ============================================================

-- ============================================================
-- WEEK 20: Feb 2-8 — Coming back, only 2 meals
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, thought_before, created_at, updated_at)
VALUES ('2026-02-04T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Caffè e fette biscottate', 'Casa',
  5, '😔 Colpa / Rimorso', 'Ho smesso di usare l''app, devo riprendere',
  '2026-02-04T06:35:00.000Z', '2026-02-04T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-06T17:00:00.000Z', 'Cena', '19:00', '19:45',
  'Pasta aglio, olio e peperoncino, verdure', 'Casa', 'Partner',
  3, '🧘 Calma', 2, '😊 Gioia',
  '2026-02-06T17:05:00.000Z', '2026-02-06T17:05:00.000Z');

-- ============================================================
-- WEEK 21: Feb 9-15 — 4 meals + 3 exercises
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-09T06:30:00.000Z', 'Colazione', '07:30', '08:00',
  'Porridge con frutti di bosco', 'Casa', 'Da solo/a',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-02-09T06:35:00.000Z', '2026-02-09T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-02-10T11:00:00.000Z', 'Pranzo', '13:00', '13:30',
  'Wrap con hummus, verdure e feta', 'Ufficio',
  3, '😰 Ansia',
  '2026-02-10T11:05:00.000Z', '2026-02-10T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-02-14T17:30:00.000Z', 'Cena', '20:00', '22:00',
  'Cena di San Valentino: antipasto di mare, risotto ai frutti di mare, tiramisù, prosecco', 'Ristorante elegante', 'Partner',
  'Eccitazione, farfalle nello stomaco', 4, '❤️ Fame d''amore', 'Serata speciale',
  'Piacevolmente pieno/a', 3, '😊 Gioia', 'Serata perfetta',
  '2026-02-14T17:35:00.000Z', '2026-02-14T17:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, created_at, updated_at)
VALUES ('2026-02-15T09:00:00.000Z', 'Colazione', '10:00', '10:30',
  'Brioches alla crema, cappuccino', 'Pasticceria',
  '2026-02-15T09:05:00.000Z', '2026-02-15T09:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-09T15:00:00.000Z', '🏃 Corsa / Running', 35,
  '✅ Benessere / Energia', 3, '😊 Gioia',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-02-09T15:40:00.000Z', '2026-02-09T15:40:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-11T07:00:00.000Z', '🧘 Stretching / Mobilità', 20,
  '🧠 Gestire emozioni / Stress', 5, '😰 Ansia',
  '✅ Più libero / leggero', 2, '🧘 Calma',
  '2026-02-11T07:25:00.000Z', '2026-02-11T07:25:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-02-13T16:00:00.000Z', '🏋️ Palestra / Pesi', 50,
  '✅ Benessere / Energia', 2, '🧘 Calma',
  '✅ Più libero / leggero', 'Muscoli caldi, energia positiva',
  1, '😊 Gioia', 'Buon allenamento',
  '2026-02-13T16:55:00.000Z', '2026-02-13T16:55:00.000Z');

-- ============================================================
-- WEEK 22: Feb 16-22 — Only meals (5)
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-02-16T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Pane con burro di arachidi e banana', 'Casa',
  2, '🧘 Calma',
  '2026-02-16T06:35:00.000Z', '2026-02-16T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2026-02-17T11:00:00.000Z', 'Pranzo', '13:00', '13:25', 'Pasta con le sarde', '2026-02-17T11:05:00.000Z', '2026-02-17T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-18T17:00:00.000Z', 'Cena', '19:00', '20:00',
  'Tagliata di manzo con rucola e grana, patate arrosto', 'Casa', 'Partner',
  3, '😊 Gioia',
  'Soddisfatto/a', 2, '😊 Gioia',
  '2026-02-18T17:05:00.000Z', '2026-02-18T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, emotional_intensity_before, created_at, updated_at)
VALUES ('2026-02-19T14:00:00.000Z', 'Merenda', '16:00', '16:15', 'Frutta secca e cioccolato fondente', 2, '2026-02-19T14:20:00.000Z', '2026-02-19T14:20:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-02-22T11:00:00.000Z', 'Pranzo', '12:30', '14:00',
  'Grigliata mista: salsicce, costine, verdure, polenta', 'Casa di amici', 'Amici',
  'Molta fame', 3, '😊 Gioia', 'Pranzo domenicale con gli amici',
  'Molto pieno/a, pesante', 4, '😔 Colpa / Rimorso', 'Ho esagerato ma era troppo buono',
  '2026-02-22T11:05:00.000Z', '2026-02-22T11:05:00.000Z');

-- ============================================================
-- WEEK 23: Feb 23 - Mar 1 — 3 meals + 2 exercises
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-23T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Muesli con latte e mirtilli', 'Casa',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-02-23T06:35:00.000Z', '2026-02-23T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-02-25T11:00:00.000Z', 'Pranzo', '13:00', '13:30',
  'Caesar salad con pollo', 'Ufficio', 'Colleghi',
  3, '😤 Frustrazione',
  '2026-02-25T11:05:00.000Z', '2026-02-25T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-28T17:00:00.000Z', 'Cena', '19:30', '20:30',
  'Ravioli ripieni di ricotta e spinaci, contorno di carciofi', 'Casa', 'Partner',
  2, '😊 Gioia', 2, '🧘 Calma',
  '2026-02-28T17:05:00.000Z', '2026-02-28T17:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-24T07:00:00.000Z', '🏃 Corsa / Running', 40,
  '✅ Benessere / Energia', 3, '🧘 Calma',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-02-24T07:45:00.000Z', '2026-02-24T07:45:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-02-26T16:30:00.000Z', '🏊 Nuoto', 45,
  '✅ Benessere / Energia', 4, '😤 Frustrazione', 'Giornata pesante al lavoro',
  '✅ Più libero / leggero', 'Corpo leggero, muscoli rilassati',
  1, '🧘 Calma',
  '2026-02-26T17:20:00.000Z', '2026-02-26T17:20:00.000Z');

-- ============================================================
-- WEEK 24: Mar 2-8 — Rich week, daily tracking
-- ============================================================

-- Monday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-02T06:30:00.000Z', 'Colazione', '07:30', '08:00',
  'Avena con miele, noci e mela', 'Casa', 'Da solo/a',
  'Fame leggera', 2, '🧘 Calma',
  'Sazio/a e energico/a', 1, '😊 Gioia',
  '2026-03-02T06:35:00.000Z', '2026-03-02T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-02T11:00:00.000Z', 'Pranzo', '13:00', '13:35',
  'Pasta integrale con verdure grigliate', 'Ufficio', 'Colleghi',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-03-02T11:05:00.000Z', '2026-03-02T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, created_at, updated_at)
VALUES ('2026-03-02T17:00:00.000Z', 'Cena', '19:00', '19:30',
  'Frittata con zucchine, insalata', 'Casa', 2,
  '2026-03-02T17:05:00.000Z', '2026-03-02T17:05:00.000Z');

-- Tuesday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-03-03T06:30:00.000Z', 'Colazione', '07:30', '07:45',
  'Yogurt con granola e frutta', 'Casa',
  3, '😰 Ansia',
  '2026-03-03T06:35:00.000Z', '2026-03-03T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-03T11:00:00.000Z', 'Pranzo', '13:00', '13:40',
  'Pollo alla piastra con riso basmati e verdure', 'Mensa', 'Colleghi',
  4, '😤 Frustrazione', 2, '🧘 Calma',
  '2026-03-03T11:05:00.000Z', '2026-03-03T11:05:00.000Z');

-- Wednesday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-03-04T06:00:00.000Z', 'Colazione', '07:00', '07:30',
  'Pancakes integrali con sciroppo d''acero e frutti di bosco', 'Casa', 'Partner',
  'Ben riposato/a, fame leggera', 1, '😊 Gioia', 'Giornata che parte bene',
  'Energico/a', 1, '😊 Gioia', 'Colazione perfetta',
  '2026-03-04T06:05:00.000Z', '2026-03-04T06:05:00.000Z');

-- Thursday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-05T11:00:00.000Z', 'Pranzo', '13:00', '13:30',
  'Farro con lenticchie e verdure', 'Ufficio',
  3, '🧘 Calma', 2, '😊 Gioia',
  '2026-03-05T11:05:00.000Z', '2026-03-05T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2026-03-05T14:00:00.000Z', 'Merenda', '16:00', '16:10', 'Barretta proteica e tè verde', '2026-03-05T14:15:00.000Z', '2026-03-05T14:15:00.000Z');

-- Friday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-03-06T17:00:00.000Z', 'Cena', '19:30', '21:00',
  'Aperitivo: tagliere di salumi e formaggi, bruschette. Poi pizza', 'Pizzeria', 'Amici',
  'Fame intensa, eccitazione', 3, '😊 Gioia', 'Venerdì sera finalmente!',
  'Molto pieno/a ma felice', 2, '😊 Gioia', 'Serata divertente',
  '2026-03-06T17:05:00.000Z', '2026-03-06T17:05:00.000Z');

-- Saturday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-03-07T08:00:00.000Z', 'Colazione', '09:00', '09:30',
  'Uova alla coque con pane tostato, succo d''arancia', 'Casa',
  1, '😊 Gioia',
  '2026-03-07T08:05:00.000Z', '2026-03-07T08:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-07T11:30:00.000Z', 'Pranzo', '13:00', '14:00',
  'Risotto allo zafferano, ossobuco', 'Ristorante', 'Famiglia',
  2, '😊 Gioia', 3, '😊 Gioia',
  '2026-03-07T11:35:00.000Z', '2026-03-07T11:35:00.000Z');

-- Sunday
INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-08T09:00:00.000Z', 'Colazione', '10:00', '10:30',
  'Cornetto integrale con cappuccino', 'Bar', 'Partner',
  1, '😊 Gioia', 1, '🧘 Calma',
  '2026-03-08T09:05:00.000Z', '2026-03-08T09:05:00.000Z');

-- Exercises for week 24
INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-02T16:00:00.000Z', '🏃 Corsa / Running', 35,
  '✅ Benessere / Energia', 3, '🧘 Calma',
  '✅ Più libero / leggero', 'Stanchezza piacevole',
  1, '😊 Gioia',
  '2026-03-02T16:40:00.000Z', '2026-03-02T16:40:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-04T16:30:00.000Z', '🏋️ Palestra / Pesi', 55,
  '✅ Benessere / Energia', 2, '😊 Gioia',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-03-04T17:30:00.000Z', '2026-03-04T17:30:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-07T08:00:00.000Z', '🥾 Trekking / Camminata lunga', 120,
  '✅ Benessere / Energia', 2, '😊 Gioia',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-03-07T10:05:00.000Z', '2026-03-07T10:05:00.000Z');

-- ============================================================
-- WEEK 25: Mar 9-15 — 5 meals + 2 exercises
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-09T06:30:00.000Z', 'Colazione', '07:30', '07:55',
  'Toast con avocado e uovo in camicia', 'Casa', 'Da solo/a',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-03-09T06:35:00.000Z', '2026-03-09T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-03-10T11:00:00.000Z', 'Pranzo', '13:00', '13:30',
  'Bowl di riso, salmone, edamame, avocado', 'Take away', 'Colleghi',
  3, '😰 Ansia',
  '2026-03-10T11:05:00.000Z', '2026-03-10T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-03-11T17:00:00.000Z', 'Cena', '19:00', '20:00',
  'Hamburger gourmet con patatine, birra artigianale', 'Pub',
  'Fame intensa, stanchezza', 5, '😢 Tristezza', 'Giornata brutta, mi merito qualcosa di buono',
  'Pieno/a, un po'' pesante', 4, '😔 Colpa / Rimorso', 'Forse non era il modo migliore per gestire la tristezza',
  '2026-03-11T17:05:00.000Z', '2026-03-11T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, created_at, updated_at)
VALUES ('2026-03-13T09:00:00.000Z', 'Spuntino', '11:00', '11:10', 'Banana e mandorle', '2026-03-13T09:15:00.000Z', '2026-03-13T09:15:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-15T11:00:00.000Z', 'Pranzo', '12:30', '13:30',
  'Tagliatelle ai porcini, verdure di stagione', 'Agriturismo', 'Famiglia',
  2, '😊 Gioia', 2, '😊 Gioia',
  '2026-03-15T11:05:00.000Z', '2026-03-15T11:05:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-09T15:00:00.000Z', '🚶‍♂️ Camminata', 40,
  '✅ Benessere / Energia', 2, '😊 Gioia',
  '✅ Più libero / leggero', 'Rilassato/a, gambe leggere',
  1, '🧘 Calma',
  '2026-03-09T15:45:00.000Z', '2026-03-09T15:45:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, thought_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-03-12T07:00:00.000Z', '🏃 Corsa / Running', 30,
  '🧠 Gestire emozioni / Stress', 5, '😢 Tristezza', 'Ancora giù per ieri, provo a correre',
  '✅ Più libero / leggero', 'Respiro più profondo, corpo caldo',
  2, '🧘 Calma', 'La corsa aiuta davvero a stare meglio',
  '2026-03-12T07:35:00.000Z', '2026-03-12T07:35:00.000Z');

-- ============================================================
-- WEEK 26: Mar 16-21 — Current week, recent entries
-- ============================================================

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, thought_before, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-03-16T06:30:00.000Z', 'Colazione', '07:30', '08:00',
  'Pane integrale con ricotta e miele, caffè', 'Casa', 'Da solo/a',
  'Riposato/a, fame moderata', 2, '🧘 Calma', 'Nuova settimana, obiettivi chiari',
  'Energico/a, pronto/a', 1, '😊 Gioia', 'Buon inizio',
  '2026-03-16T06:35:00.000Z', '2026-03-16T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-16T11:00:00.000Z', 'Pranzo', '13:00', '13:35',
  'Pasta al pesto genovese, pomodorini e mozzarella', 'Ufficio', 'Colleghi',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-03-16T11:05:00.000Z', '2026-03-16T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-17T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Cereali integrali con latte e banana', 'Casa', 'Da solo/a',
  2, '🧘 Calma', 1, '😊 Gioia',
  '2026-03-17T06:35:00.000Z', '2026-03-17T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, body_sensations_before, emotional_intensity_before, emotion_before, body_sensations_after, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-18T11:00:00.000Z', 'Pranzo', '13:00', '13:30',
  'Zuppa di legumi con crostini', 'Ufficio', 'Da solo/a',
  'Leggera fame', 3, '😤 Frustrazione',
  'Caldo e sazio/a', 2, '🧘 Calma',
  '2026-03-18T11:05:00.000Z', '2026-03-18T11:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-19T17:00:00.000Z', 'Cena', '19:30', '20:15',
  'Orata al cartoccio con patate e olive', 'Casa', 'Partner',
  2, '😊 Gioia', 2, '🧘 Calma',
  '2026-03-19T17:05:00.000Z', '2026-03-19T17:05:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-03-20T06:30:00.000Z', 'Colazione', '07:30', '07:50',
  'Fette biscottate con marmellata di albicocche, tè', 'Casa',
  1, '🧘 Calma',
  '2026-03-20T06:35:00.000Z', '2026-03-20T06:35:00.000Z');

INSERT INTO meals (date_time, meal_type, start_time, end_time, what_eaten, location, with_whom, emotional_intensity_before, emotion_before, created_at, updated_at)
VALUES ('2026-03-21T06:30:00.000Z', 'Colazione', '07:30', '07:45',
  'Cornetto vuoto e caffè macchiato', 'Bar sotto casa', 'Da solo/a',
  2, '🧘 Calma',
  '2026-03-21T07:50:00.000Z', '2026-03-21T07:50:00.000Z');

-- Exercises for current week
INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, body_sensations_after, emotional_intensity_after, emotion_after, thought_after, created_at, updated_at)
VALUES ('2026-03-16T15:00:00.000Z', '🚶‍♂️ Camminata', 45,
  '✅ Benessere / Energia', 2, '😊 Gioia',
  '✅ Più libero / leggero', 'Rilassato/a',
  1, '🧘 Calma', 'Bel pomeriggio di sole',
  '2026-03-16T15:50:00.000Z', '2026-03-16T15:50:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-18T07:00:00.000Z', '🏋️ Palestra / Pesi', 50,
  '✅ Benessere / Energia', 3, '😤 Frustrazione',
  '✅ Più libero / leggero', 1, '😊 Gioia',
  '2026-03-18T07:55:00.000Z', '2026-03-18T07:55:00.000Z');

INSERT INTO exercises (date_time, exercise_type, duration_minutes, intention, emotional_intensity_before, emotion_before, outcome, emotional_intensity_after, emotion_after, created_at, updated_at)
VALUES ('2026-03-20T16:30:00.000Z', '🧘‍♂️ Yoga / Pilates', 40,
  '🧠 Gestire emozioni / Stress', 3, '😰 Ansia',
  '✅ Più libero / leggero', 1, '🧘 Calma',
  '2026-03-20T17:15:00.000Z', '2026-03-20T17:15:00.000Z');
