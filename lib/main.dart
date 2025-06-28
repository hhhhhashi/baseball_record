import 'package:flutter/material.dart';
import 'screens/game_list_page.dart';
import 'models/game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // ← グローバルで初期データを用意
  final List<Game> games = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '草野球打撃記録',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: GameListPage(games: games),
    );
  }
}