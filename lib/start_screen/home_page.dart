import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  onPressed: () {
                    context.go('/game/true');
                  },
                  child: const Text('Rozpocznij quiz',
                      style: TextStyle(fontSize: 40, color: Colors.white))),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width*0.85,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.orange)),
                  onPressed: () {
                    context.go('/game/false');
                  },
                  child: const Text('Kontynuuj quiz',
                      style: TextStyle(fontSize: 40, color: Colors.white))),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width*0.85,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
                  onPressed: () {
                    context.go('/quizEditor');
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
