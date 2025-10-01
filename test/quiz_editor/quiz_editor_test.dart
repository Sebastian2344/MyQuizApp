import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/quiz_editor/cubit/quiz_editor_cubit.dart';
import 'package:flutter_application_1/quiz_editor/screens/quiz_dialog.dart';
import 'package:flutter_application_1/quiz_editor/screens/quiz_editor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';


class MockQuizEditorCubit extends Mock implements QuizEditorCubit {}
class FakeQuiz extends Fake implements Quiz {}

void main() {
  late MockQuizEditorCubit cubit;
  late Quiz quiz1;
  late Quiz quiz2;

  setUpAll(() {
    registerFallbackValue(FakeQuiz());
  });

  setUp(() {
    cubit = MockQuizEditorCubit();

    quiz1 = Quiz(
      numer: 1,
      pytanie: 'Pytanie 1',
      odpowiedz1: 'A',
      odpowiedz2: 'B',
      odpowiedz3: 'C',
      odpowiedz4: 'D',
      poprawna: 'A',
    );

    quiz2 = Quiz(
      numer: 2,
      pytanie: 'Pytanie 2',
      odpowiedz1: 'A2',
      odpowiedz2: 'B2',
      odpowiedz3: 'C2',
      odpowiedz4: 'D2',
      poprawna: 'B2',
    );
  });

  Widget buildTestable() {
    return MaterialApp(
      home: BlocProvider<QuizEditorCubit>.value(
        value: cubit,
        child: const QuizEditor(),
      ),
    );
  }

  testWidgets('renders CircularProgressIndicator when state is initial', (tester) async {
    when(() => cubit.state).thenReturn(const QuizEditorState.initial());
    whenListen(cubit, Stream.value(const QuizEditorState.initial()),
        initialState: const QuizEditorState.initial());

    await tester.pumpWidget(buildTestable());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders ListView with questions when state is loaded', (tester) async {
    when(() => cubit.state).thenReturn(QuizEditorState.loaded([quiz1, quiz2]));
    whenListen(cubit, Stream.value(QuizEditorState.loaded([quiz1, quiz2])),
        initialState: QuizEditorState.loaded([quiz1, quiz2]));

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Pytanie 1').first, findsOneWidget);
    expect(find.text('Pytanie 2').first, findsOneWidget);
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
    expect(find.text('Dodaj pytanie'), findsOneWidget);
    expect(find.text('Usuń wszystkie pytania'), findsOneWidget);
  });

  testWidgets('tapping delete icon calls deleteQuestion', (tester) async {
    when(() => cubit.state).thenReturn(QuizEditorState.loaded([quiz1]));
    when(() => cubit.deleteQuestion(any())).thenAnswer((_) async {});
    whenListen(cubit, Stream.value(QuizEditorState.loaded([quiz1])),
        initialState: QuizEditorState.loaded([quiz1]));

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    verify(() => cubit.deleteQuestion(quiz1)).called(1);
  });

  testWidgets('tapping "Usuń wszystkie pytania" calls deleteAllQuestion', (tester) async {
    when(() => cubit.state).thenReturn(QuizEditorState.loaded([quiz1, quiz2]));
    when(() => cubit.deleteAllQuestion()).thenAnswer((_) async {});
    whenListen(cubit, Stream.value(QuizEditorState.loaded([quiz1, quiz2])),
        initialState: QuizEditorState.loaded([quiz1, quiz2]));

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Usuń wszystkie pytania'));
    verify(() => cubit.deleteAllQuestion()).called(1);
  });

  testWidgets('tapping "Dodaj pytanie" opens QuizDialog', (tester) async {
    when(() => cubit.state).thenReturn(QuizEditorState.loaded([quiz1]));
    whenListen(cubit, Stream.value(QuizEditorState.loaded([quiz1])),
        initialState: QuizEditorState.loaded([quiz1]));

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dodaj pytanie'));
    await tester.pumpAndSettle();

    expect(find.byType(QuizDialog), findsOneWidget);
  });

  testWidgets('tapping ListTile opens QuizDialog for editing', (tester) async {
    when(() => cubit.state).thenReturn(QuizEditorState.loaded([quiz1]));
    whenListen(cubit, Stream.value(QuizEditorState.loaded([quiz1])),
        initialState: QuizEditorState.loaded([quiz1]));

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pytanie 1').first);
    await tester.pumpAndSettle();

    expect(find.byType(QuizDialog), findsOneWidget);
  });
}
