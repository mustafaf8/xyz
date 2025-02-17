// lib/games/GFlow/gflow_levels.dart

/// Veri modelleri: GFlowLevel, FlowPoint, BridgeCell, Cell
class GFlowLevel {
  final int rows;
  final int cols;
  final List<FlowPoint> points;
  final List<BridgeCell> bridgeCells;
  // İpucu için çözüm yolları: colorId -> List<Cell>
  final Map<int, List<Cell>> solutions;

  GFlowLevel({
    required this.rows,
    required this.cols,
    required this.points,
    this.bridgeCells = const [],
    required this.solutions,
  });
}

class FlowPoint {
  final int colorId;
  final int row;
  final int col;
  FlowPoint({required this.colorId, required this.row, required this.col});
}

class BridgeCell {
  final int row;
  final int col;
  BridgeCell({required this.row, required this.col});
}

class Cell {
  final int row;
  final int col;
  const Cell({required this.row, required this.col});
  @override
  bool operator ==(Object other) =>
      other is Cell && row == other.row && col == other.col;
  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

/// Manuel olarak tasarlanmış 10 seviye
final List<GFlowLevel> gflowLevels = [
  // Level 1: 5x5, 2 pair – yatay çizgiler
  GFlowLevel(
    rows: 5,
    cols: 5,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 0, col: 4),
      FlowPoint(colorId: 1, row: 4, col: 0),
      FlowPoint(colorId: 1, row: 4, col: 4),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:0, col:1), Cell(row:0, col:2), Cell(row:0, col:3), Cell(row:0, col:4)],
      1: [Cell(row:4, col:0), Cell(row:4, col:1), Cell(row:4, col:2), Cell(row:4, col:3), Cell(row:4, col:4)],
    },
  ),
  // Level 2: 5x5, 2 pair – dikey çizgiler
  GFlowLevel(
    rows: 5,
    cols: 5,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 4, col: 0),
      FlowPoint(colorId: 1, row: 0, col: 4),
      FlowPoint(colorId: 1, row: 4, col: 4),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:1, col:0), Cell(row:2, col:0), Cell(row:3, col:0), Cell(row:4, col:0)],
      1: [Cell(row:0, col:4), Cell(row:1, col:4), Cell(row:2, col:4), Cell(row:3, col:4), Cell(row:4, col:4)],
    },
  ),
  // Level 3: 5x5, 2 pair – basit L şekli
  GFlowLevel(
    rows: 5,
    cols: 5,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 4, col: 2),
      FlowPoint(colorId: 1, row: 0, col: 4),
      FlowPoint(colorId: 1, row: 4, col: 4),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:1, col:0), Cell(row:2, col:0), Cell(row:3, col:0), Cell(row:4, col:0), Cell(row:4, col:1), Cell(row:4, col:2)],
      1: [Cell(row:0, col:4), Cell(row:1, col:4), Cell(row:2, col:4), Cell(row:3, col:4), Cell(row:4, col:4)],
    },
  ),
  // Level 4: 6x6, 3 pair
  GFlowLevel(
    rows: 6,
    cols: 6,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 0, col: 5),
      FlowPoint(colorId: 1, row: 5, col: 0),
      FlowPoint(colorId: 1, row: 5, col: 5),
      FlowPoint(colorId: 2, row: 2, col: 2),
      FlowPoint(colorId: 2, row: 3, col: 2),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:0, col:1), Cell(row:0, col:2), Cell(row:0, col:3), Cell(row:0, col:4), Cell(row:0, col:5)],
      1: [Cell(row:5, col:0), Cell(row:5, col:1), Cell(row:5, col:2), Cell(row:5, col:3), Cell(row:5, col:4), Cell(row:5, col:5)],
      2: [Cell(row:2, col:2), Cell(row:2, col:3), Cell(row:3, col:3), Cell(row:3, col:2)],
    },
  ),
  // Level 5: 6x6, 3 pair – yatay orta çizgiler
  GFlowLevel(
    rows: 6,
    cols: 6,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 1),
      FlowPoint(colorId: 0, row: 0, col: 4),
      FlowPoint(colorId: 1, row: 5, col: 1),
      FlowPoint(colorId: 1, row: 5, col: 4),
      FlowPoint(colorId: 2, row: 2, col: 0),
      FlowPoint(colorId: 2, row: 2, col: 5),
    ],
    solutions: {
      0: [Cell(row:0, col:1), Cell(row:0, col:2), Cell(row:0, col:3), Cell(row:0, col:4)],
      1: [Cell(row:5, col:1), Cell(row:5, col:2), Cell(row:5, col:3), Cell(row:5, col:4)],
      2: [Cell(row:2, col:0), Cell(row:2, col:1), Cell(row:2, col:2), Cell(row:2, col:3), Cell(row:2, col:4), Cell(row:2, col:5)],
    },
  ),
  // Level 6: 6x6, 3 pair – dikey çizgiler
  GFlowLevel(
    rows: 6,
    cols: 6,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 5, col: 0),
      FlowPoint(colorId: 1, row: 0, col: 5),
      FlowPoint(colorId: 1, row: 5, col: 5),
      FlowPoint(colorId: 2, row: 2, col: 2),
      FlowPoint(colorId: 2, row: 3, col: 3),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:1, col:0), Cell(row:2, col:0), Cell(row:3, col:0), Cell(row:4, col:0), Cell(row:5, col:0)],
      1: [Cell(row:0, col:5), Cell(row:1, col:5), Cell(row:2, col:5), Cell(row:3, col:5), Cell(row:4, col:5), Cell(row:5, col:5)],
      2: [Cell(row:2, col:2), Cell(row:2, col:3), Cell(row:3, col:3)],
    },
  ),
  // Level 7: 7x7, 4 pair
  GFlowLevel(
    rows: 7,
    cols: 7,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 0, col: 6),
      FlowPoint(colorId: 1, row: 6, col: 0),
      FlowPoint(colorId: 1, row: 6, col: 6),
      FlowPoint(colorId: 2, row: 3, col: 0),
      FlowPoint(colorId: 2, row: 3, col: 6),
      FlowPoint(colorId: 3, row: 1, col: 3),
      FlowPoint(colorId: 3, row: 5, col: 3),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:0, col:1), Cell(row:0, col:2), Cell(row:0, col:3), Cell(row:0, col:4), Cell(row:0, col:5), Cell(row:0, col:6)],
      1: [Cell(row:6, col:0), Cell(row:6, col:1), Cell(row:6, col:2), Cell(row:6, col:3), Cell(row:6, col:4), Cell(row:6, col:5), Cell(row:6, col:6)],
      2: [Cell(row:3, col:0), Cell(row:3, col:1), Cell(row:3, col:2), Cell(row:3, col:3), Cell(row:3, col:4), Cell(row:3, col:5), Cell(row:3, col:6)],
      3: [Cell(row:1, col:3), Cell(row:2, col:3), Cell(row:3, col:3), Cell(row:4, col:3), Cell(row:5, col:3)],
    },
  ),
  // Level 8: 7x7, 4 pair
  GFlowLevel(
    rows: 7,
    cols: 7,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 2),
      FlowPoint(colorId: 0, row: 6, col: 2),
      FlowPoint(colorId: 1, row: 0, col: 4),
      FlowPoint(colorId: 1, row: 6, col: 4),
      FlowPoint(colorId: 2, row: 2, col: 0),
      FlowPoint(colorId: 2, row: 2, col: 6),
      FlowPoint(colorId: 3, row: 4, col: 0),
      FlowPoint(colorId: 3, row: 4, col: 6),
    ],
    solutions: {
      0: [Cell(row:0, col:2), Cell(row:1, col:2), Cell(row:2, col:2), Cell(row:3, col:2), Cell(row:4, col:2), Cell(row:5, col:2), Cell(row:6, col:2)],
      1: [Cell(row:0, col:4), Cell(row:1, col:4), Cell(row:2, col:4), Cell(row:3, col:4), Cell(row:4, col:4), Cell(row:5, col:4), Cell(row:6, col:4)],
      2: [Cell(row:2, col:0), Cell(row:2, col:1), Cell(row:2, col:2), Cell(row:2, col:3), Cell(row:2, col:4), Cell(row:2, col:5), Cell(row:2, col:6)],
      3: [Cell(row:4, col:0), Cell(row:4, col:1), Cell(row:4, col:2), Cell(row:4, col:3), Cell(row:4, col:4), Cell(row:4, col:5), Cell(row:4, col:6)],
    },
  ),
  // Level 9: 7x7, 2 pair + bridge
  GFlowLevel(
    rows: 7,
    cols: 7,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 6, col: 6),
      FlowPoint(colorId: 1, row: 0, col: 6),
      FlowPoint(colorId: 1, row: 6, col: 0),
    ],
    bridgeCells: [BridgeCell(row:3, col:3)],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:1, col:0), Cell(row:2, col:0), Cell(row:3, col:0), Cell(row:3, col:1), Cell(row:3, col:2), Cell(row:3, col:3), Cell(row:4, col:3), Cell(row:5, col:3), Cell(row:6, col:3), Cell(row:6, col:4), Cell(row:6, col:5), Cell(row:6, col:6)],
      1: [Cell(row:0, col:6), Cell(row:1, col:6), Cell(row:2, col:6), Cell(row:3, col:6), Cell(row:3, col:5), Cell(row:3, col:4), Cell(row:3, col:3), Cell(row:4, col:3), Cell(row:5, col:3), Cell(row:6, col:3), Cell(row:6, col:2), Cell(row:6, col:1), Cell(row:6, col:0)],
    },
  ),
  // Level 10: 8x8, 4 pair
  GFlowLevel(
    rows: 8,
    cols: 8,
    points: [
      FlowPoint(colorId: 0, row: 0, col: 0),
      FlowPoint(colorId: 0, row: 0, col: 7),
      FlowPoint(colorId: 1, row: 7, col: 0),
      FlowPoint(colorId: 1, row: 7, col: 7),
      FlowPoint(colorId: 2, row: 3, col: 3),
      FlowPoint(colorId: 2, row: 4, col: 4),
      FlowPoint(colorId: 3, row: 0, col: 4),
      FlowPoint(colorId: 3, row: 7, col: 4),
    ],
    solutions: {
      0: [Cell(row:0, col:0), Cell(row:0, col:1), Cell(row:0, col:2), Cell(row:0, col:3), Cell(row:0, col:4), Cell(row:0, col:5), Cell(row:0, col:6), Cell(row:0, col:7)],
      1: [Cell(row:7, col:0), Cell(row:7, col:1), Cell(row:7, col:2), Cell(row:7, col:3), Cell(row:7, col:4), Cell(row:7, col:5), Cell(row:7, col:6), Cell(row:7, col:7)],
      2: [Cell(row:3, col:3), Cell(row:3, col:4), Cell(row:4, col:4)],
      3: [Cell(row:0, col:4), Cell(row:1, col:4), Cell(row:2, col:4), Cell(row:3, col:4), Cell(row:4, col:4), Cell(row:5, col:4), Cell(row:6, col:4), Cell(row:7, col:4)],
    },
  ),
];
