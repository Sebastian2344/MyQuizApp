import 'package:flutter_application_1/game/screen/game.dart';
import 'package:flutter_application_1/quiz_editor/screens/quiz_editor.dart';
import 'package:flutter_application_1/start_screen/home_page.dart';
import 'package:go_router/go_router.dart';

final nav = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/quizEditor',
    builder: (context, state) => const QuizEditor(),
  ),
  GoRoute(
    path: '/game/:isNewGame',
    builder: (context, state) => Game(isNewGame: bool.parse(state.pathParameters['isNewGame']!),),
  )
]);
