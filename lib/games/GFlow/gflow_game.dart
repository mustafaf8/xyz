import 'package:flutter/material.dart';
import 'gflow_levels.dart';
import 'gflow_puzzle.dart';
import 'gflow_board.dart';
import 'gflow_progress.dart';

class GFlowGameScreen extends StatefulWidget {
  final int levelIndex;
  const GFlowGameScreen({Key? key, required this.levelIndex}) : super(key: key);

  @override
  State<GFlowGameScreen> createState() => _GFlowGameScreenState();
}

class _GFlowGameScreenState extends State<GFlowGameScreen> {
  late FlowPuzzle puzzle;
  late GFlowLevel level;

  /// Köprü Modu açık/kapalı
  bool isBridgeMode = false;

  @override
  void initState() {
    super.initState();
    level = gflowLevels[widget.levelIndex];
    puzzle = FlowPuzzle(level);
  }

  void _onPuzzleSolved() async {
    await GFlowProgressManager.instance.completeLevel(widget.levelIndex);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tebrikler!"),
        content: const Text("Bu seviyeyi tamamladınız."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // seviye seçim ekranına
            },
            child: const Text("Seviye Seçimi"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              final nextLevel = widget.levelIndex + 1;
              if (nextLevel < gflowLevels.length) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GFlowGameScreen(levelIndex: nextLevel)),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text("Sonraki Seviye"),
          ),
        ],
      ),
    );
  }

  void _giveHint() {
    bool hintUsed = puzzle.giveHint();
    if (!hintUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("İpucu verilemiyor.")),
      );
    } else {
      setState(() {});
    }
  }

  /// Köprü Modu'nu aç/kapat
  void _toggleBridgeMode() {
    setState(() {
      isBridgeMode = !isBridgeMode;
      puzzle.setBridgeMode(isBridgeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GFlow - Seviye ${widget.levelIndex + 1}"),
        actions: [
          // Köprü Modu butonu
          IconButton(
            icon: Icon(isBridgeMode ? Icons.link_off : Icons.link),
            tooltip: "Köprü Modu",
            onPressed: _toggleBridgeMode,
          ),
          // İpucu butonu
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: "İpucu al",
            onPressed: _giveHint,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: GFlowBoard(
            level: level,
            puzzle: puzzle,
            onSolved: _onPuzzleSolved,
          ),
        ),
      ),
    );
  }
}
