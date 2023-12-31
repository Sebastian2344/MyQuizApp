import 'package:flutter/material.dart';

import '../bloc/game_bloc.dart';


class CustomAlertDialog extends StatelessWidget {
  final int punkty;
  final QuizBloc quizBloc;
  const CustomAlertDialog(
      {Key? key,
      required this.punkty,
      required this.quizBloc,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: quizBloc.state is Error? const Text('Reset') : const Text('Gratulacje'),
      content: quizBloc.state is Error ? const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Text('Ponowne wczytanie pytania')),
        ] ): Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text('Przeszedłeś cały quiz. Twoje punkty: $punkty. Hurra!'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            quizBloc.add(QuizReset(false, 1));
            Navigator.of(context).pop();
          },
          child: quizBloc.state is Error? const Text('Dokonaj resetu'):const Text('Zagraj jeszcze raz'),
        ),
        ElevatedButton(
          onPressed: () {
            quizBloc.add(QuizReset(false, 1));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('Powrót do menu')
        ),
      ],
    );
  }
}