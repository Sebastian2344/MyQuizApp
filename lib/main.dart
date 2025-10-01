import 'package:flutter/material.dart';
import 'package:flutter_application_1/game/repository/game_repo.dart';
import 'package:flutter_application_1/navigation/nav.dart';
import 'package:flutter_application_1/quiz_editor/repository/quiz_editor_repo.dart';
import 'package:flutter_application_1/services/baza.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game/bloc/game_bloc.dart';
import 'quiz_editor/cubit/quiz_editor_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> QuizEditorCubit(QuizEditorRepositoryImpl(QuizHelper.instance))..showAllQuestion()),
        BlocProvider(create: (context)=> QuizBloc(GameRepositoryImpl(QuizHelper.instance))),
      ],
      child: MaterialApp.router(
          title: 'Moja Quiz Apka',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color.fromARGB(255, 27, 26, 26)),
          routerConfig: nav,
        ),
    );
  }
}
