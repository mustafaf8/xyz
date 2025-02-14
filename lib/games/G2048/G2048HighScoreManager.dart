
import 'package:shared_preferences/shared_preferences.dart';

class G2048HighScoreManager {
  int highScore = 0;
  static const String _key = 'g2048_high_score';

  /// Yerel depolamadan (SharedPreferences) en yüksek skoru yükler.
  Future<void> loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(_key) ?? 0;
  }

  /// Güncel skor, kayıtlı en yüksek skordan büyükse günceller.
  Future<void> checkHighScore(int currentScore) async {
    if (currentScore > highScore) {
      highScore = currentScore;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, highScore);
    }
  }
}