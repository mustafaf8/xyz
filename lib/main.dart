import 'package:flutter/material.dart';
import 'games/G2048/G2048View.dart'; // 2048 arayüz dosyamız

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @overrideuk
  Widget build(BuildContext context) {
    return MaterialApp(
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
            // İleride diğer oyunlar (Gword vs.) için butonlar ekleyebilirsiniz.
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const GwordView()),
            //     );
            //   },
            //   child: const Text('Gword'),
            // ),
          ],
        ),
      ),
    );
  }
}
