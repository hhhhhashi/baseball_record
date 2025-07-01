import 'package:baseball_record/services/game_service.dart';
import 'package:flutter/material.dart';
import '../models/game.dart';
import 'game_detail_page.dart';
import 'package:intl/intl.dart';

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
    _loadGames();
  }

  void _loadGames() async {
    final loadedGames = await GameService.fetchGames();
    setState(() {
      games = loadedGames;
    });
  }

  String formatSteal(Game game) {
    if (game.stealAttempts == 0) {
      return '0/0';
    } else {
      return '${game.stealSuccesses}/${game.stealAttempts}';
    }
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy/MM/dd').format(date); // 例: 2025/06/29
    } catch (e) {
      return dateString; // パース失敗時はそのまま
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

              await Navigator.push<Game>(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(game: newGame),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: GameService.streamGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('試合が登録されていません'));
          }

          final games = snapshot.data!;

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('${formatDate(game.date)} (${game.weather})'),
                  subtitle: Text(
                      '打席数: ${game.numAtBats}, 打点: ${game.runsBattedIn}, 盗塁: ${formatSteal(game)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailPage(game: game),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}