import 'package:flutter/material.dart';
import 'home_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
      home: const HomeScreen(),
      navigatorObservers: [routeObserver], // RouteObserver ekliyoruz.
    );
  }
}
