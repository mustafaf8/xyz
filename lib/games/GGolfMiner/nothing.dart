import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xyz/games/GSudoku/sudoku_selection_screen.dart';
import 'sudoku_logic.dart';
import 'sudoku_manager.dart';

class SudokuGameScreen extends StatefulWidget {
  final int level;
  const SudokuGameScreen({Key? key, required this.level}) : super(key: key);

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late SudokuLogic sudoku;
  int selectedRow = -1;
  int selectedCol = -1;
  int hintCount = 50;
  String? centerMessage;

  @override
  void initState() {
    super.initState();
    sudoku = SudokuLogic(
      widget.level,
    ); // widget.level parametresini kullanıyoruz.
  }

  /// Üstte gösterilecek top bar: Hint ikonu ve hint sayısı
  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.lightbulb,
              color: hintCount > 0 ? Colors.amber : Colors.grey,
              size: 32,
            ),
            onPressed: showHint,
          ),
          Text(
            "$hintCount",
            style: const TextStyle(fontSize: 20, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  /// Hint fonksiyonu: Eğer hint hakkı varsa, ilk boş hücreyi bulup, sudoku çözümündeki doğru değeri
  /// o hücreye yazar.
  void showHint() {
    if (hintCount <= 0) {
      showCenterMessage(" yardım kalmadi!");
      return;
    }
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (sudoku.puzzle[row][col] == 0) {
          int correctValue = sudoku.getSolutionValue(row, col);
          setState(() {
            sudoku.setValue(row, col, correctValue);
          });
          hintCount--;
          showCenterMessage("[$row, $col] hücresi dolduruldu!");
          return;
        }
      }
    }
  }

  void showCenterMessage(String message) {
    setState(() {
      centerMessage = message;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        centerMessage = null;
      });
    });
  }

  /// Hücreye tıklandığında seçili hücreyi ayarlar.
  void _onCellTap(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  /// Kullanıcının seçtiği sayıyı yerleştirir.
  void _onNumberSelected(int number) {
    if (selectedRow != -1 && selectedCol != -1) {
      setState(() {
        sudoku.setValue(selectedRow, selectedCol, number);
      });
      if (sudoku.isCompleted()) {
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    int stars = 3;
    int nextLevel = widget.level + 1;
    if (widget.level < SudokuManager.totalLevels) {
      SudokuManager.unlockedLevel = nextLevel;
      SudokuManager.saveProgress(nextLevel, stars);
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text("Tebrikler!"),
            content: Text(
              "Level ${widget.level} tamamlandı!\n3 Yıldız kazandınız!",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SudokuSelectionScreen(),
                    ),
                  );
                },
                child: const Text("Devam"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sudoku Level ${widget.level}"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          buildTopBar(), // Üstte hint ikonlu top bar
          const SizedBox(height: 10),
          _buildBoard(boardSize),
          const SizedBox(height: 10),
          _buildNumberPad(),
          if (centerMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  centerMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Sudoku tahtası (9x9)
  Widget _buildBoard(double boardSize) {
    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;
          int value = sudoku.puzzle[row][col];
          bool isSelected = (row == selectedRow && col == selectedCol);

          return GestureDetector(
            onTap: () => _onCellTap(row, col),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.lightBlueAccent : Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              alignment: Alignment.center,
              child: Text(
                value == 0 ? "" : "$value",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: List.generate(9, (index) {
          int number = index + 1;
          return ElevatedButton(
            onPressed: () => _onNumberSelected(number),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[500],
              foregroundColor: Colors.white,
              minimumSize: const Size(60, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Text(
              "$number",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }
}
