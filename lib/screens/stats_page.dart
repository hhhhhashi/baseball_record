import 'package:baseball_record/models/game_stats.dart';
import 'package:baseball_record/screens/game_list_page.dart';
import 'package:flutter/material.dart';
import 'package:baseball_record/services/game_service.dart';
import 'package:baseball_record/models/game.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<List<Game>> _gamesFuture;

  void _loadGames() {
    _gamesFuture = GameService.fetchGames();
  }

  @override
  void initState() {
    super.initState();
    _gamesFuture = GameService.fetchGames(); // ローカル or Firestoreから取得
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('個人成績')),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final games = snapshot.data!;
          final stats = GameStats.fromGames(games);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ① 数値表示
                _buildStatRow('通算試合数', stats.totalGames.toString()),
                _buildStatRow('打率', stats.battingAverage.toStringAsFixed(3)),
                _buildStatRow('出塁率', stats.onBasePercentage.toStringAsFixed(3)),
                _buildStatRow('OPS', stats.ops.toStringAsFixed(3)),
                _buildStatRow('wOBA', stats.woba.toStringAsFixed(3)),
                _buildStatRow('打点', stats.totalRBIs.toString()),
                _buildStatRow('本塁打', stats.totalHomeRuns.toString()),
                _buildStatRow('安打', stats.totalHits.toString()),
                _buildStatRow('打数', stats.totalAtBats.toString()),
                _buildStatRow('盗塁', stats.totalSteals.toString()),

                const SizedBox(height: 24),

                const Text('打席内訳', style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 200, // ← 高さを明示する
                  child: PieChart(stats.buildAtBatTypeChart()),
                ),
                const SizedBox(height: 24),

                const Text('凡打の内訳', style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 200,
                  child: PieChart(stats.buildGroundOutTypeChart()),
                ),

                /// 🔽 試合一覧へボタン追加（ここ）
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameListPage(games: [])),
                    );
                  },
                  child: const Text('試合一覧を見る'),
                ),


              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}