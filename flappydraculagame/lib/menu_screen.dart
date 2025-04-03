import 'package:flutter/material.dart';
import 'package:flame/game.dart'; // Import this for GameWidget
import 'flappy_dracula_game.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key}); // Using super constructor for key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flappy Dracula',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: GameWidget(game: FlappyDraculaGame()),
                    ),
                  ),
                );
              },
              child: const Text('Start Game'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Settings'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
