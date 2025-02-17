import 'gflow_levels.dart';

/// FlowPuzzle: Kullanıcının çizdiği yollar, çakışma kontrolü, çözüm kontrolü, ipucu
/// Bu sürümde "ignoreCollisions" (Köprü Modu) eklendi.
class FlowPuzzle {
  final GFlowLevel level;
  // colorId -> kullanıcının çizdiği yol (Cell listesi)
  Map<int, List<Cell>> paths = {};

  /// Köprü Modu açık olduğunda çakışma kontrolü devre dışı kalır.
  bool ignoreCollisions = false;

  FlowPuzzle(this.level) {
    for (var point in level.points) {
      paths[point.colorId] = [];
    }
  }

  /// Köprü Modu’nu açıp kapatma
  void setBridgeMode(bool value) {
    ignoreCollisions = value;
  }

  int? getColorIdAt(int row, int col) {
    for (var p in level.points) {
      if (p.row == row && p.col == col) return p.colorId;
    }
    return null;
  }

  /// Yeni çizilen yolu ekler. Eğer ignoreCollisions=false ise çakışma kontrolü yapılır.
  void addPath(int colorId, List<Cell> newPath) {
    paths[colorId] = newPath;
    if (!ignoreCollisions) {
      _handleCollisions(colorId);
    }
  }

  /// Kullanıcının çizdiği yolu siler
  void clearPath(int colorId) {
    paths[colorId] = [];
  }

  void _handleCollisions(int colorId) {
    final myPath = paths[colorId] ?? [];
    for (var otherColorId in paths.keys) {
      if (otherColorId == colorId) continue;
      final otherPath = paths[otherColorId] ?? [];
      final commonCells = myPath.toSet().intersection(otherPath.toSet());
      // Köprü hücreler hariç çakışma varsa bu çizimi iptal et.
      final collisions = commonCells.where((cell) => !_isBridgeCell(cell)).toList();
      if (collisions.isNotEmpty) {
        paths[colorId] = [];
        break;
      }
    }
  }

  bool _isBridgeCell(Cell c) {
    // Seviye tanımındaki statik köprü hücreleri
    return level.bridgeCells.any((b) => b.row == c.row && b.col == c.col);
  }

  /// Tüm renklerin, FlowPoint'ler arasında doğru bağlanıp bağlanmadığını kontrol eder.
  bool isSolved() {
    Map<int, List<FlowPoint>> colorToPoints = {};
    for (var p in level.points) {
      colorToPoints.putIfAbsent(p.colorId, () => []);
      colorToPoints[p.colorId]!.add(p);
    }
    for (var entry in colorToPoints.entries) {
      final cId = entry.key;
      final pts = entry.value;
      if (pts.length < 2) continue;
      final path = paths[cId] ?? [];
      if (path.isEmpty) return false;

      bool startMatch = (path.first == Cell(row: pts[0].row, col: pts[0].col)) ||
          (path.first == Cell(row: pts[1].row, col: pts[1].col));
      bool endMatch = (path.last == Cell(row: pts[0].row, col: pts[0].col)) ||
          (path.last == Cell(row: pts[1].row, col: pts[1].col));
      if (!startMatch || !endMatch) {
        return false;
      }
    }
    return true;
  }

  /// İpucu (Hint) fonksiyonu: Bir sonraki doğru hücreyi ekler.
  bool giveHint() {
    for (var cId in paths.keys) {
      final userPath = paths[cId]!;
      final solutionPath = level.solutions[cId] ?? [];
      if (solutionPath.isEmpty) continue;
      if (userPath.length < solutionPath.length || userPath != solutionPath) {
        int matchingCount = 0;
        for (int i = 0; i < userPath.length; i++) {
          if (i < solutionPath.length && userPath[i] == solutionPath[i]) {
            matchingCount++;
          } else {
            break;
          }
        }
        if (matchingCount < solutionPath.length) {
          final newPath = solutionPath.sublist(0, matchingCount + 1);
          addPath(cId, newPath);
          return true;
        }
      }
    }
    return false;
  }
}
