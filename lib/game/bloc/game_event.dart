part of 'game_bloc.dart';

abstract class QuizEvent {
  const QuizEvent();
}

class LoadQuestion extends QuizEvent{
  final int id;
  const LoadQuestion(this.id) : super();
}

class NextQuestion extends QuizEvent{
  final int numerPyt;
  final int dobryIndex;
  final bool czyKlik;
  const NextQuestion(this.czyKlik,this.dobryIndex,this.numerPyt);
}

class QuizReset extends QuizEvent{
  final bool czyKlik;
  final int numerPyt;
  const QuizReset(this.czyKlik,this.numerPyt);
}

class Update extends QuizEvent{
  final bool czyKlik;
  final Quiz quiz;
  final int dobryIndex;
  final int index;
  const Update(this.czyKlik,this.dobryIndex,this.quiz,this.index);
}

