import 'package:flame/components.dart';
import '../utils/constants.dart';

class ScoreHUD extends Component with HasGameRef<DodgeGame> {
  late TextComponent _scoreText;
  late TextComponent _gemText;
  int currentScore = 0;

  @override
  Future<void> onLoad() async {
    _scoreText = TextComponent(
      text: '0',
      textRenderer: TextPaint(style: TextStyle(fontSize: 72, color: const Color(0xFFFFFFFF), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      anchor: Anchor.topCenter,
      position: Vector2(gameRef.size.x / 2, 60),
    );
    _gemText = TextComponent(
      text: '💎 0',
      textRenderer: TextPaint(style: TextStyle(fontSize: 32, color: const Color(0xFFFFD700), fontFamily: 'monospace')),
      position: Vector2(20, 20),
    );
    gameRef.add(_scoreText);
    gameRef.add(_gemText);
  }

  void updateScore(int score) { currentScore = score; _scoreText.text = '$score'; }
  void updateGems(int gems) { _gemText.text = '💎 $gems'; }

  @override
  void onRemove() { _scoreText.removeFromParent(); _gemText.removeFromParent(); super.onRemove(); }
}

class ScoreTracker extends Component {
  int score = 0;
  int obstaclesPassed = 0;
  int gemsCollected = 0;
  int lastMilestone = 0;
  Function(int score)? onScoreChanged;
  Function(int milestone)? onMilestoneReached;

  void addObstaclePassed() {
    obstaclesPassed++;
    score++;
    onScoreChanged?.call(score);
    final milestone = (score ~/ GameConstants.milestoneInterval) * GameConstants.milestoneInterval;
    if (milestone > lastMilestone && milestone > 0) {
      lastMilestone = milestone;
      onMilestoneReached?.call(milestone);
    }
  }

  void addGemCollected() { gemsCollected++; }
  int calculateGemReward() => obstaclesPassed * GameConstants.coinPerObstaclePassed;
  void reset() { score = 0; obstaclesPassed = 0; gemsCollected = 0; lastMilestone = 0; }
}
