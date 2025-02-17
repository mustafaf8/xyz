import 'gflow_levels.dart';

/// Basit bir hücre tanımı
class Cell {
  final int row;
  final int col;

  const Cell({required this.row, required this.col});

  @override
  bool operator ==(Object other) {
    return other is Cell && row == other.row && col == other.col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

/// FlowPuzzle sınıfı:
/// - Mevcut seviye bilgisini tutar
/// - Çizilmiş yolları saklar
/// - Yol eklenirken köprü hücrelerinde çakışmaya izin verir
/// - Çözümün tamamlanıp tamamlanmadığını kontrol eder
class FlowPuzzle {
  final GFlowLevel level;

  /// colorId -> path (Cell listesi)
  Map<int, List<Cell>> paths = {};

  FlowPuzzle({required this.level}) {
    // Başlangıç olarak her renge boş path veriyoruz (veya sadece nokta konumlarını verebilirsiniz)
    for (var point in level.points) {
      paths[point.colorId] = [];
    }
  }

  /// Belirli (row, col) konumunda bir renk noktası varsa, colorId döndür.
  int? getColorIdAt(int row, int col) {
    for (var point in level.points) {
      if (point.row == row && point.col == col) {
        return point.colorId;
      }
    }
    return null;
  }

  /// Kullanıcının çizdiği path'i ilgili renge ekler.
  /// Köprü olmayan hücrelerde çakışma varsa eski path'leri siler/temizler veya engeller.
  void addPath(int colorId, List<Cell> newPath) {
    // Önce mevcut path'i al
    List<Cell> existingPath = paths[colorId] ?? [];

    // Mevcut path'i yenisiyle birleştirebiliriz ya da sıfırdan atayabiliriz.
    // Burada basitçe sıfırdan atayalım:
    paths[colorId] = newPath;

    // Diğer renklere ait path'lerle çakışmaları kontrol et
    _handleCollisions(colorId);
  }

  /// Köprü olmayan hücrelerde çakışma varsa, çakışan path'leri siler
  void _handleCollisions(int colorId) {
    final myPath = paths[colorId] ?? [];
    for (var otherColorId in paths.keys) {
      if (otherColorId == colorId) continue;
      final otherPath = paths[otherColorId] ?? [];
      // Ortak hücreler bul
      final commonCells = myPath.toSet().intersection(otherPath.toSet());
      // Ortak hücreler içerisinde köprü hücresi olmayanları ayıkla
      final collisions = commonCells.where((cell) {
        // Eğer cell bir köprü hücresi ise çakışmaya izin ver
        return !_isBridgeCell(cell);
      }).toList();

      // Köprü olmayan çakışma hücreleri varsa, diğer path'i sıfırla (veya isterseniz kısmi silme yapabilirsiniz)
      if (collisions.isNotEmpty) {
        paths[otherColorId] = [];
      }
    }
  }

  /// Bir hücre köprü hücresi mi?
  bool _isBridgeCell(Cell cell) {
    return level.bridgeCells.any((b) => b.row == cell.row && b.col == cell.col);
  }

  /// Bütün renklerin iki noktası da birbirine bağlanmış mı kontrol et
  /// - Her renge ait iki nokta var
  /// - Path o iki noktayı içeriyor mu
  /// - Path'te boşluk/eksik yok mu vb.
  bool isSolved() {
    // Her colorId için, level.points içinde o colorId'ye ait 2 nokta var
    // ve path bu iki noktayı uçlarda içeriyor mu diye bakarız
    // Ayrıca path uzunluğu 2'den azsa zaten bağlanmamıştır

    // Her colorId'ye ait tam 2 nokta olduğunu varsayıyoruz (Flow tarzı)
    Map<int, List<FlowPoint>> colorToPoints = {};
    for (var p in level.points) {
      colorToPoints.putIfAbsent(p.colorId, () => []);
      colorToPoints[p.colorId]!.add(p);
    }

    for (var entry in colorToPoints.entries) {
      final cId = entry.key;
      final pts = entry.value;
      if (pts.length != 2) continue; // Her ihtimale karşı

      final path = paths[cId] ?? [];
      if (path.length < 2) {
        return false;
      }

      final start = path.first;
      final end = path.last;
      // Bu yolun uçları o renkli noktalar mı
      bool startMatch = (start.row == pts[0].row && start.col == pts[0].col) ||
          (start.row == pts[1].row && start.col == pts[1].col);
      bool endMatch = (end.row == pts[0].row && end.col == pts[0].col) ||
          (end.row == pts[1].row && end.col == pts[1].col);

      if (!(startMatch && endMatch)) {
        return false;
      }
    }

    // Hepsi tamamsa
    return true;
  }
}
