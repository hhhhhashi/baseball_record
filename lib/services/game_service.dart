// lib/services/game_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game.dart';

class GameService {

  static Future<void> saveGame(Game game) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid == null) return;

    final gameData = {
      'uid': uid,
      'date': Timestamp.fromDate(game.date),
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

    if (game.id == null) {
      // 新規追加
      final docRef = await FirebaseFirestore.instance.collection('games').add(gameData);
      game.id = docRef.id; // IDをセット
    } else {
      // 更新
      await FirebaseFirestore.instance.collection('games').doc(game.id).set(gameData);
    }

  }

  /// 試合一覧を取得
  static Future<List<Game>> fetchGames() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid == null) return [];

    final snapshot = await FirebaseFirestore.instance
      .collection('games')
      .where('uid', isEqualTo: uid)
      .orderBy('date', descending: true)
      .get();

    return snapshot.docs.map((doc){
      final data = doc.data();

      return Game(
        id: doc.id,
        date: (data['date'] as Timestamp).toDate(), 
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

  
  static Stream<List<Game>> streamGames() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('games')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Game.fromDocument(doc)).toList());
  }

  static Future<void> deleteGame(String gameId) async {
    await FirebaseFirestore.instance.collection('games').doc(gameId).delete();
  }

  
}




