import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/game/bloc/game_bloc.dart';
import 'package:flutter_application_1/game/screen/game_alert_dialog.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/start_screen/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizBloc extends Mock implements  QuizBloc{}
class FakeQuiz extends Fake implements Quiz{}
void main(){

  late MockQuizBloc quizBloc;
  late GoRouter router;

  setUpAll((){
    registerFallbackValue(const QuizReset(false, 1));
    registerFallbackValue(QuizInitial());
  });

  setUp((){
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/game/true',
          builder: (context, state) => const Scaffold(body: Text('Start Quiz')),
        ),
      ],
    );
    quizBloc = MockQuizBloc();
    when(() => quizBloc.state).thenReturn(QuizInitial());
    whenListen(quizBloc, Stream.value(QuizInitial()), initialState: QuizInitial());
  });

  Future<void> _pumpDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<QuizBloc>.value(
        value: quizBloc,
        child: MaterialApp(
          home: Scaffold(
            body: CustomAlertDialog(punkty: 1,quizBloc: quizBloc,),
          ),
        ),
      ),
    );
  }

  testWidgets('Loaded widget with no errors', (WidgetTester tester) async {
    when(() => quizBloc.state).thenReturn(QuizLoaded(FakeQuiz(), false, 1));
    await _pumpDialog(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Gratulacje'), findsOneWidget);
    expect(find.text('Przeszedłeś cały quiz. Twoje punkty: 1. Hurra!'), findsOneWidget);
      expect(find.text('Zagraj jeszcze raz'), findsOneWidget);
      expect(find.text('Powrót do menu'), findsOneWidget);
  });


  testWidgets('Loaded widget with errors', (WidgetTester tester) async {
    when(() => quizBloc.state).thenReturn(Error(''));
    await _pumpDialog(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Ponowne wczytanie pytania'), findsOneWidget);
    expect(find.text('Dokonaj resetu'), findsOneWidget);
    expect(find.text('Powrót do menu'), findsOneWidget);
  });

 testWidgets('Pokazuje "Zagraj jeszcze raz" gdy brak błędu',
      (WidgetTester tester) async {
    
    when(() => quizBloc.state).thenReturn(QuizInitial());

    await _pumpDialog(tester);

    expect(find.text('Zagraj jeszcze raz'), findsOneWidget);
    expect(find.text('Dokonaj resetu'), findsNothing);
  });

  testWidgets('Pokazuje "Dokonaj resetu" gdy stan to ErrorState',
      (WidgetTester tester) async {
    when(() => quizBloc.state).thenReturn(Error(''));

    await _pumpDialog(tester);

    expect(find.text('Dokonaj resetu'), findsOneWidget);
    expect(find.text('Zagraj jeszcze raz'), findsNothing);
  });

  testWidgets('Kliknięcie wysyła QuizReset i zamyka dialog',
      (WidgetTester tester) async {
    when(() => quizBloc.state).thenReturn(QuizInitial());

    await _pumpDialog(tester);

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    verify(() => quizBloc.add(const QuizReset(false, 1))).called(1);
  });

  testWidgets('Kliknięcie w przycisk wysyła QuizReset i wraca do "/"',
      (tester) async {
    await tester.pumpWidget(
      BlocProvider<QuizBloc>.value(
        value: quizBloc,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    showDialog(
      context: router.routerDelegate.navigatorKey.currentContext!,
      builder: (_) => CustomAlertDialog(punkty: 1, quizBloc: quizBloc,),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Powrót do menu'));
    await tester.pumpAndSettle();

    verify(() => quizBloc.add(const QuizReset(false, 1))).called(1);

    expect(find.text('MENU'), findsOneWidget);
  });
}