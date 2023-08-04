
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_application_1/services/baza.dart';

import '../../model/quiz_model.dart';

part 'quiz_editor_cubit.freezed.dart';
part 'quiz_editor_state.dart';

class QuizEditorCubit extends Cubit<QuizEditorState> {
  final QuizHelper baza;
  QuizEditorCubit(this.baza) : super(const QuizEditorState.initial());
 
  Future<void> addQuestion(Quiz quiz)async{
    try{
      await baza.addQuestion(quiz);
    }catch(e){
      emit(const QuizEditorState.error());
    }
    showAllQuestion();
  }

  Future<void> deleteQuestion(Quiz quiz)async{
    try{
      await baza.delete(quiz);
    }catch(e){
      emit(const QuizEditorState.error());
    }
   showAllQuestion();
  }

  Future<void> updateQuestion(Quiz quiz)async{
    try{
      await baza.update(quiz);
    }catch(e){
      emit(const QuizEditorState.error());
    }
   showAllQuestion();
  }

  Future<void> deleteAllQuestion()async{
    try{
      await baza.deleteAll();
    }catch(e){
      emit(const QuizEditorState.error());
    }
    showAllQuestion();
  }

  Future<void> showAllQuestion()async{
    emit(const QuizEditorState.initial());
    List<Quiz> questions = [];
    try{
      questions = await baza.showItems();
      await baza.length();
      emit(QuizEditorState.loaded(questions));
    }catch(e){
      emit(const QuizEditorState.error());
    } 
  }
}
