import 'package:flutter/material.dart';
import '../game/screen/game.dart';
import '../quiz_editor/screens/quiz_editor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MENU'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width*0.85,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const Game())));
                  },
                  child: const Text('Rozpocznij quiz',
                      style: TextStyle(fontSize: 40, color: Colors.white))),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width*0.85,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.indigo)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const QuizEditor())));
                  },
                  child: const Center(
                    child: Text('Stwórz swoje pytania',
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
