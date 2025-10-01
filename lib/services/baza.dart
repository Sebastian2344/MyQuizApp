import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/quiz_model.dart';

class QuizHelper {
  QuizHelper._privateConstructor();
  static final QuizHelper instance = QuizHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

   int podajPopOdp(Quiz quiz) {
    int liczba = 0;
    List<String> odp = [
      quiz.odpowiedz1,
      quiz.odpowiedz2,
      quiz.odpowiedz3,
      quiz.odpowiedz4,
    ];
    for (int i = 0; i < 4; i++) {
      odp[i] == quiz.poprawna ? liczba = odp.indexOf(odp[i]) : null;
    }
    return liczba;
  }

   int lengthQuiz = 0;
   int numerPyt = 1;
   Future<int> length() async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM $_nameTable');
    int count = Sqflite.firstIntValue(result)!;
    lengthQuiz = count;
    return count;
  }

  static const _nameFile = 'quiz1.db';
  static const _nameTable = 'mytable1';
  static late String _dbPath;

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    _dbPath = join(documentsDirectory.path, _nameFile);
    return await openDatabase(_dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
				Create table $_nameTable(
					numer INTEGER PRIMARY KEY,
					pytanie TEXT,
					odpowiedz1 TEXT,
					odpowiedz2 TEXT,
					odpowiedz3 TEXT,
					odpowiedz4 TEXT,
					poprawna TEXT
				)
			''');
    });
  }

  Future<List<Quiz>> showItems() async {
    Database db = await instance.database;
    var pytania = await db.query(_nameTable, orderBy: 'numer ASC');
    return List<Quiz>.from(pytania.map((map) => Quiz.fromJson(map)));
  }

  Future<Quiz> showItem(int id) async {
    Database db = await instance.database;
    final results = await db.rawQuery('SELECT numer FROM $_nameTable');
    final ids = results.map<int>((row) => row['numer'] as int).toList();
    List<Map<String, dynamic>> records = await db.query(
      _nameTable,
      where: 'numer = ?',
      whereArgs: [ids[id-1]],
      limit: 1,
    );
      return Quiz.fromJson(records.first);
  }

  Future<void> addQuestion(Quiz quiz) async {
    Database db = await database;
    await db.transaction((Transaction txn) async {
      await txn.rawInsert(
        'INSERT INTO $_nameTable (pytanie, odpowiedz1, odpowiedz2, odpowiedz3, odpowiedz4, poprawna) '
        'VALUES (?, ?, ?, ?, ?, ?)',
        [
          quiz.pytanie,
          quiz.odpowiedz1,
          quiz.odpowiedz2,
          quiz.odpowiedz3,
          quiz.odpowiedz4,
          quiz.poprawna,
        ],
      );
    });
  }

  Future<void> update(Quiz quiz) async {
    Database db = await instance.database;
    final data = {
      'pytanie': quiz.pytanie,
      'odpowiedz1': quiz.odpowiedz1,
      'odpowiedz2': quiz.odpowiedz2,
      'odpowiedz3': quiz.odpowiedz3,
      'odpowiedz4': quiz.odpowiedz4,
      'poprawna': quiz.poprawna,
    };
    await db
        .update(_nameTable, data, where: "numer = ?", whereArgs: [quiz.numer]);
  }

  Future<void> delete(int numer) async {
    Database db = await instance.database;
    await db.delete("mytable1", where: "numer = ?", whereArgs: [numer]);
  }

  Future<void> deleteAll() async {
    Database db = await instance.database;
    await db.delete(_nameTable);
  }
}
