import 'package:baseball_record/%20screens/at_bat_input_page.dart';
import 'package:baseball_record/models/game.dart';
import 'package:flutter/material.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('試合詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('試合日: ${game.date}'),
            Text('天気: ${game.weather}'),
            Text('打席数: ${game.numAtBats}'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: game.numAtBats,
                itemBuilder: (context, index) {
                  final atBat = game.atBats[index];
                  return ListTile(
                    title: Text('打席${index + 1}'),
                    subtitle: Text(atBat.result ?? '未入力'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AtBatInputPage(atBatIndex: index),
                          ),
                        );

                        if (result != null) {
                          atBat.result = result;
                          atBat.dateTime =
                              DateTime.now().toString().substring(0, 16);
                          (context as Element).reassemble();
                        }
                      },
                      child: const Text('入力する'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}