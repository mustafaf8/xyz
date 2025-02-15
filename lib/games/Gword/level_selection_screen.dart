import 'package:flutter/material.dart';
import 'package:xyz/home_screen.dart';
import 'level_manager.dart';
import 'game_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // En son oynanan level bilgisini yükle ve unlockedLevel'ı güncelle
    LevelManager.loadLastLevel().then((lastLevel) {
      setState(() {
        LevelManager.unlockedLevel = lastLevel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> levelCards = [];
    for (int i = 1; i <= LevelManager.totalLevels; i++) {
      final result = LevelManager.results[i];
      bool isUnlocked = i <= LevelManager.unlockedLevel;
      levelCards.add(
        GestureDetector(
          onTap:
              isUnlocked
                  ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(level: i),
                      ),
                    );
                  }
                  : null,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(8),
            child: Container(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Level $i",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (result != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Icon(
                                index < result.stars
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.lock, color: Colors.white, size: 40),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text("Level Seçimi"),
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
        child: GridView.count(
          crossAxisCount: 2,
          children: levelCards,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
