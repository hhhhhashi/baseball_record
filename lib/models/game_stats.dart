// lib/models/game_stats.dart
import 'game.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GameStats {
  final int totalGames;
  final int totalAtBats;
  final int totalHits;
  final int totalRBIs;
  final int totalHomeRuns;
  final int totalSteals;
  final int totalWalks;
  final int totalSacrifices;
  final int totalStrikeouts;
  final int totalOuts;
  final int totalOthers;

  double get battingAverage => totalAtBats == 0 ? 0 : totalHits / totalAtBats;
  double get onBasePercentage => totalAtBats == 0 ? 0 : (totalHits + totalWalks) / totalAtBats;
  double get sluggingPercentage => totalAtBats == 0 ? 0 : (totalHits + 2 * totalHomeRuns) / totalAtBats;
  double get ops => onBasePercentage + sluggingPercentage;
  double get woba => totalAtBats == 0 ? 0 : (0.7 * totalWalks + 0.9 * totalHits + 1.2 * totalHomeRuns) / totalAtBats;

  GameStats({
    required this.totalGames,
    required this.totalAtBats,
    required this.totalHits,
    required this.totalRBIs,
    required this.totalHomeRuns,
    required this.totalSteals,
    required this.totalWalks,
    required this.totalSacrifices,
    required this.totalStrikeouts,
    required this.totalOuts,
    required this.totalOthers,
  });

  static GameStats fromGames(List<Game> games) {
    int hits = 0, atBats = 0, walks = 0, homers = 0, sacrifices = 0;
    int outs = 0, strikeouts = 0, rbis = 0, steals = 0, others = 0;

    for (var game in games) {
      atBats += game.numAtBats;
      rbis += game.runsBattedIn;
      steals += game.stealSuccesses;

      for (var ab in game.atBats) {
        final res = ab.result ?? '';
        if (res.contains('安') || res.contains('二塁打') || res.contains('三塁打') || res.contains('本塁打')) {
          hits++;
          if (res.contains('本塁打')) homers++;
        } else if (res.contains('四球') || res.contains('死球')) {
          walks++;
        } else if (res.contains('三振')) {
          strikeouts++;
        } else if (res.contains('犠')) {
          sacrifices++;
        } else if (res.contains('併殺') || res.contains('飛') || res.contains('ゴロ') || res.contains('直')) {
          outs++;
        } else if (res.contains('振り逃げ') || res.contains('打撃妨害') || res.contains('失策') || res.contains('野選')) {
          others++;
        }
      }
    }

    return GameStats(
      totalGames: games.length,
      totalAtBats: atBats,
      totalHits: hits,
      totalRBIs: rbis,
      totalHomeRuns: homers,
      totalSteals: steals,
      totalWalks: walks,
      totalSacrifices: sacrifices,
      totalStrikeouts: strikeouts,
      totalOuts: outs,
      totalOthers: others,
    );
  }

  PieChartData buildAtBatTypeChart() {
    return PieChartData(sections: [
      _section('安打', totalHits, Colors.green),
      _section('四死球', totalWalks, Colors.blue),
      _section('犠打', totalSacrifices, Colors.orange),
      _section('三振', totalStrikeouts, Colors.red),
      _section('凡打', totalOuts, Colors.grey),
      _section('その他', totalOthers, Colors.purple),
    ]);
  }

  PieChartData buildGroundOutTypeChart() {
    final total = totalOuts == 0 ? 1 : totalOuts;
    return PieChartData(sections: [
      _section('ゴロ', (total * 0.5).toInt(), Colors.brown),
      _section('フライ', (total * 0.3).toInt(), Colors.amber),
      _section('ライナー', (total * 0.2).toInt(), Colors.cyan),
    ]);
  }

  PieChartSectionData _section(String title, int value, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      title: '$title\n$value',
      color: color,
      radius: 50,
      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    );
  }
}