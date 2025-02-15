import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'stars': stars,
      'score': score,
      'time': time.inSeconds, // Saniye cinsinden kaydet
    };
  }

  factory LevelResult.fromJson(Map<String, dynamic> json) {
    return LevelResult(
      level: json['level'],
      stars: json['stars'],
      score: json['score'],
      time: Duration(seconds: json['time']),
    );
  }
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

  // ⭐ YENİ EKLENEN FONKSİYON: Seviye sonuçlarını kaydet
  static Future<void> saveLevelResult(
    int level,
    int stars,
    int score,
    Duration time,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Yeni sonucu kaydet
    results[level] = LevelResult(
      level: level,
      stars: stars,
      score: score,
      time: time,
    );

    // Sonuçları JSON formatına çevir ve kaydet
    Map<String, dynamic> jsonResults = {
      for (var entry in results.entries)
        entry.key.toString(): entry.value.toJson(),
    };

    await prefs.setString('level_results', jsonEncode(jsonResults));
  }

  // ⭐ YENİ EKLENEN FONKSİYON: Seviye sonuçlarını yükle
  static Future<void> loadLevelResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('level_results');

    if (jsonString != null) {
      Map<String, dynamic> jsonResults = jsonDecode(jsonString);
      results = jsonResults.map(
        (key, value) => MapEntry(int.parse(key), LevelResult.fromJson(value)),
      );
    }
  }
}
