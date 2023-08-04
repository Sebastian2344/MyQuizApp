class Quiz {
  final int? numer;
  final String pytanie;
  final String odpowiedz1;
  final String odpowiedz2;
  final String odpowiedz3;
  final String odpowiedz4;
  final String poprawna;
  static int punkty = 0;

  Quiz({this.numer,required this.pytanie,required this.odpowiedz1,required this.odpowiedz2,
    required  this.odpowiedz3,required this.odpowiedz4,required this.poprawna});

  factory Quiz.fromJson(Map<String, dynamic> map)
      => Quiz(
        numer : map['numer'] as int?,
        pytanie : map['pytanie'] as String,
        odpowiedz1 : map['odpowiedz1'] as String,
        odpowiedz2 : map['odpowiedz2'] as String,
        odpowiedz3 : map['odpowiedz3'] as String,
        odpowiedz4 : map['odpowiedz4'] as String,
        poprawna : map['poprawna'] as String); 

  Map<String, dynamic> toJson() => {
        'numer': numer,
        'pytanie': pytanie,
        'odpowiedz1': odpowiedz1,
        'odpowiedz2': odpowiedz2,
        'odpowiedz3': odpowiedz3,
        'odpowiedz4': odpowiedz4,
        'poprawna': poprawna,
      };
}