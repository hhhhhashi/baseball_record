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
    _loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('個人成績')),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final games = snapshot.data!;
          final stats = GameStats.fromGames(games);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔼 最上部に配置
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameListPage(games: []),
                        ),
                      );
                      if (result == true) {
                        setState(() {
                          _gamesFuture = GameService.fetchGames();
                        });
                      }
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('試合一覧を見る'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text('通算成績',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildStatsGrid(stats),

                const SizedBox(height: 32),
                _buildChartSection(
                  title: '打席内訳',
                  chart: PieChart(stats.buildAtBatTypeChart()),
                ),
                const SizedBox(height: 24),
                _buildChartSection(
                  title: '凡打の内訳',
                  chart: PieChart(stats.buildGroundOutTypeChart()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(GameStats stats) {
    final statItems = [
      _statCard('試合数', stats.totalGames.toString()),
      _statCard('打数', stats.totalAtBats.toString()),
      _statCard('打率', stats.battingAverage.toStringAsFixed(3)),
      _statCard('出塁率', stats.onBasePercentage.toStringAsFixed(3)),
      _statCard('OPS', stats.ops.toStringAsFixed(3)),
      _statCard('wOBA', stats.woba.toStringAsFixed(3)),
      _statCard('打点', stats.totalRBIs.toString()),
      _statCard('本塁打', stats.totalHomeRuns.toString()),
      _statCard('安打', stats.totalHits.toString()),
      _statCard('盗塁', stats.totalSteals.toString()),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: statItems,
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 52) / 2, // 2列の幅
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChartSection({required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 200, child: chart),
      ],
    );
  }
}