import 'package:flutter/material.dart';
import 'package:xyz/main.dart';
import 'sudoku_manager.dart';
import 'sudoku_game_screen.dart';

class SudokuSelectionScreen extends StatefulWidget {
  const SudokuSelectionScreen({Key? key}) : super(key: key);

  @override
  State<SudokuSelectionScreen> createState() => _SudokuSelectionScreenState();
}

class _SudokuSelectionScreenState extends State<SudokuSelectionScreen>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    await SudokuManager.loadProgress();
    setState(() {});
  }

  @override
  void didPopNext() {
    // Bu metot, bu ekrana geri dönüldüğünde çağrılır.
    _loadProgress();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // build metodu: Level kartlarını oluştururken SudokuManager.unlockedLevel ve diğer bilgiler kullanılıyor.
  @override
  Widget build(BuildContext context) {
    List<Widget> levelCards = [];
    for (int i = 1; i <= SudokuManager.totalLevels; i++) {
      bool isUnlocked = i <= SudokuManager.unlockedLevel;
      int stars = (i < SudokuManager.unlockedLevel) ? 3 : 0;
      levelCards.add(
        GestureDetector(
          onTap:
              isUnlocked
                  ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SudokuGameScreen(level: i),
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
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.teal[100] : Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "Level $i",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (stars > 0)
                    Positioned(
                      bottom: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          return Icon(
                            index < stars ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
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
        title: const Text("Sudoku"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4DD0E1), Color(0xFF006064)],
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
