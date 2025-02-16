import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'gxox_controller.dart';

class GXoxView extends StatefulWidget {
  const GXoxView({Key? key}) : super(key: key);

  @override
  _GXoxViewState createState() => _GXoxViewState();
}

class _GXoxViewState extends State<GXoxView> with SingleTickerProviderStateMixin {
  late GXoxController _controller;
  late AnimationController _lineAnimationController;
  late Animation<double> _lineAnimation;

  // Skorlar
  int scoreX = 0;
  int scoreO = 0;

  @override
  void initState() {
    super.initState();
    _controller = GXoxController();

    // Kazanan çizgisi animasyonu
    _lineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _lineAnimation = CurvedAnimation(
      parent: _lineAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _lineAnimationController.dispose();
    super.dispose();
  }

  /// Sadece tahtayı sıfırlayıp yeni tura geçiş
  void _resetBoardForNextRound() {
    setState(() {
      _controller.resetBoard();
      _lineAnimationController.reset();
    });
  }

  /// Hem skorları hem tahtayı sıfırlar
  void _resetGameAndScores() {
    setState(() {
      _controller.resetBoard();
      _lineAnimationController.reset();
      scoreX = 0;
      scoreO = 0;
    });
  }

  /// Hücreye tıklama
  void _makeMove(int index) {
    setState(() {
      _controller.makeMove(index);
    });
    if (_controller.winner.isNotEmpty) {
      _checkRoundCompletion();
    }
  }

  /// Tur sonu kontrolü (kazanan veya berabere)
  void _checkRoundCompletion() {
    // Kazanan varsa skor güncelle
    if (_controller.winner == 'X') {
      setState(() => scoreX++);
    } else if (_controller.winner == 'O') {
      setState(() => scoreO++);
    }
    // Çizgi animasyonu
    if (_controller.winner != 'Draw') {
      _lineAnimationController.forward();
    }
    // Dialog ile devam/bitir sorusu
    Future.delayed(const Duration(milliseconds: 300), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _controller.winner == 'Draw'
                  ? "Berabere!"
                  : "${_controller.winner} kazandı!",
            ),
            content: Text(
              "Skorlar:\nX: $scoreX\nO: $scoreO\n\nDevam etmek ister misiniz?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetBoardForNextRound();
                },
                child: const Text("Evet"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGameAndScores();
                },
                child: const Text("Hayır"),
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final winner = _controller.winner;
    final xTurn = _controller.xTurn;

    return Scaffold(
      // Kendi özel tasarımlı üst bar kullanacağımız için AppBar'ı kaldırıyoruz
      body: Container(
        // Arka plan gradyan
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF23074D), Color(0xFFCC5333)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Özel üst bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopBar(
                  scoreX: scoreX,
                  scoreO: scoreO,
                  onBack: () => Navigator.of(context).pop(),
                  onReset: _resetGameAndScores,
                ),
              ),
              // Oyun tahtası ortada
              Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cellSize = constraints.biggest.width / 3;
                      return Stack(
                        children: [
                          // Neon ızgara
                          _buildNeonGrid(cellSize),
                          // Hücreler (X/O)
                          _buildCells(cellSize),
                          // Kazanan çizgisi
                          IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _lineAnimation,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: Size(constraints.biggest.width, constraints.biggest.height),
                                  painter: _WinningLinePainter(
                                    animationValue: _lineAnimation.value,
                                    winningPositions: _controller.winningPositions,
                                    cellSize: cellSize,
                                    lineColor: Colors.redAccent,
                                    lineWidth: 8,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Alt kısımda sıra bilgisi
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      winner.isNotEmpty
                          ? (winner == 'Draw' ? 'Berabere!' : '${_controller.winner} kazandı!')
                          : 'Sıra: ${xTurn ? 'X' : 'O'}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Neon ızgarayı çiziyoruz
  Widget _buildNeonGrid(double cellSize) {
    return CustomPaint(
      size: Size(cellSize * 3, cellSize * 3),
      painter: _NeonGridPainter(),
    );
  }

  /// 9 hücreyi gösteren GridView
  Widget _buildCells(double cellSize) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final value = _controller.board[index];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _makeMove(index),
          child: SizedBox(
            width: cellSize,
            height: cellSize,
            child: Center(
              child: Text(
                value,
                style: value == 'X'
                    ? _neonTextStyle(Colors.blueAccent)
                    : _neonTextStyle(Colors.pinkAccent),
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _neonTextStyle(Color color) {
    return TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: color,
      shadows: [
        Shadow(
          blurRadius: 10,
          color: color,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }
}

/// Özel üst bar için ayrı bir Widget
class _TopBar extends StatefulWidget {
  final int scoreX;
  final int scoreO;
  final VoidCallback onBack;
  final VoidCallback onReset;

  const _TopBar({
    Key? key,
    required this.scoreX,
    required this.scoreO,
    required this.onBack,
    required this.onReset,
  }) : super(key: key);

  @override
  __TopBarState createState() => __TopBarState();
}

class __TopBarState extends State<_TopBar> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowValue;

  @override
  void initState() {
    super.initState();
    // Skor metni için parlayan (pulse) animasyon
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowValue = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Üst bar yüksekliği
    const double barHeight = 100.0;

    return Container(
      height: barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        // Üst barın arka planı için hafif bir gradient
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E1E2C),
            Color(0xFF2F2F3D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Geri butonu
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: widget.onBack,
          ),
          // Ortada GXox başlığı ve skor
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Oyun adı
                Text(
                  'GXox',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent.shade100,
                    shadows: [
                      const Shadow(
                        blurRadius: 10,
                        color: Colors.orangeAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                // Animasyonlu skor metni
                AnimatedBuilder(
                  animation: _glowValue,
                  builder: (context, child) {
                    // 0.0 -> 1.0 arası bir değer
                    // Renk geçişi veya parlama yoğunluğu ayarlayabiliriz
                    final glowColor = Color.lerp(
                      Colors.orangeAccent,
                      Colors.yellowAccent,
                      _glowValue.value,
                    )!;
                    return Text(
                      'X: ${widget.scoreX}   O: ${widget.scoreO}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 8 + 8 * _glowValue.value,
                            color: glowColor,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Yenile (oyun sıfırlama) butonu
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: widget.onReset,
          ),
        ],
      ),
    );
  }
}

/// 3x3 neon çizgileri çizen CustomPainter
class _NeonGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);

    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;

    // Dikey çizgiler
    for (int i = 1; i < 3; i++) {
      final dx = cellWidth * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }
    // Yatay çizgiler
    for (int i = 1; i < 3; i++) {
      final dy = cellHeight * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(_NeonGridPainter oldDelegate) => false;
}

/// Kazanan çizgisini çizen CustomPainter
class _WinningLinePainter extends CustomPainter {
  final double animationValue;
  final List<int> winningPositions;
  final double cellSize;
  final Color lineColor;
  final double lineWidth;

  _WinningLinePainter({
    required this.animationValue,
    required this.winningPositions,
    required this.cellSize,
    required this.lineColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (winningPositions.isEmpty) return;

    final firstIndex = winningPositions.first;
    final lastIndex = winningPositions.last;

    final firstRow = firstIndex ~/ 3;
    final firstCol = firstIndex % 3;
    final lastRow = lastIndex ~/ 3;
    final lastCol = lastIndex % 3;

    final start = Offset(
      (firstCol + 0.5) * cellSize,
      (firstRow + 0.5) * cellSize,
    );
    final end = Offset(
      (lastCol + 0.5) * cellSize,
      (lastRow + 0.5) * cellSize,
    );

    final currentEnd = Offset(
      start.dx + (end.dx - start.dx) * animationValue,
      start.dy + (end.dy - start.dy) * animationValue,
    );

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    canvas.drawLine(start, currentEnd, paint);
  }

  @override
  bool shouldRepaint(_WinningLinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.winningPositions != winningPositions;
  }
}
