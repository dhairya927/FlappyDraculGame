import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'flappy_dracula_game.dart'; // Import your game file

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(game: FlappyDraculaGame()), // Start the game
    ),
  );
}
