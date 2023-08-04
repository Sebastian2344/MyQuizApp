
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/quiz_model.dart';
import '../bloc/game_bloc.dart';
import 'game_alert_dialog.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => GameState();
}

class GameState extends State<Game> {

  Color tloOdp = const Color.fromARGB(255, 114, 118, 112);
  Color tloOdp2 = const Color.fromARGB(255, 157, 161, 156);
  Color tloOdpPopr = Colors.green;
  Color tloOdpZla = const Color.fromARGB(255, 253, 4, 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('QUIZ'),
        centerTitle: true,
      ),
      body: Center(
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is Error) {
              return Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('error: ${state.error}',style: const TextStyle(color: Colors.white),),
              ));
            }
            if (state is QuizLoaded) {
              return Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: Colors.amberAccent,
                  margin: const EdgeInsets.all(30.0),
                  child: Center(
                      child:
                          Text('${state.quiz.numer}. ${state.quiz.pytanie}')),
                ),
                Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / 250,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                             context.read<QuizBloc>().add(Update(true,state.dobryIndex,state.quiz,index));                    
                          },
                          child: Container(
                            color: state.czyKlik
                                ? index == state.dobryIndex
                                    ? tloOdpPopr
                                    : tloOdpZla
                                : (index == 0 || index == 3)
                                    ? tloOdp
                                    : tloOdp2,
                            margin: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(index == 0
                                    ? state.quiz.odpowiedz1
                                    : index == 1
                                        ? state.quiz.odpowiedz2
                                        : index == 2
                                            ? state.quiz.odpowiedz3
                                            : state.quiz.odpowiedz4),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'Punkty ${Quiz.punkty}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ]);
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            final QuizBloc quizBloc = BlocProvider.of<QuizBloc>(context);
          if (context.read<QuizBloc>().baza.lengthQuiz <= context.read<QuizBloc>().baza.numerPyt) {
            showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                      punkty: Quiz.punkty,
                      quizBloc: quizBloc,
                    ));
          } else {
            BlocProvider.of<QuizBloc>(context)
                .add(NextQuestion(false, -1,context.read<QuizBloc>().baza.numerPyt));
          }
        },
        tooltip: 'Następne pytanie',
        child:const Icon(Icons.skip_next),
      ),
    );
  }
}