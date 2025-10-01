import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/quiz_editor/cubit/quiz_editor_cubit.dart';
import 'package:flutter_application_1/quiz_editor/repository/quiz_editor_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepository extends Mock implements QuizEditorRepository {}

void main() {
  late QuizEditorRepository repository;
  late QuizEditorCubit bloc;

  setUp(() {
    repository = MockQuizRepository();
    bloc = QuizEditorCubit(repository);
  });

  tearDown(() {
    bloc.close();
  });

  setUpAll((){
    registerFallbackValue(Quiz(pytanie: '', odpowiedz1: '', odpowiedz2: '', odpowiedz3: '', odpowiedz4: '', poprawna: ''));
  });

  group('QuizEditorCubit', () {
    final quiz = Quiz(numer: 1,pytanie: 'pytanie', odpowiedz1: 'a', odpowiedz2: 'b', odpowiedz3: 'c', odpowiedz4: 'd', poprawna: 'a');
    blocTest<QuizEditorCubit, QuizEditorState>(
      'addQuestion -> emituje [initial, loaded]',
      build: () {
        when(() => repository.addItem(any())).thenAnswer((_) async {});
        when(() => repository.fetchItems()).thenAnswer((_) async => [quiz]);
        when(() => repository.lengthQuiz()).thenAnswer((_) async => 1);
        return bloc;
      },
      act: (cubit) async => await cubit.addQuestion(quiz),
      expect: () => [
        const QuizEditorState.initial(),
        QuizEditorState.loaded([quiz]),
      ],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'addQuestion -> błąd',
      build: () {
        when(() => repository.addItem(any())).thenThrow(Exception("db error"));
        return bloc;
      },
      act: (cubit) async => await cubit.addQuestion(quiz),
      expect: () => [const QuizEditorState.error()],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'deleteQuestion -> emituje [initial, loaded]',
      build: () {
        when(() => repository.deleteItem(any())).thenAnswer((_) async {});
        when(() => repository.fetchItems()).thenAnswer((_) async => []);
        when(() => repository.lengthQuiz()).thenAnswer((_) async => 0);
        return bloc;
      },
      act: (cubit) async => await cubit.deleteQuestion(quiz),
      expect: () => [
        const QuizEditorState.initial(),
        QuizEditorState.loaded([]),
      ],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'deleteQuestion -> błąd',
      build: () {
        when(() => repository.deleteItem(any())).thenThrow(Exception("err"));
        return bloc;
      },
      act: (cubit) async => await cubit.deleteQuestion(quiz),
      expect: () => [const QuizEditorState.error()],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'updateQuestion -> emituje [initial, loaded]',
      build: () {
        when(() => repository.updateItem(any())).thenAnswer((_) async {});
        when(() => repository.fetchItems()).thenAnswer((_) async => [quiz]);
        when(() => repository.lengthQuiz()).thenAnswer((_) async => 1);
        return bloc;
      },
      act: (cubit) async => await cubit.updateQuestion(quiz),
      expect: () => [
        const QuizEditorState.initial(),
        QuizEditorState.loaded([quiz]),
      ],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'updateQuestion -> błąd',
      build: () {
        when(() => repository.updateItem(any())).thenThrow(Exception("err"));
        return bloc;
      },
      act: (cubit) async => await cubit.updateQuestion(quiz),
      expect: () => [const QuizEditorState.error()],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'deleteAllQuestion -> emituje [initial, loaded]',
      build: () {
        when(() => repository.deleteAll()).thenAnswer((_) async {});
        when(() => repository.fetchItems()).thenAnswer((_) async => []);
        when(() => repository.lengthQuiz()).thenAnswer((_) async => 0);
        return bloc;
      },
      act: (cubit) async => await cubit.deleteAllQuestion(),
      expect: () => [
        const QuizEditorState.initial(),
        QuizEditorState.loaded([]),
      ],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'deleteAllQuestion -> błąd',
      build: () {
        when(() => repository.deleteAll()).thenThrow(Exception("err"));
        return bloc;
      },
      act: (cubit) async => await cubit.deleteAllQuestion(),
      expect: () => [const QuizEditorState.error()],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'showAllQuestion -> emituje [initial, loaded]',
      build: () {
        when(() => repository.fetchItems()).thenAnswer((_) async => [quiz]);
        when(() => repository.lengthQuiz()).thenAnswer((_) async => 1);
        return bloc;
      },
      act: (cubit) async => await cubit.showAllQuestion(),
      expect: () => [
        const QuizEditorState.initial(),
        QuizEditorState.loaded([quiz]),
      ],
    );

    blocTest<QuizEditorCubit, QuizEditorState>(
      'showAllQuestion -> błąd',
      build: () {
        when(() => repository.fetchItems()).thenThrow(Exception("err"));
        return bloc;
      },
      act: (cubit) async => await cubit.showAllQuestion(),
      expect: () => [const QuizEditorState.initial(),const QuizEditorState.error()],
    );
  });
}
