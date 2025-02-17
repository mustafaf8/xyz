import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcı ilerlemesini kaydetme/yükleme yöneticisi (Singleton)
class GFlowProgressManager {
  GFlowProgressManager._internal();
  static final GFlowProgressManager instance = GFlowProgressManager._internal();

  int maxUnlockedLevel = 0;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    maxUnlockedLevel = prefs.getInt('gflow_unlocked') ?? 0;
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gflow_unlocked', maxUnlockedLevel);
  }

  Future<void> completeLevel(int levelIndex) async {
    if (levelIndex >= maxUnlockedLevel) {
      maxUnlockedLevel = levelIndex + 1;
      await saveProgress();
    }
  }

  bool isLocked(int levelIndex) {
    return levelIndex > maxUnlockedLevel;
  }
}
