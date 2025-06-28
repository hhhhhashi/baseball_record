import 'package:flutter/material.dart';

import ' screens/game_registration_page.dart';

void main() {
  runApp(const BattingApp());
}

class BattingApp extends StatelessWidget {
  const BattingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '草野球打撃記録',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const GameRegistrationPage(),
    );
  }
}