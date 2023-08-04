import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/quiz_model.dart';
import '../../services/baza.dart';

part 'game_event.dart';
part 'game_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizHelper baza;
  QuizBloc(this.baza) : super(QuizInitial()) { 
    on<LoadQuestion>((event, emit) async {
          try {
          Quiz question = await baza.showItem(event.id);
          baza.numerPyt = event.id;
          emit(QuizLoaded(question));
        } catch (e) {
          if(baza.lengthQuiz == 0){
            emit(Error('Baza pytań jest pusta wyjdź do menu i stwórz pytania'));
          }else{
            emit(Error(e.toString()));
          }
        }
    });
    on<NextQuestion>((event, emit) {
      event.numerPyt++;
      add(LoadQuestion(event.numerPyt));
    });
    on<QuizReset>((event, emit) {
      Quiz.punkty = 0;
      add(LoadQuestion(event.numerPyt));
    });

    on<Update>((event, emit) {
      event.dobryIndex = baza.podajPopOdp(event.quiz);
      if (event.dobryIndex == event.index) {
        event.dobryIndex = event.index;
        Quiz.punkty++;
      }
      emit(QuizLoaded(event.quiz,event.czyKlik,event.dobryIndex));
    });
  }
}
