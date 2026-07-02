import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/dodge_game.dart';
import '../utils/constants.dart';
import '../utils/storage.dart';
import 'menu_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final DodgeGame _game;
  int _lives = GameConstants.playerMaxLives;

  @override
  void initState() {
    super.initState();
    _game = DodgeGame(size: Vector2(GameConstants.gameWidth, GameConstants.gameHeight))
      ..onGameOver = _onGameOver;
    _game.startGame();
  }

  void _onGameOver(int score, int gems) {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => GameOverScreen(score: score, gems: gems)),
        );
      }
    });
  }

  @override
  void dispose() { _game.onGameOver = null; super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned(top: 100, right: 20, child: GestureDetector(
            onTap: () => _showPauseMenu(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.pause, color: Colors.white, size: 28),
            ),
          )),
          Positioned(top: 100, left: 20, child: Row(
            children: List.generate(GameConstants.playerMaxLives, (i) =>
              Icon(Icons.favorite, color: i < _lives ? Colors.red : Colors.grey, size: 24)),
          )),
        ],
      ),
    );
  }

  void _showPauseMenu() {
    _game.pauseEngine();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text('Paused', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _menuButton('Resume', () { Navigator.pop(ctx); _game.resumeEngine(); }),
        const SizedBox(height: 8),
        _menuButton('Quit', () {
          Navigator.pop(ctx); _game.resumeEngine();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MenuScreen()));
        }),
      ]),
    ));
  }

  Widget _menuButton(String label, VoidCallback onTap) => SizedBox(width: double.infinity, child: ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
    child: Text(label, style: const TextStyle(fontSize: 16)),
  ));
}

class GameOverScreen extends StatelessWidget {
  final int score; final int gems;
  const GameOverScreen({super.key, required this.score, required this.gems});

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();
    final highScore = storage.getHighScore();
    final isNewHighScore = score >= highScore && score > 0;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('GAME OVER', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.redAccent[200], letterSpacing: 4)),
          const SizedBox(height: 40),
          Text('$score', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white)),
          if (isNewHighScore) const Text('NEW HIGH SCORE! 🏆', style: TextStyle(fontSize: 20, color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('High Score: $highScore', style: const TextStyle(fontSize: 18, color: Colors.white54)),
          const SizedBox(height: 24),
          Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('💎', style: TextStyle(fontSize: 28)), const SizedBox(width: 8),
              Text('+$gems', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
            ])),
          const SizedBox(height: 40),
          _bigButton('Play Again', const Color(0xFF6C63FF), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen()))),
          const SizedBox(height: 12),
          _bigButton('Watch Ad & Revive', const Color(0xFFE67E22), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen()))),
          const SizedBox(height: 12),
          _bigButton('Menu', Colors.white24, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuScreen()))),
        ],
      ))),
    );
  }

  Widget _bigButton(String label, Color color, VoidCallback onTap) => SizedBox(width: 280, child: ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  ));
}
