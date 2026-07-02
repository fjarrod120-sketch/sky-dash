import 'package:flame/components.dart';

class ProceduralBackground extends Component with HasGameRef<DodgeGame> {
  @override
  void render(Canvas canvas) {
    final size = gameRef.size;
    final rect = Offset.zero & Size(size.x, size.y);
    final gradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: const [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF6A1B9A)],
      ).createShader(rect);
    canvas.drawRect(rect, gradient);
    final starPaint = Paint()..color = const Color(0x80FFFFFF);
    for (var i = 0; i < 50; i++) {
      canvas.drawCircle(Offset((i * 137.5 + 50) % size.x, (i * 97.3 + 20) % (size.y * 0.6)), 1.5 + (i % 3).toDouble(), starPaint);
    }
  }
}
