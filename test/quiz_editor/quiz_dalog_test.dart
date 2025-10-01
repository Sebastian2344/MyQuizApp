import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/quiz_model.dart';
import 'package:flutter_application_1/quiz_editor/screens/quiz_dialog.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  late Quiz lastQuiz;

  setUp(() {
    lastQuiz = Quiz(
      numer: 1,
      pytanie: 'Jak masz na imię?',
      odpowiedz1: 'Adam',
      odpowiedz2: 'Ewa',
      odpowiedz3: 'Jan',
      odpowiedz4: 'Anna',
      poprawna: 'Adam',
    );
  });

  Widget buildDialog({required Quiz quiz, required void Function(Quiz) onSave}) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => QuizDialog(lastQuiz: quiz, onSave: onSave),
            ),
            child: const Text('Open Dialog'),
          );
        },
      ),
    );
  }

  testWidgets('renders all fields and title', (tester) async {
    await tester.pumpWidget(buildDialog(quiz: lastQuiz, onSave: (_) {}));
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Edytuj pytanie'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
    expect(find.text('Zapisz'), findsOneWidget);
    expect(find.text('Anuluj'), findsOneWidget);
  });

  testWidgets('tapping Anuluj closes dialog', (tester) async {
    await tester.pumpWidget(buildDialog(quiz: lastQuiz, onSave: (_) {}));
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('tapping Zapisz with empty fields shows error', (tester) async {
    final emptyQuiz = Quiz(
      numer: 1,
      pytanie: '',
      odpowiedz1: '',
      odpowiedz2: '',
      odpowiedz3: '',
      odpowiedz4: '',
      poprawna: '',
    );

    await tester.pumpWidget(buildDialog(quiz: emptyQuiz, onSave: (_) {}));
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Uzupełnij puste miejsca!'), findsOneWidget);

    // zamknięcie błędu
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  });

  testWidgets('tapping Zapisz with invalid correct answer shows error', (tester) async {
    final invalidQuiz = Quiz(
      numer: 1,
      pytanie: 'Pytanie',
      odpowiedz1: 'A',
      odpowiedz2: 'B',
      odpowiedz3: 'C',
      odpowiedz4: 'D',
      poprawna: 'X', // nie pasuje do żadnej odpowiedzi
    );

    await tester.pumpWidget(buildDialog(quiz: invalidQuiz, onSave: (_) {}));
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Brak poprwnej odpowiedzi'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  });

  testWidgets('tapping Zapisz with valid fields calls onSave and closes dialog', (tester) async {
    Quiz? savedQuiz;
    bool saved = false;

    await tester.pumpWidget(buildDialog(
      quiz: lastQuiz,
      onSave: (quiz) {
        saved = true;
        savedQuiz = quiz;
      },
    ));

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Nowe pytanie');
    await tester.enterText(find.byType(TextField).at(5), 'Adam'); // poprawna odpowiedź

    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(saved, isTrue);
    expect(savedQuiz?.pytanie, 'Nowe pytanie');
    expect(find.byType(AlertDialog), findsNothing);
  });
}
