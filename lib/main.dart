import 'package:flutter/material.dart';
import 'package:xyz/home_screen.dart'; // HomeScreen dosyasının yolu

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
      home: const HomeScreen(), // Ana sayfa olarak HomeScreen
    );
  }
}
