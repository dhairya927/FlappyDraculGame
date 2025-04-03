import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FlappyDraculaGame extends FlameGame with HasCollisionDetection {
  late DraculaPlayer dracula;
  late Timer obstacleTimer;
  int score = 0;
  bool isGameOver = false;
  bool isGameStarted = false;
  bool soundOn = true;
  bool musicOn = true;
  double brightness = 1.0;
  String difficulty = 'Normal';

  @override
  Future<void> onLoad() async {
    add(MainMenu(game: this));
  }

  void startGame() async {
    isGameStarted = true;
    isGameOver = false;
    score = 0;
    removeAll(children);

    final parallax = await loadParallax([
      ParallaxImageData('spooky_layer1.png'),
      ParallaxImageData('spooky_layer2.png')
    ], baseVelocity: Vector2(50, 0));
    add(ParallaxComponent(parallax: parallax));

    dracula = DraculaPlayer();
    add(dracula);

    if (musicOn) {
      FlameAudio.bgm.play('bg_music.mp3', volume: 0.5);
    }

    obstacleTimer = Timer(2, repeat: true, onTick: addObstacle);
    obstacleTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameStarted && !isGameOver) {
      obstacleTimer.update(dt);
    }
  }

  void addObstacle() {
    final double xPos = size.x;
    final double gapSize = difficulty == 'Easy'
        ? 180
        : difficulty == 'Hard'
            ? 120
            : 150;
    final double randomHeight =
        Random().nextDouble() * (size.y - gapSize - 200) + 100;

    final obstacleImages = [
      'graveyard1.png',
      'graveyard2.png',
      'graveyard3.png'
    ];
    final obstacleImage =
        obstacleImages[Random().nextInt(obstacleImages.length)];

    final bottomObstacle =
        GraveyardObstacle(Vector2(xPos, randomHeight + gapSize), obstacleImage);
    final topObstacle =
        GraveyardObstacle(Vector2(xPos, randomHeight), obstacleImage)
          ..angle = 3.14;

    add(bottomObstacle);
    add(topObstacle);
  }

  void gameOver() {
    isGameOver = true;
    FlameAudio.bgm.stop();
    FlameAudio.play('crash.mp3');
    add(GameOverOverlay(score, game: this));
  }

  void restartGame() {
    startGame();
  }

  void exitGame() {
    isGameStarted = false;
    removeAll(children);
    add(MainMenu(game: this));
  }
}

class DraculaPlayer extends SpriteComponent {
  DraculaPlayer() : super(size: Vector2(50, 50));
}

class GraveyardObstacle extends SpriteComponent {
  GraveyardObstacle(Vector2 position, String spritePath)
      : super(position: position, size: Vector2(50, 200));
}

class FlameButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;

  FlameButton(
      {required this.text,
      required Vector2 position,
      required this.onPressed}) {
    this.position = position;
    size = Vector2(150, 50);
  }

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
          style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}

class MainMenu extends PositionComponent {
  final FlappyDraculaGame game;
  MainMenu({required this.game});

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: 'Flappy Dracula',
      position: Vector2(game.size.x / 2, game.size.y / 4),
      anchor: Anchor.center,
      textRenderer: TextPaint(
          style: const TextStyle(
        fontSize: 36,
        color: Colors.red,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 5, color: Colors.black, offset: Offset(3, 3))
        ],
      )),
    ));

    add(FlameButton(
      text: 'Start Game',
      position: Vector2(game.size.x / 2 - 75, game.size.y / 2),
      onPressed: () => game.startGame(),
    ));
  }
}

class GameOverOverlay extends PositionComponent {
  final int finalScore;
  final FlappyDraculaGame game;
  GameOverOverlay(this.finalScore, {required this.game});

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: 'Game Over! Score: $finalScore',
      position: Vector2(game.size.x / 2, game.size.y / 3),
      anchor: Anchor.center,
      textRenderer: TextPaint(
          style: const TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )),
    ));

    add(FlameButton(
      text: 'Restart',
      position: Vector2(game.size.x / 2 - 75, game.size.y / 2),
      onPressed: () => game.restartGame(),
    ));

    add(FlameButton(
      text: 'Exit',
      position: Vector2(game.size.x / 2 - 75, game.size.y / 2 + 60),
      onPressed: () => game.exitGame(),
    ));
  }
}
