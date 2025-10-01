import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/game/repository/game_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/quiz_model.dart';

part 'game_event.dart';
part 'game_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GameRepository repository;
  QuizBloc(this.repository) : super(QuizInitial()) { 
    on<LoadQuestion>((event, emit) async {
          try {
          Quiz question = await repository.showItem(event.id);
          repository.numerPyt(event.id);
          emit(QuizLoaded(question));
        } catch (e) {
          if(repository.lengthQuiz() == 0){
            emit(const Error('Baza pytań jest pusta wyjdź do menu i stwórz pytania'));
          }else{
            emit(Error(e.toString()));
          }
        }
    });
    on<NextQuestion>((event, emit) {
      add(LoadQuestion(event.numerPyt + 1));
    });
    on<QuizReset>((event, emit) {
      repository.punkty = 0;
      add(LoadQuestion(event.numerPyt));
    });

    on<Update>((event, emit) {
      int temp = 0;
      temp = repository.podajPopOdp(event.quiz);
      if (event.dobryIndex == event.index) {
        temp = event.index;
        repository.punkty += 1;
      }
      emit(QuizLoaded(event.quiz,event.czyKlik,temp));
    });
  }
}
