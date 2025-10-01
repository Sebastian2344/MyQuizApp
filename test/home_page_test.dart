import 'package:flutter/material.dart';
import 'package:flutter_application_1/start_screen/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  setUp(() {
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
        GoRoute(
          path: '/game/false',
          builder: (context, state) => const Scaffold(body: Text('Continue Quiz')),
        ),
        GoRoute(
          path: '/quizEditor',
          builder: (context, state) => const Scaffold(body: Text('Quiz Editor')),
        ),
      ],
    );
  });

  testWidgets('Wyświetla tytuł MENU i przyciski', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    expect(find.text('MENU'), findsOneWidget);
    expect(find.text('Rozpocznij quiz'), findsOneWidget);
    expect(find.text('Kontynuuj quiz'), findsOneWidget);
    expect(find.text('Stwórz swoje pytania'), findsOneWidget);
  });

  testWidgets('Kliknięcie w "Rozpocznij quiz" przechodzi na /game/true',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.tap(find.text('Rozpocznij quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('Kliknięcie w "Kontynuuj quiz" przechodzi na /game/false',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.tap(find.text('Kontynuuj quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Continue Quiz'), findsOneWidget);
  });

  testWidgets('Kliknięcie w "Stwórz swoje pytania" przechodzi na /quizEditor',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.tap(find.text('Stwórz swoje pytania'));
    await tester.pumpAndSettle();

    expect(find.text('Quiz Editor'), findsOneWidget);
  });
}