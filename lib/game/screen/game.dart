import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

//import '../../model/quiz_model.dart';
import '../bloc/game_bloc.dart';
import 'game_alert_dialog.dart';

class Game extends StatefulWidget {
  const Game({super.key,required this.isNewGame});
  final bool isNewGame;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final Color tloOdp = const Color.fromARGB(255, 114, 118, 112);

  final Color tloOdp2 = const Color.fromARGB(255, 157, 161, 156);

  final Color tloOdpPopr = Colors.green;

  final Color tloOdpZla = const Color.fromARGB(255, 253, 4, 4);

  @override
  void initState() {
    widget.isNewGame &&
            context.read<QuizBloc>().repository.numerPytania > 1
        ? context.read<QuizBloc>().add(const QuizReset(true, 1))
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('QUIZ'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.go('/');
              context.read<QuizBloc>().add(const QuizReset(false, 1));
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is Error) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'error: ${state.error}',
                  style: const TextStyle(color: Colors.white),
                ),
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
                            context.read<QuizBloc>().add(Update(
                                true, state.dobryIndex, state.quiz, index));
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
                      'Punkty ${context.read<QuizBloc>().repository.punkty}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ]);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final QuizBloc quizBloc = BlocProvider.of<QuizBloc>(context);
          if (context.read<QuizBloc>().repository.lengthQuiz() <=
              context.read<QuizBloc>().repository.numerPytania) {
            showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                      punkty: quizBloc.repository.punkty,
                      quizBloc: quizBloc,
                    ));
          } else {
            BlocProvider.of<QuizBloc>(context).add(NextQuestion(
                false, -1, context.read<QuizBloc>().repository.numerPytania));
          }
        },
        tooltip: 'Następne pytanie',
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}
