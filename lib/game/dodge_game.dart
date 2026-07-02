import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import '../economy/currency.dart';
import '../skins/skin_manager.dart';
import '../utils/constants.dart';
import '../utils/storage.dart';
import 'obstacles.dart';
import 'parallax_bg.dart';
import 'particles.dart';
import 'player.dart';
import 'score.dart';

class DodgeGame extends FlameGame with HasCollisionDetection {
  late Player player;
  late ObstacleSpawner spawner;
  late ScoreTracker scoreTracker;
  late ScoreHUD scoreHUD;
  late GameParticles particleSystem;
  late ProceduralBackground background;

  bool _isRunning = false;
  bool _isGameOver = false;
  int _lives = GameConstants.playerMaxLives;

  Function(int score, int gems)? onGameOver;
  Function(int score)? onScoreChanged;

  @override
  Color get backgroundColor => const Color(0xFF1A237E);

  @override
  Future<void> onLoad() async {
    size = Vector2(GameConstants.gameWidth, GameConstants.gameHeight);
    background = ProceduralBackground(); add(background);
    particleSystem = GameParticles(); add(particleSystem);
    scoreTracker = ScoreTracker()
      ..onScoreChanged = (score) { scoreHUD.updateScore(score); onScoreChanged?.call(score); }
      ..onMilestoneReached = (milestone) { _onMilestone(milestone); };
    add(scoreTracker);
    scoreHUD = ScoreHUD(); add(scoreHUD);
    player = Player(this); add(player);
    spawner = ObstacleSpawner(); add(spawner);
    scoreHUD.updateGems(PlayerEconomy().gems);
  }

  void startGame() {
    _isRunning = true; _isGameOver = false; _lives = GameConstants.playerMaxLives;
    player.reset(); spawner.reset(); scoreTracker.reset();
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
  }

  @override
  void update(double dt) {
    if (!_isRunning || _isGameOver) return;
    super.update(dt);
    for (final obstacle in children.whereType<Obstacle>()) {
      if (obstacle.isOffScreenBottom()) {
        if (!obstacle.isRemoving) {
          scoreTracker.addObstaclePassed();
          obstacle.removeFromParent();
        }
      }
    }
  }

  void onCollision(Set<Vector2> points) {
    if (_isGameOver || player.isInvincible) return;
    _lives--;
    if (_lives <= 0) {
      player.die(); _isGameOver = true; _isRunning = false; _onGameOver();
    } else {
      player.setInvincible(true);
      particleSystem.burstAt(player.position, color: const Color(0xFFFF6B6B), count: 6, speed: 100);
      Future.delayed(const Duration(milliseconds: 1500), () { player.setInvincible(false); });
    }
  }

  void onPlayerJump() { particleSystem.jumpTrail(player.position); }

  void onPlayerDeath() {
    particleSystem.deathExplosion(player.position);
    _isGameOver = true; _isRunning = false; _onGameOver();
  }

  void _onMilestone(int milestone) {
    final gems = GameConstants.gemsPerMilestone;
    PlayerEconomy().addGems(gems);
    scoreHUD.updateGems(PlayerEconomy().gems);
    particleSystem.burstAt(Vector2(size.x / 2, size.y / 2), color: const Color(0xFFFFD700), count: 15, speed: 250);
  }

  void _onGameOver() {
    final finalScore = scoreTracker.score;
    final gemsEarned = scoreTracker.calculateGemReward();
    final storage = GameStorage();
    if (finalScore > storage.getHighScore()) storage.setHighScore(finalScore);
    PlayerEconomy().addGems(gemsEarned);
    storage.incrementGamesPlayed();
    storage.addObstaclesPassed(scoreTracker.obstaclesPassed);
    onGameOver?.call(finalScore, gemsEarned);
  }

  Paint getPaintForSkin(String skinId) {
    final colors = {
      'ninja_frog': const Color(0xFF2ECC71), 'pixel_cat': const Color(0xFFE67E22),
      'space_dino': const Color(0xFF3498DB), 'neon_samurai': const Color(0xFF9B59B6),
      'galaxy_bot': const Color(0xFF1ABC9C), 'rainbow_dragon': const Color(0xFFE74C3C),
      'void_knight': const Color(0xFF2C3E50), 'golden_phoenix': const Color(0xFFFFD700),
      'dark_matter': const Color(0xFF8E44AD),
    };
    return Paint()..color = colors[skinId] ?? const Color(0xFF2ECC71);
  }

  bool get isRunning => _isRunning;
  bool get isGameOver => _isGameOver;
}
