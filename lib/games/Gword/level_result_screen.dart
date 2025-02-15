import 'package:flutter/material.dart';
import 'level_manager.dart';

class LevelResultScreen extends StatelessWidget {
  const LevelResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    int level = args?['level'] ?? 1;
    int stars = args?['stars'] ?? 0;
    int score = args?['score'] ?? 0;
    Duration time = args?['time'] ?? Duration.zero;
    if (level < LevelManager.totalLevels && stars >= 2) {
      LevelManager.unlockedLevel = level + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Level $level Sonucu"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Level $level Tamamlandı!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Icon(
                        index < stars ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text("Puan: $score", style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(
                    "Süre: ${time.inSeconds} saniye",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (level < LevelManager.totalLevels) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/game',
                          arguments: level + 1,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                    // ignore: sort_child_properties_last
                    child: Text(
                      level < LevelManager.totalLevels
                          ? "Sonraki Level"
                          : "Seviye Seçimine Dön",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
