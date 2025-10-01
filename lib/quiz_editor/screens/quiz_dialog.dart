import 'package:flutter/material.dart';

import '../../model/quiz_model.dart';

class QuizDialog extends StatelessWidget {
  final Quiz lastQuiz;
  final void Function(Quiz) onSave;

   QuizDialog({
    super.key,
    required this.lastQuiz,
    required this.onSave,
  });
  
  late final TextEditingController _pytanieController = TextEditingController(text: lastQuiz.pytanie);
  late final TextEditingController _odpowiedz1Controller = TextEditingController(text: lastQuiz.odpowiedz1);
  late final TextEditingController _odpowiedz2Controller = TextEditingController(text: lastQuiz.odpowiedz2);
  late final TextEditingController _odpowiedz3Controller = TextEditingController(text: lastQuiz.odpowiedz3);
  late final TextEditingController _odpowiedz4Controller = TextEditingController(text: lastQuiz.odpowiedz4);
  late final TextEditingController _poprawnaController = TextEditingController(text: lastQuiz.poprawna);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(lastQuiz.pytanie == '' ? 'Dodaj pytanie' : 'Edytuj pytanie'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _pytanieController,
              decoration: const InputDecoration(labelText: 'Pytanie'),
            ),
            TextField(
              controller: _odpowiedz1Controller,
              decoration: const InputDecoration(labelText: 'Odpowiedź 1'),
            ),
            TextField(
              controller: _odpowiedz2Controller,
              decoration: const InputDecoration(labelText: 'Odpowiedź 2'),
            ),
            TextField(
              controller: _odpowiedz3Controller,
              decoration: const InputDecoration(labelText: 'Odpowiedź 3'),
            ),
            TextField(
              controller: _odpowiedz4Controller,
              decoration: const InputDecoration(labelText: 'Odpowiedź 4'),
            ),
            TextField(
              controller: _poprawnaController,
              decoration:
                  const InputDecoration(labelText: 'Poprawna odpowiedź'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        TextButton(
          onPressed: () {
            if (_pytanieController.text != '' ||
                _odpowiedz1Controller.text != '' ||
                _odpowiedz2Controller.text != '' ||
                _odpowiedz3Controller.text != '' ||
                _odpowiedz4Controller.text != '' ||
                _poprawnaController.text != '') {
              if (_poprawnaController.text == _odpowiedz1Controller.text ||
                  _poprawnaController.text == _odpowiedz2Controller.text ||
                  _poprawnaController.text == _odpowiedz3Controller.text ||
                  _poprawnaController.text == _odpowiedz4Controller.text) {
                final quiz = Quiz(
                  numer: lastQuiz.numer,
                  pytanie: _pytanieController.text,
                  odpowiedz1: _odpowiedz1Controller.text,
                  odpowiedz2: _odpowiedz2Controller.text,
                  odpowiedz3: _odpowiedz3Controller.text,
                  odpowiedz4: _odpowiedz4Controller.text,
                  poprawna: _poprawnaController.text,
                );
                onSave(quiz);
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'Brak poprwnej odpowiedzi w odpowiedziach na pytanie'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'))
                      ],
                    );
                  },
                );
              }
            }else{
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'Uzupełnij puste miejsca! Zapiać można tylko całość'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'))
                    ],
                  );
                });
            }     
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}