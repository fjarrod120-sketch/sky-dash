import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/effects.dart';
import '../utils/constants.dart';
import 'dodge_game.dart';

enum ObstacleType { pipe, spike, barrier, spinner }

class Obstacle extends SpriteComponent with HasHitboxes, Collidable {
  final DodgeGame _gameRef;
  final ObstacleType type;
  double speed;

  Obstacle(this._gameRef, this.type, {required this.speed}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    size = Vector2(
      GameConstants.obstacleWidth + (type == ObstacleType.spike ? 20 : 0) + (type == ObstacleType.barrier ? 60 : 0),
      type == ObstacleType.pipe ? _gameRef.size.y * 0.6 : GameConstants.obstacleWidth,
    );
    sprite = await _createObstacleSprite();
    final hitbox = HitboxRectangle()..size = size * 0.85..anchor = Anchor.center;
    addHitbox(hitbox);
  }

  Future<Sprite> _createObstacleSprite() async {
    final w = size.x.toInt();
    final h = size.y.toInt();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    switch (type) {
      case ObstacleType.pipe:
        paint.color = const Color(0xFF2ECC71);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), const Radius.circular(8)), paint);
        paint.color = const Color(0xFF27AE60);
        canvas.drawRect(Rect.fromLTWH(0, h.toDouble() * 0.85, w.toDouble(), h.toDouble() * 0.15), paint);
      case ObstacleType.spike:
        paint.color = const Color(0xFFE74C3C);
        final path = Path()..moveTo(0, h.toDouble())..lineTo(w.toDouble() / 2, 0)..lineTo(w.toDouble(), h.toDouble())..close();
        canvas.drawPath(path, paint);
      case ObstacleType.barrier:
        paint.color = const Color(0xFF9B59B6);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), const Radius.circular(4)), paint);
        paint.color = const Color(0xFF8E44AD);
        for (var i = 0; i < 4; i++) {
          canvas.drawCircle(Offset(w.toDouble() / 2, (i + 0.5) * h.toDouble() / 4), 4, paint);
        }
      case ObstacleType.spinner:
        paint.color = const Color(0xFFF39C12);
        canvas.drawCircle(Offset(w.toDouble() / 2, h.toDouble() / 2), w.toDouble() / 2, paint);
        paint.color = const Color(0xFFE67E22);
        canvas.drawCircle(Offset(w.toDouble() / 2, h.toDouble() / 2), w.toDouble() / 4, paint);
        add(RotateEffect.to(2 * pi, EffectController(duration: 2.0, infinite: true)));
    }
    final picture = recorder.endRecording();
    final image = await picture.toImage(w, h);
    return Sprite(image);
  }

  @override
  void update(double dt) {
    position.y += speed * dt;
    if (position.y > _gameRef.size.y + size.y + 50) removeFromParent();
  }

  bool isOffScreenBottom() => position.y > _gameRef.size.y + size.y;
}

class ObstacleSpawner extends Component with HasGameRef<DodgeGame> {
  double _spawnTimer = 2.0;
  double _currentSpawnInterval = GameConstants.spawnIntervalInitial;
  double _currentSpeed = GameConstants.initialSpeed;
  final Random _random = Random();

  @override
  void update(double dt) {
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnObstacle();
      _increaseDifficulty();
      _spawnTimer = _currentSpawnInterval;
    }
  }

  void _spawnObstacle() {
    final types = ObstacleType.values;
    final type = types[_random.nextInt(types.length)];
    final obstacle = Obstacle(gameRef, type, speed: _currentSpeed);
    final margin = obstacle.size.x;
    obstacle.position = Vector2(margin + _random.nextDouble() * (gameRef.size.x - margin * 2), -obstacle.size.y);

    if (type == ObstacleType.pipe) {
      final gapY = GameConstants.obstacleMinGap + _random.nextDouble() * (GameConstants.obstacleMaxGap - GameConstants.obstacleMinGap);
      obstacle.position.y = -obstacle.size.y;
      gameRef.add(obstacle);
      final topPipe = Obstacle(gameRef, ObstacleType.pipe, speed: _currentSpeed)
        ..size = obstacle.size.clone()
        ..position = Vector2(obstacle.position.x, gameRef.size.y + topPipe.size.y / 2);
      final offset = (gameRef.size.y - gapY) / 2;
      obstacle.position.y = -obstacle.size.y + offset;
      topPipe.position.y = gameRef.size.y - offset;
      gameRef.add(topPipe);
    } else {
      gameRef.add(obstacle);
    }
  }

  void _increaseDifficulty() {
    _currentSpeed = (_currentSpeed + GameConstants.speedIncrement).clamp(GameConstants.initialSpeed, GameConstants.maxSpeed);
    _currentSpawnInterval = (_currentSpawnInterval - GameConstants.spawnIntervalDecrement).clamp(GameConstants.spawnIntervalMin, GameConstants.spawnIntervalInitial);
  }

  void reset() { _spawnTimer = 2.0; _currentSpawnInterval = GameConstants.spawnIntervalInitial; _currentSpeed = GameConstants.initialSpeed; }
  double get currentSpeed => _currentSpeed;
}
