import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/quiz_editor/repository/quiz_editor_repo.dart';
import 'package:flutter_application_1/services/baza.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
class MockQuizHelper extends Mock implements QuizHelper {}
class MockQuiz extends Mock implements Quiz {}
void main(){

  late QuizHelper baza;
  late QuizEditorRepositoryImpl repo;

  setUp((){
    baza = MockQuizHelper();
    repo = QuizEditorRepositoryImpl(baza);
  });

  setUpAll((){
    registerFallbackValue(MockQuiz());
  });

  test('add item', () {
    when(() => baza.addQuestion(any())).thenAnswer((_) async {});
    expect(repo.addItem(MockQuiz()), completes);
    verify(() => baza.addQuestion(any())).called(1);
  });
  test('deleteItem', () {
    when(() => baza.delete(any())).thenAnswer((_) async {});
    expect(repo.deleteItem(1), completes);
    verify(() => baza.delete(1)).called(1);
  });
  test('fetchItems', () {
    when(() => baza.showItems()).thenAnswer((_) async => [MockQuiz()]);
    expect(repo.fetchItems(), completion(isA<List<Quiz>>()));
    verify(() => baza.showItems()).called(1);
  });
  test('updateItem', () {
    when(() => baza.update(any())).thenAnswer((_) async {});
    expect(repo.updateItem(MockQuiz()), completes);
    verify(() => baza.update(any())).called(1);
  });

  test('lengthQuiz', (){
    when(() => baza.length()).thenAnswer((_) async => 42);
    expect(repo.lengthQuiz(), completion(42));
    verify(() => baza.length()).called(1);
  });

  test('deleteAll', (){
    when(() => baza.deleteAll()).thenAnswer((_) async {});
    expect(repo.deleteAll(), completes);
    verify(() => baza.deleteAll()).called(1);
  });
}