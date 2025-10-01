import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/services/baza.dart';

abstract class QuizEditorRepository {
  Future<void> addItem(Quiz quiz);
  Future<List<Quiz>> fetchItems();
  Future<void> deleteItem(int id);
  Future<void> updateItem(Quiz quiz);
  Future<void> deleteAll();
  Future<int> lengthQuiz();
}

class QuizEditorRepositoryImpl extends QuizEditorRepository {
  final QuizHelper baza;
  QuizEditorRepositoryImpl(this.baza);
  @override
  Future<void> addItem(Quiz quiz) {
    return baza.addQuestion(quiz);
  }

  @override
  Future<void> deleteItem(int id) {
    return baza.delete(id);
  }

  @override
  Future<List<Quiz>> fetchItems() {
    return baza.showItems();
  }

  @override
  Future<void> updateItem(Quiz quiz) {
    return baza.update(quiz);
  }

  @override
  Future<int> lengthQuiz() {
    return baza.length();
  }
  
  @override
  Future<void> deleteAll() {
    return baza.deleteAll();
  }
}