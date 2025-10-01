part of 'game_bloc.dart';


abstract class QuizState extends Equatable {
  const QuizState();
}

class QuizInitial extends QuizState {
  @override
  List<Object?> get props => [];
}

class Error extends QuizState {
  final String error;
  const Error(this.error);
  
  @override
  List<Object?> get props => [error];
}

class QuizLoaded extends QuizState {
  final Quiz quiz;
  final bool czyKlik;
  final int dobryIndex;
  const QuizLoaded(this.quiz,[this.czyKlik = false,this.dobryIndex = -1]);
  
  @override
  List<Object?> get props => [quiz,czyKlik,dobryIndex];
}
