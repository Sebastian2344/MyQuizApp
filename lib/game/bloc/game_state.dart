part of 'game_bloc.dart';


abstract class QuizState {}

class QuizInitial extends QuizState {}

class Error extends QuizState {
  String error;
  Error(this.error);
}

class QuizLoaded extends QuizState {
  Quiz quiz;
  bool czyKlik;
  int dobryIndex;
  QuizLoaded(this.quiz,[this.czyKlik = false,this.dobryIndex = -1]);
}
