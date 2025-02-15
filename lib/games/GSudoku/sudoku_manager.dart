import 'package:shared_preferences/shared_preferences.dart';

class SudokuManager {
  static const int totalLevels = 60;
  static int unlockedLevel = 1;

  static Future<void> saveProgress(int nextLevel, int stars) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sudoku_unlocked_level', nextLevel);
    await prefs.setInt('sudoku_last_stars', stars);
    unlockedLevel = nextLevel;
  }

  static Future<void> loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    unlockedLevel = prefs.getInt('sudoku_unlocked_level') ?? 1;
  }
}
