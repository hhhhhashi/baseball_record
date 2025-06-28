import 'package:flutter/material.dart';
import '../models/game.dart';
import 'game_detail_page.dart';

class GameListPage extends StatefulWidget {
  final List<Game> games;

  const GameListPage({super.key, required this.games});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  late List<Game> games;

  @override
  void initState() {
    super.initState();
    games = widget.games;
  }

  String formatSteal(Game game) {
    if (game.stealAttempts == 0) {
      return '0/0';
    } else {
      return '${game.stealSuccesses}/${game.stealAttempts}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('試合一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newGame = Game(
                date: '',
                weather: '',
                numAtBats: 0,
                runsBattedIn: 0,
                stealSuccesses: 0,
                stealAttempts: 0,
                atBats: [],
              );

              final resultGame = await Navigator.push<Game>(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(game: newGame),
                ),
              );

              if (resultGame != null) {
                setState(() {
                  games.add(resultGame);
                });
              }
            },
          )
        ],
      ),
      body: games.isEmpty
          ? const Center(child: Text('試合が登録されていません'))
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('${game.date} (${game.weather})'),
                    subtitle: Text(
                        '打席数: ${game.numAtBats}, 打点: ${game.runsBattedIn}, 盗塁: ${formatSteal(game)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameDetailPage(game: game),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}