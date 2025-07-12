import 'package:flutter/material.dart';
import 'screens/game_list_page.dart';
import 'models/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/stats_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 匿名ログイン
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

Future<void> signInAnonymously() async {
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    await auth.signInAnonymously();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // ← グローバルで初期データを用意
  final List<Game> games = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '草野球打撃記録',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: StatsPage(),
    );
  }
}