import 'package:flutter_application_1/game/repository/game_repo.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/services/baza.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
class MockQuizHelper extends Mock implements QuizHelper {}
class MockQuiz extends Mock implements Quiz {}
void main(){
  late QuizHelper baza;
  late GameRepositoryImpl repo;

  setUp((){
    baza = MockQuizHelper();
    repo = GameRepositoryImpl(baza);
  });

  setUpAll((){
    registerFallbackValue(MockQuiz());
  });

  
  test('showItem', (){
    when(() => baza.showItem(any())).thenAnswer((_) async => MockQuiz());
    expect(repo.showItem(1), completion(isA<MockQuiz>()));
    verify(() => baza.showItem(1)).called(1);
  });
  test('podajPopOdp', (){
    when(() => baza.podajPopOdp(any())).thenReturn(42);
    expect(repo.podajPopOdp(MockQuiz()), 42);
    verify(() => baza.podajPopOdp(any())).called(1);
  });
  test('lengthQuiz', (){
    when(() => baza.lengthQuiz).thenReturn(42);
    expect(repo.lengthQuiz(), 42);
    verify(() => baza.lengthQuiz).called(1);
  });
  test('numerPyt', (){
    when(() => baza.numerPyt).thenReturn(1);
    expect(repo.numerPyt(1), 1);
    verify(() => baza.numerPyt=1).called(1);
    verify(() => baza.numerPyt).called(1);
  });

  test('punkty seter', (){
    repo.punkty = 42;
    expect(Quiz.punkty, 42);
  });

  test('punkty geter', (){
    Quiz.punkty = 42;
    expect(repo.punkty, 42);
  });

  test('numer pytania', (){
    when(() => baza.numerPyt).thenReturn(42);
    expect(repo.numerPytania, 42);
    verify(() => baza.numerPyt).called(1);
  });

  tearDown((){});
}