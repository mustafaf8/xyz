import 'package:flutter/material.dart';
import 'gflow_levels.dart';
import 'gflow_puzzle.dart';

class GFlowBoard extends StatefulWidget {
  final GFlowLevel level;
  final FlowPuzzle puzzle;
  final VoidCallback onSolved;

  const GFlowBoard({
    Key? key,
    required this.level,
    required this.puzzle,
    required this.onSolved,
  }) : super(key: key);

  @override
  State<GFlowBoard> createState() => _GFlowBoardState();
}

class _GFlowBoardState extends State<GFlowBoard> with SingleTickerProviderStateMixin {
  List<Cell> currentPath = [];
  int? currentColorId;
  bool collisionNotified = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    // Girişte basit bir ScaleTransition
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isBridgeCell(int row, int col) {
    return widget.level.bridgeCells.any((b) => b.row == row && b.col == col);
  }

  void _handlePanStart(Offset localPos, double cellSize) {
    final cell = _getCellFromOffset(localPos, cellSize);
    if (cell == null) return;

    final colorId = widget.puzzle.getColorIdAt(cell.row, cell.col);
    if (colorId != null) {
      currentColorId = colorId;
      currentPath = [cell];
      collisionNotified = false;
      setState(() {});
    }
  }

  void _handlePanUpdate(Offset localPos, double cellSize) {
    if (currentColorId == null) return;
    final cell = _getCellFromOffset(localPos, cellSize);
    if (cell == null) return;

    // Eğer puzzle.ignoreCollisions = true (Köprü Modu) ise, çakışma kontrolü yapmıyoruz.
    // Aksi hâlde, normal çakışma kontrolü:
    if (!widget.puzzle.ignoreCollisions) {
      for (var otherColorId in widget.puzzle.paths.keys) {
        if (otherColorId == currentColorId) continue;
        final otherPath = widget.puzzle.paths[otherColorId] ?? [];
        if (otherPath.contains(cell) && !_isBridgeCell(cell.row, cell.col)) {
          if (!collisionNotified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Hücre çakışması tespit edildi!")),
            );
            collisionNotified = true;
          }
          return; // Bu hücre eklenmez
        }
      }
    }

    // Komşu hücre mi?
    if (currentPath.isNotEmpty) {
      final last = currentPath.last;
      if ((cell.row - last.row).abs() + (cell.col - last.col).abs() == 1) {
        if (!currentPath.contains(cell)) {
          currentPath.add(cell);
          setState(() {});
        }
      }
    }
  }

  void _handlePanEnd() {
    if (currentColorId != null && currentPath.isNotEmpty) {
      widget.puzzle.addPath(currentColorId!, currentPath);
      currentColorId = null;
      currentPath = [];
      setState(() {});
      if (widget.puzzle.isSolved()) {
        widget.onSolved();
      }
    }
  }

  /// Çift tıklama ile mevcut çizimi temizleme
  void _handleDoubleTap() {
    if (currentColorId != null) {
      widget.puzzle.clearPath(currentColorId!);
      currentPath = [];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Çizim temizlendi.")),
      );
      setState(() {});
    }
  }

  Cell? _getCellFromOffset(Offset pos, double cellSize) {
    int row = (pos.dy ~/ cellSize);
    int col = (pos.dx ~/ cellSize);
    if (row < 0 || row >= widget.level.rows || col < 0 || col >= widget.level.cols) {
      return null;
    }
    return Cell(row: row, col: col);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double boardSize = constraints.biggest.shortestSide;
        double cellSize = boardSize / widget.level.cols;

        return ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            width: boardSize,
            height: boardSize,
            color: Colors.black,
            child: GestureDetector(
              onPanStart: (details) => _handlePanStart(details.localPosition, cellSize),
              onPanUpdate: (details) => _handlePanUpdate(details.localPosition, cellSize),
              onPanEnd: (details) => _handlePanEnd(),
              onDoubleTap: _handleDoubleTap,
              child: CustomPaint(
                painter: _GFlowPainter(
                  puzzle: widget.puzzle,
                  cellSize: cellSize,
                  currentPath: currentPath,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Tahta çizimi
class _GFlowPainter extends CustomPainter {
  final FlowPuzzle puzzle;
  final double cellSize;
  final List<Cell> currentPath;

  _GFlowPainter({
    required this.puzzle,
    required this.cellSize,
    required this.currentPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Izgara
    final gridPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int r = 0; r <= puzzle.level.rows; r++) {
      canvas.drawLine(
        Offset(0, r * cellSize),
        Offset(puzzle.level.cols * cellSize, r * cellSize),
        gridPaint,
      );
    }
    for (int c = 0; c <= puzzle.level.cols; c++) {
      canvas.drawLine(
        Offset(c * cellSize, 0),
        Offset(c * cellSize, puzzle.level.rows * cellSize),
        gridPaint,
      );
    }

    // Çizilmiş yollar
    puzzle.paths.forEach((colorId, path) {
      if (path.isEmpty) return;
      final pathPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = cellSize * 0.4
        ..color = _colorForId(colorId).withOpacity(0.8);

      final drawPath = Path();
      drawPath.moveTo(
        path.first.col * cellSize + cellSize/2,
        path.first.row * cellSize + cellSize/2,
      );
      for (int i = 1; i < path.length; i++) {
        drawPath.lineTo(
          path[i].col * cellSize + cellSize/2,
          path[i].row * cellSize + cellSize/2,
        );
      }
      canvas.drawPath(drawPath, pathPaint);
    });

    // Anlık çizim
    if (currentPath.isNotEmpty) {
      final currentPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = cellSize * 0.5
        ..color = Colors.white;
      final path = Path();
      path.moveTo(
        currentPath.first.col * cellSize + cellSize/2,
        currentPath.first.row * cellSize + cellSize/2,
      );
      for (int i = 1; i < currentPath.length; i++) {
        path.lineTo(
          currentPath[i].col * cellSize + cellSize/2,
          currentPath[i].row * cellSize + cellSize/2,
        );
      }
      canvas.drawPath(path, currentPaint);
    }

    // Renkli noktalar
    for (var point in puzzle.level.points) {
      final dotPaint = Paint()..color = _colorForId(point.colorId);
      canvas.drawCircle(
        Offset(point.col * cellSize + cellSize/2, point.row * cellSize + cellSize/2),
        cellSize * 0.3,
        dotPaint,
      );
    }

    // Statik köprü hücreleri
    for (var b in puzzle.level.bridgeCells) {
      final bridgePaint = Paint()..color = Colors.white.withOpacity(0.25);
      canvas.drawRect(
        Rect.fromLTWH(
          b.col * cellSize + cellSize*0.2,
          b.row * cellSize + cellSize*0.2,
          cellSize*0.6,
          cellSize*0.6,
        ),
        bridgePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Color _colorForId(int colorId) {
    switch (colorId) {
      case 0: return Colors.yellow;
      case 1: return Colors.red;
      case 2: return Colors.blue;
      case 3: return Colors.green;
      case 4: return Colors.orange;
      default: return Colors.purple;
    }
  }
}
