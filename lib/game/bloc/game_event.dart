part of 'game_bloc.dart';

abstract class QuizEvent {}

class LoadQuestion extends QuizEvent{
  int id;
  LoadQuestion(this.id,);
}

class NextQuestion extends QuizEvent{
  int numerPyt;
  int dobryIndex;
  bool czyKlik;
  NextQuestion(this.czyKlik,this.dobryIndex,this.numerPyt);
}

class QuizReset extends QuizEvent{
  bool czyKlik;
  int numerPyt;
  QuizReset(this.czyKlik,this.numerPyt);
}

class Update extends QuizEvent{
  bool czyKlik;
  Quiz quiz;
  int dobryIndex;
  int index;
  Update(this.czyKlik,this.dobryIndex,this.quiz,this.index);
}

