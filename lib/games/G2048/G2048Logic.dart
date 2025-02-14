import 'dart:math';

enum MoveDirection { up, down, left, right }

class G2048Logic {
  late List<List<int>> board;
  late int score;

  // Geri alma için önceki hamleleri tutan yığın (stack)
  final List<_GameState> _undoStack = [];

  G2048Logic() {
    // Hem dış hem de iç listeyi oluştururken index parametresini alıyoruz.
    board = List.generate(4, (i) => List.generate(4, (j) => 0));
    score = 0;
  }

  /// Yeni oyunu başlatır: tahta sıfırlanır, skor sıfırlanır, 2 rastgele tile eklenir.
  void newGame() {
    board = List.generate(4, (i) => List.generate(4, (j) => 0));
    score = 0;
    _undoStack.clear();
    _addRandomTile();
    _addRandomTile();
  }

  /// Belirtilen yönde hamle yapar; hamle varsa yeni tile ekler.
  void move(MoveDirection direction) {
    _saveState();
    bool moved = false;

    switch (direction) {
      case MoveDirection.left:
        for (int i = 0; i < 4; i++) {
          var original = List<int>.from(board[i]);
          var newRow = _mergeRow(board[i]);
          board[i] = newRow;
          if (!_listEquals(original, newRow)) moved = true;
        }
        break;
      case MoveDirection.right:
        for (int i = 0; i < 4; i++) {
          var original = List<int>.from(board[i]);
          var reversed = List<int>.from(board[i].reversed);
          var newRow = _mergeRow(reversed);
          board[i] = List<int>.from(newRow.reversed);
          if (!_listEquals(original, board[i])) moved = true;
        }
        break;
      case MoveDirection.up:
        for (int col = 0; col < 4; col++) {
          List<int> column = [];
          for (int row = 0; row < 4; row++) {
            column.add(board[row][col]);
          }
          var original = List<int>.from(column);
          var merged = _mergeRow(column);
          for (int row = 0; row < 4; row++) {
            board[row][col] = merged[row];
          }
          if (!_listEquals(original, merged)) moved = true;
        }
        break;
      case MoveDirection.down:
        for (int col = 0; col < 4; col++) {
          List<int> column = [];
          for (int row = 0; row < 4; row++) {
            column.add(board[row][col]);
          }
          var original = List<int>.from(column);
          column = List<int>.from(column.reversed);
          var merged = _mergeRow(column);
          merged = List<int>.from(merged.reversed);
          for (int row = 0; row < 4; row++) {
            board[row][col] = merged[row];
          }
          if (!_listEquals(original, merged)) moved = true;
        }
        break;
    }

    if (moved) {
      _addRandomTile();
    } else {
      // Eğer hamle gerçekleşmediyse, kaydedilen son durumu geri alıyoruz.
      _undoStack.removeLast();
    }
  }

  /// Geri alma işlemi.
  void undo() {
    if (_undoStack.isNotEmpty) {
      var previous = _undoStack.removeLast();
      board = _cloneBoard(previous.board);
      score = previous.score;
    }
  }

  /// Bir satırı sola kaydırıp birleştirir.
  List<int> _mergeRow(List<int> row) {
    List<int> newRow = row.where((val) => val != 0).toList();
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        score += newRow[i];
        newRow[i + 1] = 0;
        i++;
      }
    }
    newRow = newRow.where((val) => val != 0).toList();
    while (newRow.length < 4) {
      newRow.add(0);
    }
    return newRow;
  }

  /// Rastgele boş bir hücreye (2 veya 4) ekler.
  void _addRandomTile() {
    List<Point<int>> emptyPositions = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyPositions.add(Point(i, j));
        }
      }
    }
    if (emptyPositions.isNotEmpty) {
      final random = Random();
      var pos = emptyPositions[random.nextInt(emptyPositions.length)];
      board[pos.x][pos.y] = random.nextDouble() < 0.9 ? 2 : 4;
    }
  }

  /// Mevcut durumu saklar (undo için).
  void _saveState() {
    _undoStack.add(_GameState(board: _cloneBoard(board), score: score));
    if (_undoStack.length > 5) {
      _undoStack.removeAt(0);
    }
  }

  List<List<int>> _cloneBoard(List<List<int>> source) {
    return source.map((row) => List<int>.from(row)).toList();
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _GameState {
  final List<List<int>> board;
  final int score;

  _GameState({required this.board, required this.score});
}
