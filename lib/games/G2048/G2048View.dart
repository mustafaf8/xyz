import 'package:flutter/material.dart';
import 'G2048Logic.dart';
import 'G2048HighScoreManager.dart';

class G2048View extends StatefulWidget {
  const G2048View({super.key});

  @override
  State<G2048View> createState() => _G2048ViewState();
}

class _G2048ViewState extends State<G2048View> {
  late G2048Logic _game;
  late G2048HighScoreManager _highScoreManager;

  @override
  void initState() {
    super.initState();
    _game = G2048Logic();
    _game.newGame();

    _highScoreManager = G2048HighScoreManager();
    _highScoreManager.loadHighScore().then((_) {
      setState(() {});
    });
  }

  /// Swipe hareketinin bitiminde yönü belirler.
  void _handleSwipe(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final dx = velocity.dx;
    final dy = velocity.dy;
    if (dx.abs() > dy.abs()) {
      // Yatay swipe
      if (dx > 0) {
        _handleMove(MoveDirection.right);
      } else {
        _handleMove(MoveDirection.left);
      }
    } else {
      // Dikey swipe
      if (dy > 0) {
        _handleMove(MoveDirection.down);
      } else {
        _handleMove(MoveDirection.up);
      }
    }
  }

  /// Belirtilen yönde hamle yapar ve high score'u günceller.
  void _handleMove(MoveDirection direction) {
    setState(() {
      _game.move(direction);
      _highScoreManager.checkHighScore(_game.score);
    });
  }

  /// Geri alma (undo) işlemini gerçekleştirir.
  void _undoMove() {
    setState(() {
      _game.undo();
    });
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      appBar: AppBar(
        title: const Text('G2048'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _game.newGame();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildScoreBoard(),
          const SizedBox(height: 10),
          // Oyun tahtasını, swipe hareketlerini algılayacak GestureDetector ile sarmalıyoruz.
          GestureDetector(
            onPanEnd: _handleSwipe,
            child: _buildBoard(boardSize),
          ),
          const SizedBox(height: 10),
          // İsteğe bağlı olarak undo butonunu bırakabilirsiniz.
          ElevatedButton(
            onPressed: _undoMove,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                255,
                58,
                150,
                255,
              ), // Arka plan rengi
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Geri'),
          ),
        ],
      ),
    );
  }

  /// Skor panosunu (Score ve High Score) gösterir.
  Widget _buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCard('Score', _game.score),
        _buildScoreCard('High Score', _highScoreManager.highScore),
      ],
    );
  }

  Widget _buildScoreCard(String title, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 4x4 oyun tahtasını oluşturan widget.
  Widget _buildBoard(double boardSize) {
    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          int row = index ~/ 4;
          int col = index % 4;
          int value = _game.board[row][col];
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getTileColor(value),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value != 0 ? '$value' : '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: value <= 4 ? Colors.black87 : Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Tile değerine göre arka plan rengini belirler.
  Color _getTileColor(int value) {
    switch (value) {
      case 0:
        return Colors.orange[50]!;
      case 2:
        return Colors.orange[200]!;
      case 4:
        return Colors.orange[300]!;
      case 8:
        return Colors.orange[400]!;
      case 16:
        return Colors.orange[500]!;
      case 32:
        return Colors.orange[600]!;
      case 64:
        return Colors.orange[700]!;
      case 128:
        return Colors.orange[800]!;
      case 256:
        return Colors.orange[900]!;
      case 512:
        return Colors.deepOrange;
      case 1024:
        return Colors.red;
      case 2048:
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
