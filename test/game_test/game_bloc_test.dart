import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_application_1/game/bloc/game_bloc.dart';
import 'package:flutter_application_1/game/repository/game_repo.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late QuizBloc bloc;
  late MockGameRepository repository;

  setUp(() {
    repository = MockGameRepository();
    bloc = QuizBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });
  

  group('QuizBloc z any()', () {
  final quiz = Quiz(pytanie: '', odpowiedz1: '', odpowiedz2: '', odpowiedz3: '', odpowiedz4: '', poprawna: '');

  blocTest<QuizBloc, QuizState>(
    'emituje QuizLoaded po LoadQuestion',
    build: () {
      when(() => repository.showItem(any())).thenAnswer((_) async => quiz);
      when(() => repository.numerPyt(any())).thenReturn(1);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadQuestion(42)), // specjalnie 42
    expect: () => [QuizLoaded(quiz)],
    verify: (_) {
      verify(() => repository.showItem(42)).called(1);
    },
  );

  blocTest<QuizBloc, QuizState>(
    'emituje Error gdy repo wyrzuca wyjątek i baza jest pusta',
    build: () {
      when(() => repository.showItem(any())).thenThrow(Exception("error"));
      when(() => repository.lengthQuiz()).thenReturn(0);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadQuestion(99)),
    expect: () => [
      const Error('Baza pytań jest pusta wyjdź do menu i stwórz pytania'),
    ],
  );

  blocTest<QuizBloc, QuizState>(
    'po Update dodaje punkt przy dobrej odpowiedzi',
    build: () {
      when(() => repository.podajPopOdp(quiz)).thenReturn(1);
      when(() => repository.punkty).thenReturn(0);
      return bloc;
    },
    act: (bloc) => bloc.add(Update(true, 1, quiz, 1)),
    expect: () => [QuizLoaded(quiz, true, 1)],
    verify: (_) {
      verify(() => repository.punkty += any()).called(1);
    },
  );

  blocTest<QuizBloc, QuizState>(
    'po QuizReset zeruje punkty',
    build: () {
      when(() => repository.showItem(any())).thenAnswer((_) async => quiz);
      when(() => repository.numerPyt(any())).thenReturn(0);
      return bloc;
    },
    act: (bloc) => bloc.add(QuizReset(false, 1)),
    expect: () => [QuizLoaded(quiz)],
    verify: (_) {
      verify(() => repository.punkty = any()).called(1);
    },
  );
});

}