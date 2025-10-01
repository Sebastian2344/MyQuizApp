import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/game/bloc/game_bloc.dart';
import 'package:flutter_application_1/game/repository/game_repo.dart';
import 'package:flutter_application_1/game/screen/game.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';


// Mocki
class MockQuizBloc extends Mock implements QuizBloc {}
class MockGameRepository extends Mock implements GameRepository {}
class FakeQuiz extends Fake implements Quiz {}

void main() {
  late MockQuizBloc quizBloc;
  late MockGameRepository mockRepo;

  final quiz = Quiz(
    numer: 1,
    pytanie: "2+2?",
    odpowiedz1: "1",
    odpowiedz2: "2",
    odpowiedz3: "3",
    odpowiedz4: "4",
    poprawna: "4",
  );

  setUpAll(() {
    registerFallbackValue(const QuizReset(false, 1));
    registerFallbackValue(QuizInitial());
    registerFallbackValue(FakeQuiz());
  });

  setUp(() {
    mockRepo = MockGameRepository();
    when(() => mockRepo.numerPytania).thenReturn(1);
    when(() => mockRepo.lengthQuiz()).thenReturn(10);
    when(() => mockRepo.punkty).thenReturn(0);

    quizBloc = MockQuizBloc();
    when(() => quizBloc.repository).thenReturn(mockRepo);

    when(() => quizBloc.state).thenReturn(QuizInitial());
    whenListen(quizBloc, Stream.value(QuizInitial()),
        initialState: QuizInitial());
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<QuizBloc>.value(
        value: quizBloc,
        child: child,
      ),
    );
  }

  testWidgets('renders CircularProgressIndicator when state is QuizInitial',
      (tester) async {
    await tester.pumpWidget(buildTestable(const Game(isNewGame: true)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error text when state is Error', (tester) async {
    when(() => quizBloc.state).thenReturn(const Error('Błąd!'));
    whenListen(quizBloc, Stream.value(const Error('Błąd!')),
        initialState: const Error('Błąd!'));

    await tester.pumpWidget(buildTestable(const Game(isNewGame: false)));
    expect(find.textContaining('error: Błąd!'), findsOneWidget);
  });

  testWidgets('renders question and answers when state is QuizLoaded',
      (tester) async {
    when(() => quizBloc.state).thenReturn(QuizLoaded(quiz, false, -1));
    whenListen(
        quizBloc, Stream.value(QuizLoaded(quiz, false, -1)),
        initialState: QuizLoaded(quiz, false, -1));

    await tester.pumpWidget(buildTestable(const Game(isNewGame: false)));

    expect(find.text('1. 2+2?'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('tapping an answer dispatches Update event', (tester) async {
    when(() => quizBloc.state).thenReturn(QuizLoaded(quiz, false, -1));
    whenListen(
        quizBloc, Stream.value(QuizLoaded(quiz, false, -1)),
        initialState: QuizLoaded(quiz, false, -1));

    await tester.pumpWidget(buildTestable(const Game(isNewGame: false)));

    await tester.tap(find.text('1'));
    await tester.pump();

    verify(() => quizBloc.add(any(that: isA<Update>()))).called(1);
  });

  testWidgets('FAB dispatches NextQuestion when more questions are available',
      (tester) async {
    when(() => quizBloc.state).thenReturn(QuizLoaded(quiz, false, -1));
    whenListen(
        quizBloc, Stream.value(QuizLoaded(quiz, false, -1)),
        initialState: QuizLoaded(quiz, false, -1));

    await tester.pumpWidget(buildTestable(const Game(isNewGame: false)));

    await tester.tap(find.byIcon(Icons.skip_next));
    await tester.pump();

    verify(() => quizBloc.add(any(that: isA<NextQuestion>()))).called(1);
  });
}
