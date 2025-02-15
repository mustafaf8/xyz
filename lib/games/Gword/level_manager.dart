class LevelResult {
  final int level;
  final int stars;
  final int score;
  final Duration time;

  LevelResult({
    required this.level,
    required this.stars,
    required this.score,
    required this.time,
  });
}

class LevelManager {
  static int currentLevel = 1;
  static int unlockedLevel = 1;
  static const int totalLevels = 60;
  static Map<int, LevelResult> results = {};
}
