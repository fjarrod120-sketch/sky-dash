class GameConstants {
  GameConstants._();
  static const double gameWidth = 1080.0;
  static const double gameHeight = 1920.0;
  static const String gameTitle = 'Sky Dash';
  static const double playerSize = 80.0;
  static const double playerGravity = 1200.0;
  static const double playerJumpVelocity = -550.0;
  static const int playerMaxLives = 3;
  static const double obstacleWidth = 100.0;
  static const double obstacleMinGap = 280.0;
  static const double obstacleMaxGap = 420.0;
  static const double initialSpeed = 350.0;
  static const double speedIncrement = 15.0;
  static const double maxSpeed = 900.0;
  static const double spawnIntervalInitial = 1.8;
  static const double spawnIntervalMin = 0.7;
  static const double spawnIntervalDecrement = 0.02;
  static const int coinPerObstaclePassed = 1;
  static const int gemsPerMilestone = 5;
  static const int dailyLoginBonus = 25;
  static const int rewardedAdGems = 50;
  static const int maxDailyRewardedAds = 5;
  static const int reviveCostGems = 50;
  static const int milestoneInterval = 100;
  static const double highScoreGemMultiplier = 0.1;
}
