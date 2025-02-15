import 'package:flutter/material.dart';
import 'package:xyz/games/G2048/G2048View.dart';
import 'package:xyz/games/Gword/level_selection_screen.dart'; // Gword level seçim ekranı

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oyunlar',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oyunlar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2048 butonu
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const G2048View()),
                );
              },
              child: const Text('G2048'),
            ),
            const SizedBox(height: 20),
            // Gword butonu (seviye seçim ekranına yönlendirir)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LevelSelectionScreen(),
                  ),
                );
              },
              child: const Text('Gword'),
            ),
          ],
        ),
      ),
    );
  }
}
