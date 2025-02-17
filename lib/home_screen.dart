import 'package:flutter/material.dart';
import 'package:xyz/games/GPuzzle/ImagePuzzleGameScreen.dart';
import 'games/G2048/G2048View.dart';
import 'games/Gword/level_selection_screen.dart';
import 'games/GSudoku/sudoku_selection_screen.dart';
// GXoxView import
import 'games/GXox/gxox_view.dart';
// GFlow import
import 'games/GFlow/gflow_selection_screen.dart'; // Örnek: Seviye seçimi ekranı

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildAppCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: Colors.orange[800]),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulamalar'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildAppCard(
              context,
              title: 'G2048',
              icon: Icons.grid_on,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const G2048View()),
                );
              },
            ),
            _buildAppCard(
              context,
              title: 'Gword',
              icon: Icons.text_fields,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LevelSelectionScreen(),
                  ),
                );
              },
            ),
            _buildAppCard(
              context,
              title: 'GSudoku',
              icon: Icons.numbers,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SudokuSelectionScreen(),
                  ),
                );
              },
            ),
            _buildAppCard(
              context,
              title: 'GXox',
              icon: Icons.cancel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GXoxView()),
                );
              },
            ),
            _buildAppCard(
              context,
              title: 'puzzle',
              icon: Icons.image,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImagePuzzleGameScreen(),
                  ),
                );
              },
            ),
            // GFlow
            _buildAppCard(
              context,
              title: 'GFlow',
              icon: Icons.alt_route,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GFlowLevelSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
