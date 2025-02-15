import 'dart:async';
import 'package:flutter/material.dart';
import 'word_search_logic.dart';
import 'level_manager.dart';
import 'level_selection_screen.dart';

class GameScreen extends StatefulWidget {
  final int level;
  const GameScreen({Key? key, required this.level}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int level;
  late WordSearchLogic gameLogic;
  int score = 0;
  List<Offset> selectedCells = [];
  List<Offset> errorCells = [];
  List<Offset> foundCells = [];
  List<Offset> hintCells = [];
  String? centerMessage;
  final GlobalKey gridKey = GlobalKey();
  Offset? selectionDirection;
  Stopwatch stopwatch = Stopwatch();
  Timer? uiTimer;

  int hintCount = 3;

  @override
  void initState() {
    super.initState();
    level = widget.level;
    gameLogic = WordSearchLogic(level);
    gameLogic.generateGrid();
    stopwatch.reset();
    stopwatch.start();
    uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    uiTimer?.cancel();
    super.dispose();
  }

  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white, size: 30),
              const SizedBox(width: 4),
              Text(
                "${stopwatch.elapsed.inSeconds} s",
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.lightbulb,
                  color: hintCount > 0 ? Colors.amber : Colors.grey,
                  size: 30,
                ),
                onPressed: showHint,
              ),
              Text(
                "$hintCount",
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showHint() {
    if (hintCount == 0) {
      showCenterMessage("Hint yardımı kullandınız!");
      return;
    }
    setState(() {
      hintCount = 0;
    });
    List<String> unsolved =
        gameLogic.words
            .where((word) => !gameLogic.foundWords.contains(word))
            .toList();
    if (unsolved.isEmpty) return;
    String hintWord = unsolved.first;
    List<Offset>? coords = gameLogic.wordCoordinates[hintWord];
    if (coords != null) {
      setState(() {
        hintCells = coords;
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          hintCells = [];
        });
      });
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

  void checkWord() {
    String selectedWord = "";
    for (var offset in selectedCells) {
      int row = offset.dx.toInt();
      int col = offset.dy.toInt();
      selectedWord += gameLogic.grid[row][col];
    }
    bool isReverse = gameLogic.words.any(
      (word) => selectedWord == word.split('').reversed.join(),
    );
    if (isReverse || !gameLogic.words.contains(selectedWord)) {
      setState(() {
        errorCells.addAll(selectedCells);
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          errorCells.clear();
          selectedCells.clear();
          selectionDirection = null;
        });
      });
      return;
    }
    if (gameLogic.foundWords.contains(selectedWord)) {
      setState(() {
        selectedCells.clear();
        selectionDirection = null;
      });
      return;
    } else {
      setState(() {
        score += 10;
        gameLogic.foundWords.add(selectedWord);
        foundCells.addAll(selectedCells);
        selectedCells.clear();
        selectionDirection = null;
      });
    }
    if (gameLogic.foundWords.length == gameLogic.words.length) {
      stopwatch.stop();
      Duration elapsed = stopwatch.elapsed;
      int stars;
      if (elapsed.inSeconds <= 60) {
        stars = 3;
      } else if (elapsed.inSeconds <= 90) {
        stars = 2;
      } else {
        stars = 1;
      }
      LevelManager.results[level] = LevelResult(
        level: level,
        stars: stars,
        score: score,
        time: elapsed,
      );
      if (level < LevelManager.totalLevels && stars >= 2) {
        LevelManager.unlockedLevel = level + 1;
      }
      showResultDialog(stars, elapsed);
    }
  }

  void showResultDialog(int stars, Duration elapsed) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Level $level Tamamlandı!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Puan: $score"),
              Text("Süre: ${elapsed.inSeconds} saniye"),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LevelSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text("Devam"),
            ),
          ],
        );
      },
    );
  }

  void onPanStart(DragStartDetails details) {
    RenderBox box = gridKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);
    double cellSize = box.size.width / 10;
    int row = (localPosition.dy / cellSize).floor();
    int col = (localPosition.dx / cellSize).floor();
    if (row >= 0 &&
        row < 10 &&
        col >= 0 &&
        col < 10 &&
        gameLogic.grid[row][col] != "") {
      setState(() {
        selectedCells = [Offset(row.toDouble(), col.toDouble())];
        selectionDirection = null;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (selectedCells.isEmpty) return;
    RenderBox box = gridKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);
    double cellSize = box.size.width / 10;
    int row = (localPosition.dy / cellSize).floor();
    int col = (localPosition.dx / cellSize).floor();
    if (row < 0 || row >= 10 || col < 0 || col >= 10) return;
    Offset newCell = Offset(row.toDouble(), col.toDouble());
    if (selectedCells.length >= 2 &&
        newCell == selectedCells[selectedCells.length - 2]) {
      setState(() {
        selectedCells.removeLast();
        if (selectedCells.length < 2) selectionDirection = null;
      });
      return;
    }
    if (selectedCells.contains(newCell)) return;
    if (selectedCells.length == 1) {
      if (isValidMove(selectedCells.last, newCell)) {
        setState(() {
          selectedCells.add(newCell);
          double dx = newCell.dx - selectedCells.first.dx;
          double dy = newCell.dy - selectedCells.first.dy;
          selectionDirection = Offset(dx, dy);
        });
      }
      return;
    }
    if (selectionDirection != null) {
      Offset expectedCell = Offset(
        selectedCells.last.dx + selectionDirection!.dx,
        selectedCells.last.dy + selectionDirection!.dy,
      );
      if (newCell == expectedCell) {
        setState(() {
          selectedCells.add(newCell);
        });
      }
    }
  }

  void onPanEnd(DragEndDetails details) {
    checkWord();
  }

  bool isValidMove(Offset from, Offset to) {
    int rowDiff = (to.dx - from.dx).abs().toInt();
    int colDiff = (to.dy - from.dy).abs().toInt();
    return rowDiff <= 1 && colDiff <= 1;
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      appBar: AppBar(
        title: Text("Level $level"),
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
        child: Stack(
          children: [
            Column(
              children: [
                buildTopBar(),
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    child: Text(
                      "Puan: $score",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        gameLogic.words.map((word) {
                          bool found = gameLogic.foundWords.contains(word);
                          return Chip(
                            label: Text(
                              word,
                              style: TextStyle(
                                fontSize: 18,
                                decoration:
                                    found
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                color: found ? Colors.white70 : Colors.white,
                              ),
                            ),
                            backgroundColor:
                                found ? Colors.green : Colors.deepPurpleAccent,
                            elevation: 2,
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Container(
                      key: gridKey,
                      width: gridWidth,
                      height: gridWidth,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onPanStart: onPanStart,
                        onPanUpdate: onPanUpdate,
                        onPanEnd: onPanEnd,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10,
                              ),
                          itemCount: 100,
                          itemBuilder: (context, index) {
                            int row = index ~/ 10;
                            int col = index % 10;
                            Offset cellOffset = Offset(
                              row.toDouble(),
                              col.toDouble(),
                            );
                            Color cellColor;
                            if (foundCells.contains(cellOffset)) {
                              cellColor = Colors.green;
                            } else if (hintCells.contains(cellOffset)) {
                              cellColor = const Color.fromARGB(
                                255,
                                233,
                                105,
                                147,
                              );
                            } else if (errorCells.contains(cellOffset)) {
                              cellColor = Colors.red;
                            } else if (selectedCells.contains(cellOffset)) {
                              cellColor = Colors.yellow;
                            } else {
                              cellColor =
                                  gameLogic.grid[row][col] != ""
                                      ? Colors.blueAccent
                                      : Colors.grey;
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                color: cellColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  gameLogic.grid[row][col],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}
