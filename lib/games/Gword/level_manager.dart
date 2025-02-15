import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<int> loadLastLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('gword_last_level') ?? 1;
  }

  static Future<void> saveLastLevel(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gword_last_level', level);
  }
}
