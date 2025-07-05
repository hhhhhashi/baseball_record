// lib/models/game_stats.dart
import 'game.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GameStats {
  final int totalGames;
  final int totalAtBats;
  final int totalSingles;
  final int totalDoubles;
  final int totalTriples;
  final int totalHomeRuns;
  final int totalRBIs;
  final int totalSteals;
  final int totalWalks;
  final int totalHitByPitch;
  final int totalStrikeouts;
  final int totalSacBunts;
  final int totalSacFlies;
  final int totalGroundOuts;
  final int totalFlyOuts;
  final int totalLineOuts;
  final int totalDoublePlays;
  final int totalDroppedThirdStrikes;
  final int totalInterference;
  final int totalErrors;
  final int totalFielderChoices;

  int get totalHits => totalSingles + totalDoubles + totalTriples;
  int get totalOuts => totalGroundOuts + totalFlyOuts + totalLineOuts + totalDoublePlays;

  double get battingAverage => totalAtBats == 0 ? 0 : totalHits / totalAtBats;
  double get onBasePercentage => totalAtBats == 0 ? 0 : (totalHits + totalWalks + totalHitByPitch + totalDroppedThirdStrikes + totalInterference) / totalAtBats;
  double get sluggingPercentage => totalAtBats == 0 ? 0 : (totalSingles + 2 * totalDoubles + 3 * totalTriples + 4 * totalHomeRuns) / totalAtBats;
  double get ops => onBasePercentage + sluggingPercentage;
  double get woba => totalAtBats == 0 ? 0 : (0.7 * (totalWalks + totalHitByPitch + totalDroppedThirdStrikes + totalInterference) + 0.9 * totalSingles + 1.2 * totalDoubles + 1.5 * totalTriples + 1.8 * totalHomeRuns) / totalAtBats;

  GameStats({
    required this.totalGames,
    required this.totalAtBats,
    required this.totalSingles,
    required this.totalDoubles,
    required this.totalTriples,
    required this.totalHomeRuns,
    required this.totalRBIs,
    required this.totalSteals,
    required this.totalWalks,
    required this.totalHitByPitch,
    required this.totalStrikeouts,
    required this.totalSacBunts,
    required this.totalSacFlies,
    required this.totalGroundOuts,
    required this.totalFlyOuts,
    required this.totalLineOuts,
    required this.totalDoublePlays,
    required this.totalDroppedThirdStrikes,
    required this.totalInterference,
    required this.totalErrors,
    required this.totalFielderChoices,
  });

  

  static GameStats fromGames(List<Game> games) {
    int atBats = 0, rbis = 0, steals = 0;
    int singles = 0, doubles = 0, triples = 0, homers = 0;
    int walks = 0, hbp = 0, strikeouts = 0;
    int sacBunts = 0, sacFlies = 0;
    int groundOuts = 0, flyOuts = 0, lineOuts = 0, doublePlays = 0;
    int droppedThirdStrikes = 0, interference = 0, errors = 0, fielderChoices = 0;

    for (var game in games) {
      atBats += game.numAtBats;
      rbis += game.runsBattedIn;
      steals += game.stealSuccesses;

      for (var ab in game.atBats) {
        final res = ab.result ?? '';

        if (res.contains('本塁打')) {
          homers++;
        } else if (res.contains('三塁打')) {
          triples++;
        } else if (res.contains('二塁打')) {
          doubles++;
        } else if (res.contains('安')) {
          singles++;
        } else if (res.contains('四球')) {
          walks++;
        } else if (res.contains('死球')) {
          hbp++;
        } else if (res.contains('三振')) {
          strikeouts++;
        } else if (res.contains('犠打')) {
          sacBunts++;
        } else if (res.contains('犠飛')) {
          sacFlies++;
        } else if (res.contains('ゴロ')) {
          groundOuts++;
        } else if (res.contains('飛')) {
          flyOuts++;
        } else if (res.contains('直')) {
          lineOuts++;
        } else if (res.contains('併殺')) {
          doublePlays++;
        } else if (res.contains('振り逃げ')) {
          droppedThirdStrikes++;
        } else if (res.contains('打撃妨害')) {
          interference++;
        } else if (res.contains('失策')) {
          errors++;
        } else if (res.contains('野選')) {
          fielderChoices++;
        }
      }
    }

    return GameStats(
      totalGames: games.length,
      totalAtBats: atBats,
      totalSingles: singles,
      totalDoubles: doubles,
      totalTriples: triples,
      totalHomeRuns: homers,
      totalRBIs: rbis,
      totalSteals: steals,
      totalWalks: walks,
      totalHitByPitch: hbp,
      totalStrikeouts: strikeouts,
      totalSacBunts: sacBunts,
      totalSacFlies: sacFlies,
      totalGroundOuts: groundOuts,
      totalFlyOuts: flyOuts,
      totalLineOuts: lineOuts,
      totalDoublePlays: doublePlays,
      totalDroppedThirdStrikes: droppedThirdStrikes,
      totalInterference: interference,
      totalErrors: errors,
      totalFielderChoices: fielderChoices,
    );
  }

  PieChartData buildAtBatTypeChart() {
  return PieChartData(sections: [
    _section('安打', totalSingles, Colors.teal.shade300),
    _section('二塁打', totalDoubles, Colors.teal.shade300),
    _section('三塁打', totalTriples, Colors.teal.shade300),
    _section('本塁打', totalHomeRuns, Colors.purpleAccent),
    _section('四球', totalWalks, Colors.blue.shade300),
    _section('死球', totalHitByPitch, Colors.blue.shade300),
    _section('犠打', totalSacBunts, Colors.amber.shade300),
    _section('犠飛', totalSacFlies, Colors.amber.shade300),
    _section('三振', totalStrikeouts, Colors.red.shade700),
    _section('ゴロ', totalGroundOuts, Colors.grey.shade500),
    _section('フライ', totalFlyOuts, Colors.grey.shade500),
    _section('ライナー', totalLineOuts, Colors.grey.shade500),
    _section('併殺', totalDoublePlays, Colors.brown),
  ]);
}

Map<String, Color> get atBatLegend => {
  '安打': Colors.teal.shade300,
  '本塁打': Colors.purpleAccent,
  '四球・死球': Colors.blue.shade300,
  '犠打': Colors.amber.shade300,
  '三振': Colors.red.shade700,
  '凡打': Colors.grey.shade500,
  '併殺': Colors.brown,
};

  PieChartSectionData _section(String title, int value, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      title: '$title\n$value',
      color: color,
      radius: 50,
      titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
}