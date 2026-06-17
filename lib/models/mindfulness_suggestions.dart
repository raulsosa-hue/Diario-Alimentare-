import 'dart:math';

enum MindfulnessMoment {
  beforeMeal,
  afterMeal,
  beforeExercise,
  afterExercise,
}

const Map<MindfulnessMoment, List<String>> kMindfulnessSuggestions = {
  MindfulnessMoment.beforeMeal: [
    'Fermati 10 secondi e ascoltati: cosa stai cercando davvero?',
    'Prima di iniziare: che bisogno c\u2019è sotto questa voglia?',
    'Un respiro. Che emozione c\u2019è adesso?',
    'Porta l\u2019attenzione al corpo. Cosa senti ora?',
    'Nota il respiro per qualche secondo, senza modificarlo.',
    'C\u2019è una zona del corpo più attiva o più rilassata?',
    'Osserva i pensieri che arrivano. Non seguirli, lasciali passare.',
    'Rimani presente 10 secondi. Solo questo momento.',
    'Questo pasto nutrirà solo il corpo o anche qualcos\u2019altro?',
    'Cosa stavi cercando prima di iniziare a mangiare?',
    'Se il cibo fosse una risposta, qual\u2019era la domanda?',
  ],
  MindfulnessMoment.afterMeal: [
    'Ora fermati 10 secondi: com\u2019è il tuo corpo adesso?',
    'Niente giudizi: nota solo cos\u2019è cambiato dentro di te.',
    'Se potessi dirti una frase gentile, quale sarebbe?',
    'Questo pasto ti ha avvicinato o allontanato da come vuoi sentirti?',
    'Porta l\u2019attenzione al respiro. Inspira lento, espira lento.',
    'Nota il corpo senza cambiare nulla. Solo osserva.',
    'C\u2019è tensione o rilassamento da qualche parte?',
    'Resta qui 10 secondi. Solo presenza.',
    'Il cibo ha calmato qualcosa o colmato un vuoto?',
    'Ora che hai mangiato, cosa senti davvero?',
    'Se questo momento avesse una voce, cosa direbbe?',
    'C\u2019è un bisogno emotivo che chiede ancora spazio?',
  ],
  MindfulnessMoment.beforeExercise: [
    'Prima di iniziare: che cosa vuoi ottenere davvero (energia, calma, sfogo, cura)?',
    'Ascolta il corpo: ora di cosa ha bisogno?',
    'Scegli un\u2019intenzione semplice: "mi muovo per prendermi cura del mio corpo."',
    'Porta l\u2019attenzione al corpo. Com\u2019è ora?',
    'Fai un respiro lento. Entra nel movimento con calma.',
    'Nota il tuo livello di energia, senza giudicarlo.',
    'Ascolta il corpo prima di chiedergli qualcosa.',
    'Inizia con presenza, non con fretta.',
    'Perché vuoi muoverti proprio adesso?',
    'Di cosa ha bisogno davvero il tuo corpo ora?',
    'Che intenzione vuoi portare in questo tempo?',
  ],
  MindfulnessMoment.afterExercise: [
    'Fermati 10 secondi: cos\u2019è cambiato nel corpo e nella testa?',
    'Nota una cosa buona (anche piccola) di questi minuti.',
    'Com\u2019è il respiro adesso?',
    'Nota il corpo dopo il movimento. Cosa è cambiato?',
    'C\u2019è più calore, più calma o più energia?',
    'Rimani qui qualche secondo e ascolta.',
    'Lascia che il corpo si assesti prima di ripartire.',
    'Cosa senti ora che prima non c\u2019era?',
    'Il corpo ti sta ringraziando o chiedendo qualcosa?',
    'Questo momento ti avvicina a come vuoi stare?',
  ],
};

final Map<MindfulnessMoment, String?> _lastShown = {};

String pickSuggestion(MindfulnessMoment moment) {
  final all = kMindfulnessSuggestions[moment]!;
  final prev = _lastShown[moment];
  final filtered = (prev == null || all.length == 1) ? all : all.where((s) => s != prev).toList();
  final pool = filtered.isEmpty ? all : filtered;
  final picked = pool[Random().nextInt(pool.length)];
  _lastShown[moment] = picked;
  return picked;
}
