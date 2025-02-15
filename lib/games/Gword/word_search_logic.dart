import 'dart:math';
import 'package:flutter/material.dart';
import 'level_words.dart';

class WordSearchLogic {
  List<String> words;
  List<String> foundWords = [];
  List<List<String>> grid = List.generate(
    10,
    (_) => List.filled(10, "", growable: false),
  );
  Map<String, List<Offset>> wordCoordinates = {};
  WordSearchLogic(int level) : words = _getWordsForLevel(level);
  static List<String> _getWordsForLevel(int level) {
    return levelWords[level] ?? ["VARSAYILAN", "KELİME", "OYUN", "FİKİR"];
  }

  void generateGrid() {
    Random random = Random();
    for (var word in words) {
      bool placed = false;
      while (!placed) {
        int row = random.nextInt(10);
        int col = random.nextInt(10);
        int direction = random.nextInt(4);
        if (canPlaceWord(word, row, col, direction)) {
          placeWord(word, row, col, direction);
          placed = true;
        }
      }
    }
    const letters = "ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ";
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == "") {
          grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  bool canPlaceWord(String word, int row, int col, int direction) {
    int len = word.length;
    int maxRow = grid.length;
    int maxCol = grid[0].length;
    int dx = 0, dy = 0;
    if (direction == 0) {
      dx = 0;
      dy = 1;
    } else if (direction == 1) {
      dx = 1;
      dy = 0;
    } else if (direction == 2) {
      dx = 1;
      dy = 1;
    } else if (direction == 3) {
      dx = 1;
      dy = -1;
    }
    for (int i = 0; i < len; i++) {
      int newRow = row + i * dx;
      int newCol = col + i * dy;
      if (newRow < 0 || newRow >= maxRow || newCol < 0 || newCol >= maxCol) {
        return false;
      }
      if (grid[newRow][newCol] != "" && grid[newRow][newCol] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void placeWord(String word, int row, int col, int direction) {
    int len = word.length;
    int dx = 0, dy = 0;
    if (direction == 0) {
      dx = 0;
      dy = 1;
    } else if (direction == 1) {
      dx = 1;
      dy = 0;
    } else if (direction == 2) {
      dx = 1;
      dy = 1;
    } else if (direction == 3) {
      dx = 1;
      dy = -1;
    }

    List<Offset> coords = [];
    for (int i = 0; i < len; i++) {
      int newRow = row + i * dx;
      int newCol = col + i * dy;
      grid[newRow][newCol] = word[i];
      coords.add(Offset(newRow.toDouble(), newCol.toDouble()));
    }
    wordCoordinates[word] = coords;
  }
}
