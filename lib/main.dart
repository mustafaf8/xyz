import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int gridSize = 4;
  late List<List<int>> grid;
  Random random = Random();

  // Swipe başlangıç ve bitiş koordinatları
  Offset startSwipe = Offset.zero;
  Offset endSwipe = Offset.zero;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  // Oyunu başlatan metod: ızgarayı sıfırlar ve iki başlangıç sayısı ekler.
  void initGame() {
    grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => 0),
    );
    addNewTile();
    addNewTile();
  }

  // Boş bir hücreye yeni sayı (genellikle 2, ara sıra 4) ekler.
  void addNewTile() {
    List<Point<int>> emptyPositions = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          emptyPositions.add(Point(i, j));
        }
      }
    }
    if (emptyPositions.isNotEmpty) {
      Point<int> pos = emptyPositions[random.nextInt(emptyPositions.length)];
      grid[pos.x][pos.y] = random.nextDouble() < 0.9 ? 2 : 4;
    }
  }

  // Sola kaydırma
  bool moveLeft() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> originalRow = List.from(grid[i]);
      List<int> newRow = mergeRow(grid[i]);
      grid[i] = newRow;
      if (!listEquals(originalRow, newRow)) {
        moved = true;
      }
    }
    return moved;
  }

  // Sağa kaydırma
  bool moveRight() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> originalRow = List.from(grid[i]);
      List<int> reversed = grid[i].reversed.toList();
      List<int> newRowReversed = mergeRow(reversed);
      List<int> newRow = newRowReversed.reversed.toList();
      grid[i] = newRow;
      if (!listEquals(originalRow, newRow)) {
        moved = true;
      }
    }
    return moved;
  }

  // Yukarı kaydırma
  bool moveUp() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        column.add(grid[i][j]);
      }
      List<int> originalColumn = List.from(column);
      List<int> newColumn = mergeRow(column);
      for (int i = 0; i < gridSize; i++) {
        grid[i][j] = newColumn[i];
      }
      if (!listEquals(originalColumn, newColumn)) {
        moved = true;
      }
    }
    return moved;
  }

  // Aşağı kaydırma
  bool moveDown() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        column.add(grid[i][j]);
      }
      List<int> originalColumn = List.from(column);
      List<int> reversed = column.reversed.toList();
      List<int> newColumnReversed = mergeRow(reversed);
      List<int> newColumn = newColumnReversed.reversed.toList();
      for (int i = 0; i < gridSize; i++) {
        grid[i][j] = newColumn[i];
      }
      if (!listEquals(originalColumn, newColumn)) {
        moved = true;
      }
    }
    return moved;
  }

  // Bir satır ya da sütun için birleştirme (merge) işlemi: 0 olmayan değerleri sola doğru kaydırır, aynı olanları birleştirir.
  List<int> mergeRow(List<int> row) {
    List<int> newRow = row.where((val) => val != 0).toList();
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        newRow[i + 1] = 0;
      }
    }
    newRow = newRow.where((val) => val != 0).toList();
    while (newRow.length < gridSize) {
      newRow.add(0);
    }
    return newRow;
  }

  // Listelerin eşitliğini kontrol eden yardımcı metot.
  bool listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // Hamle sonrası hareketin işlenmesi: swipe yönüne göre ilgili kaydırma metodu çağrılır.
  void handleSwipe() {
    bool moved = false;
    final dx = endSwipe.dx - startSwipe.dx;
    final dy = endSwipe.dy - startSwipe.dy;
    if (dx.abs() > dy.abs()) {
      // Yatay hareket
      if (dx > 0) {
        moved = moveRight();
      } else {
        moved = moveLeft();
      }
    } else {
      // Dikey hareket
      if (dy > 0) {
        moved = moveDown();
      } else {
        moved = moveUp();
      }
    }
    if (moved) {
      setState(() {
        addNewTile();
      });
      if (isGameOver()) {
        Future.delayed(Duration(milliseconds: 300), () {
          showGameOverDialog();
        });
      }
    }
  }

  // Oyun bitti mi kontrolü: boş hücre veya birleşebilecek komşu varsa oyun devam eder.
  bool isGameOver() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) return false;
        if (i < gridSize - 1 && grid[i][j] == grid[i + 1][j]) return false;
        if (j < gridSize - 1 && grid[i][j] == grid[i][j + 1]) return false;
      }
    }
    return true;
  }

  // Oyun bittiğinde gösterilecek uyarı diyaloğu.
  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Oyun Bitti'),
        content: Text('Daha fazla hamle kalmadı!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                initGame();
              });
            },
            child: Text('Tekrar Oyna'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2048'),
        centerTitle: true,
      ),
      body: GestureDetector(
        // Swipe başlangıcı
        onPanStart: (details) {
          startSwipe = details.localPosition;
        },
        // Swipe güncellemesi
        onPanUpdate: (details) {
          endSwipe = details.localPosition;
        },
        // Swipe bittiğinde hareketi işle
        onPanEnd: (details) {
          handleSwipe();
        },
        child: Container(
          color: Colors.grey[300],
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: grid
                .map(
                  (row) => Expanded(
                    child: Row(
                      children: row
                          .map(
                            (tile) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: getTileColor(tile),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tile != 0 ? '$tile' : '',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: tile <= 4
                                            ? Colors.black87
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            initGame();
          });
        },
      ),
    );
  }

  // Her kareye göre arka plan rengi belirleyen metot.
  Color getTileColor(int value) {
    switch (value) {
      case 0:
        return Colors.grey[400]!;
      case 2:
        return Colors.grey[200]!;
      case 4:
        return Colors.orange[100]!;
      case 8:
        return Colors.orange[200]!;
      case 16:
        return Colors.orange[300]!;
      case 32:
        return Colors.orange[400]!;
      case 64:
        return Colors.orange[500]!;
      case 128:
        return Colors.red[300]!;
      case 256:
        return Colors.red[400]!;
      case 512:
        return Colors.red[500]!;
      case 1024:
        return Colors.red[600]!;
      case 2048:
        return Colors.green[500]!;
      default:
        return Colors.black;
    }
  }
}
