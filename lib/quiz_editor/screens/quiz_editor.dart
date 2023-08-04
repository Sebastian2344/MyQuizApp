import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/quiz_model.dart';
import '../cubit/quiz_editor_cubit.dart';
import 'quiz_dialog.dart';

class QuizEditor extends StatelessWidget {
  const QuizEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytor Quizu'),
      ),
      body: BlocBuilder<QuizEditorCubit, QuizEditorState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            loaded: (questions) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final quiz = questions[index];
                        return ListTile(
                          title: Text(
                            'Pytanie ${quiz.numer}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            quiz.pytanie,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<QuizEditorCubit>()
                                  .deleteQuestion(quiz);
                            },
                          ),
                          onTap: () {
                            _showEditDialog(context, quiz);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showAddDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text('Dodaj pytanie'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<QuizEditorCubit>().deleteAllQuestion();
                          },
                          child: const Text('Usuń wszystkie pytania'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: () {
              return const Center(
                child: Text('Wystąpił błąd.'),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => QuizDialog(
        lastQuiz: Quiz(pytanie: '', odpowiedz1: '', odpowiedz2: '', odpowiedz3: '', odpowiedz4: '', poprawna: ''),
        onSave: (quiz) {
          context.read<QuizEditorCubit>().addQuestion(quiz);
        },
      ),
    );
  }

  Future<void> _showEditDialog(context, Quiz quiz) async {
    await showDialog(
      context: context,
      builder: (context) => QuizDialog(
        lastQuiz: quiz,
        onSave: (updatedQuiz) {
          context.read<QuizEditorCubit>().updateQuestion(updatedQuiz);
        },
      ),
    );
  }
}