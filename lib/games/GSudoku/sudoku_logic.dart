import 'dart:math';

class SudokuLogic {
  // 9x9 Sudoku tahtası, 0 değerler boş hücreleri temsil eder.
  late List<List<int>> puzzle;

  // Tamamlanmış sudoku çözümü (solved board)
  final List<List<int>> _completedBoard = [
    [5, 3, 4, 6, 7, 8, 9, 1, 2],
    [6, 7, 2, 1, 9, 5, 3, 4, 8],
    [1, 9, 8, 3, 4, 2, 5, 6, 7],
    [8, 5, 9, 7, 6, 1, 4, 2, 3],
    [4, 2, 6, 8, 5, 3, 7, 9, 1],
    [7, 1, 3, 9, 2, 4, 8, 5, 6],
    [9, 6, 1, 5, 3, 7, 2, 8, 4],
    [2, 8, 7, 4, 1, 9, 6, 3, 5],
    [3, 4, 5, 2, 8, 6, 1, 7, 9],
  ];

  SudokuLogic(int level) {
    int hintsCount = max(17, (50 - ((level - 1) * 33 / 59)).round());
    puzzle = _generatePuzzleWithHints(hintsCount);
  }

  List<List<int>> _generatePuzzleWithHints(int hintsCount) {
    List<List<int>> newPuzzle = _cloneBoard(_completedBoard);
    int cellsToRemove = 81 - hintsCount;
    final rand = Random();
    List<int> indices = List.generate(81, (i) => i);
    indices.shuffle(rand);
    for (int i = 0; i < cellsToRemove; i++) {
      int index = indices[i];
      int row = index ~/ 9;
      int col = index % 9;
      newPuzzle[row][col] = 0;
    }
    return newPuzzle;
  }

  void setValue(int row, int col, int value) {
    puzzle[row][col] = value;
  }

  bool isCompleted() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (puzzle[row][col] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  /// Belirtilen hücrenin doğru (çözüm) değerini döndürür.
  int getSolutionValue(int row, int col) {
    return _completedBoard[row][col];
  }

  List<List<int>> _cloneBoard(List<List<int>> source) {
    return source.map((row) => List<int>.from(row)).toList();
  }
}
