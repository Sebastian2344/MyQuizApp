import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/quiz_editor/repository/quiz_editor_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/quiz_model.dart';

part 'quiz_editor_cubit.freezed.dart';
part 'quiz_editor_state.dart';

class QuizEditorCubit extends Cubit<QuizEditorState> {
  final QuizEditorRepository repository;
  QuizEditorCubit(this.repository) : super(const QuizEditorState.initial());
 
  Future<void> addQuestion(Quiz quiz)async{
    try{
      await repository.addItem(quiz);
    }catch(e){
      emit(const QuizEditorState.error());
      return;
    }
    showAllQuestion();
  }

  Future<void> deleteQuestion(Quiz quiz)async{
    try{
      await repository.deleteItem(quiz.numer!);
    }catch(e){
      emit(const QuizEditorState.error());
      return;
    }
   showAllQuestion();
  }

  Future<void> updateQuestion(Quiz quiz)async{
    try{
      await repository.updateItem(quiz);
    }catch(e){
      emit(const QuizEditorState.error());
      return;
    }
   showAllQuestion();
  }

  Future<void> deleteAllQuestion()async{
    try{
      await repository.deleteAll();
    }catch(e){
      emit(const QuizEditorState.error());
      return;
    }
    showAllQuestion();
  }

  Future<void> showAllQuestion()async{
    emit(const QuizEditorState.initial());
    List<Quiz> questions = [];
    try{
      questions = await repository.fetchItems();
      await repository.lengthQuiz();
      emit(QuizEditorState.loaded(questions));
    }catch(e){
      emit(const QuizEditorState.error());
    } 
  }
}
