import 'package:baseball_record/models/game.dart';
import 'package:flutter/material.dart';
import 'game_detail_page.dart';

class GameRegistrationPage extends StatefulWidget {
  const GameRegistrationPage({super.key});

  @override
  State<GameRegistrationPage> createState() => _GameRegistrationPageState();
}

class _GameRegistrationPageState extends State<GameRegistrationPage> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedWeather;
  final TextEditingController _numAtBatsController = TextEditingController();

  final List<String> _weatherOptions = ['晴れ', '曇り', '雨', '雪'];

  void _registerGame() {
    final date = _dateController.text;
    final weather = _selectedWeather;
    final numAtBats = int.tryParse(_numAtBatsController.text);

    if (date.isEmpty || weather == null || numAtBats == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('全て入力してください')),
      );
      return;
    }

    // 空の打席を作成
    List<AtBat> atBats = List.generate(
      numAtBats,
      (index) => AtBat(result: null, dateTime: null),
    );

    Game game = Game(
      date: date,
      weather: weather,
      numAtBats: numAtBats,
      atBats: atBats,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailPage(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('試合登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: '試合日 (例: 2025/06/25)'),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedWeather,
              hint: const Text('天気を選択'),
              items: _weatherOptions.map((weather) {
                return DropdownMenuItem(
                  value: weather,
                  child: Text(weather),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWeather = value;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _numAtBatsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '打席数'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerGame,
              child: const Text('試合を登録'),
            ),
          ],
        ),
      ),
    );
  }
}