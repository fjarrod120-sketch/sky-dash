import 'dart:math';
import 'package:flame/components.dart';
import 'dodge_game.dart';

class GameParticles extends Component with HasGameRef<DodgeGame> {
  final Random _random = Random();

  void burstAt(Vector2 position, {Color color = const Color(0xFFFFD700), int count = 8, double speed = 200}) {
    for (var i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final particleColor = Color.fromARGB(255,
        (color.red * (0.5 + _random.nextDouble() * 0.5)).round(),
        (color.green * (0.5 + _random.nextDouble() * 0.5)).round(),
        (color.blue * (0.5 + _random.nextDouble() * 0.5)).round(),
      );
      final particle = _Particle(
        position: position.clone(),
        velocity: Vector2(cos(angle) * speed * (0.5 + _random.nextDouble()), sin(angle) * speed * (0.5 + _random.nextDouble())),
        color: particleColor,
        size: 4 + _random.nextDouble() * 4,
        lifetime: 0.5 + _random.nextDouble() * 0.5,
      );
      gameRef.add(particle);
    }
  }

  void deathExplosion(Vector2 position) {
    burstAt(position, color: const Color(0xFFFF4444), count: 20, speed: 300);
    burstAt(position, color: const Color(0xFFFFFFFF), count: 8, speed: 150);
  }

  void jumpTrail(Vector2 position) {
    for (var i = 0; i < 3; i++) {
      final trail = _Particle(
        position: position.clone() + Vector2(_random.nextDouble() * 20 - 10, 20 + _random.nextDouble() * 10),
        velocity: Vector2(0, 50 + _random.nextDouble() * 50),
        color: const Color(0x80FFFFFF),
        size: 3 + _random.nextDouble() * 3,
        lifetime: 0.2 + _random.nextDouble() * 0.2,
      );
      gameRef.add(trail);
    }
  }
}

class _Particle extends SpriteComponent {
  final Vector2 velocity;
  final double lifetime;
  double _age = 0;

  _Particle({required Vector2 position, required this.velocity, required Color color, required double size, required this.lifetime})
      : super(position: position, size: Vector2.all(size), anchor: Anchor.center) { paint = Paint()..color = color; }

  @override
  Future<void> onLoad() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, Paint()..color = paint.color);
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.x.toInt(), size.y.toInt());
    sprite = Sprite(image);
  }

  @override
  void update(double dt) {
    _age += dt;
    position += velocity * dt;
    velocity.y += 200 * dt;
    opacity = 1.0 - (_age / lifetime);
    if (_age >= lifetime) removeFromParent();
  }
}
