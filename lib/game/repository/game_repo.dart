
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/services/baza.dart';

abstract class GameRepository {
  Future<Quiz> showItem(int id);
  int podajPopOdp(Quiz quiz);
  int lengthQuiz();
  int numerPyt(int id);
  int get numerPytania;
  int get punkty;
  set punkty(int punkty);
}

class GameRepositoryImpl extends GameRepository {
  final QuizHelper baza;
  GameRepositoryImpl(this.baza);
  @override
  Future<Quiz> showItem(int id) {
    return baza.showItem(id);
  }
  
  @override
  int podajPopOdp(Quiz quiz) {
    return baza.podajPopOdp(quiz);
  }
  
  @override
  int lengthQuiz() {
    return baza.lengthQuiz;
  }
  
  @override
  int numerPyt(int id) {
    baza.numerPyt = id;
    return baza.numerPyt;
  }
  
  @override
  int get numerPytania => baza.numerPyt;
  
  @override
  int get punkty => Quiz.punkty;
  
  @override
  set punkty(int punkty) {
    Quiz.punkty = punkty;
  }
}