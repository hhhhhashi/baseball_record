// lib/services/game_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game.dart';

class GameService {
  static final _firestore = FirebaseFirestore.instance;
  static final _gamesCollection = _firestore.collection('games');

  static Future<void> saveGame(Game game) async {
    final gameData = {
      'date': game.date,
      'weather': game.weather,
      'numAtBats': game.numAtBats,
      'runsBattedIn': game.runsBattedIn,
      'stealSuccesses': game.stealSuccesses,
      'stealAttempts': game.stealAttempts,
      'atBats': game.atBats.map((atBat) => {
        'result': atBat.result ?? '',
        'dateTime': atBat.dateTime ?? '',
      }).toList(),
    };

    await FirebaseFirestore.instance.collection('games').add(gameData);
  }

  /// 試合一覧を取得
  static Future<List<Game>> fetchGames() async {
    final snapshot = await _gamesCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Game(
        date: data['date'] ?? '',
        weather: data['weather'] ?? '',
        numAtBats: data['numAtBats'] ?? 0,
        runsBattedIn: data['runsBattedIn'] ?? 0,
        stealSuccesses: data['stealSuccesses'] ?? 0,
        stealAttempts: data['stealAttempts'] ?? 0,
        atBats: (data['atBats'] as List<dynamic>).map((item) {
          return AtBat(
            result: item['result'],
            dateTime: item['dateTime'],
          );
        }).toList(),
      );
    }).toList();
  }
}