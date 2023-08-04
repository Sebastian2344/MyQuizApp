import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/baza.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game/bloc/game_bloc.dart';
import 'start_screen/home_page.dart';
import 'quiz_editor/cubit/quiz_editor_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> QuizEditorCubit(QuizHelper.instance)..showAllQuestion()),
        BlocProvider(create: (context)=> QuizBloc(QuizHelper.instance)..add(LoadQuestion(1))),
      ],
      child: MaterialApp(
          title: 'Moja Quiz Apka',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color.fromARGB(255, 27, 26, 26)),
          home: const Scaffold(body: HomePage()),
        ),
    );
  }
}
