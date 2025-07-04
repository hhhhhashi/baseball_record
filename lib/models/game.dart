import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Game {
  String? id;
  DateTime date;
  String weather;
  int numAtBats;
  int runsBattedIn;        // 打点
  int stealSuccesses;      // 盗塁成功数
  int stealAttempts;       // 盗塁試行数
  List<AtBat> atBats;

  Game({
    this.id,
    required this.date,
    required this.weather,
    required this.numAtBats,
    this.runsBattedIn = 0,
    this.stealSuccesses = 0,
    this.stealAttempts =0,
    required this.atBats,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date, 
      'weather': weather,
      'numAtBats': numAtBats,
      'runsBattedIn': runsBattedIn,
      'stealSuccesses': stealSuccesses,
      'stealAttempts': stealAttempts,
      'atBats': atBats.map((a) => a.toMap()).toList(),
      'uid': FirebaseAuth.instance.currentUser?.uid,
    };
  }

  factory Game.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      weather: data['weather'] ?? '',
      numAtBats: data['numAtBats'] ?? 0,
      runsBattedIn: data['runsBattedIn'] ?? 0,
      stealSuccesses: data['stealSuccesses'] ?? 0,
      stealAttempts: data['stealAttempts'] ?? 0,
      atBats: (data['atBats'] as List).map((e) => AtBat.fromMap(e)).toList(),
    );
  }
}

class AtBat {
  String? result;
  String? dateTime;

  AtBat({
    this.result,
    this.dateTime,
  });

  // Firestoreに保存する形式に変換
  Map<String, dynamic> toMap() {
    return {
      'result': result ?? '',
      'dateTime': dateTime ?? '',
    };
  }

  // FirestoreからのデータをAtBatに変換
  factory AtBat.fromMap(Map<String, dynamic> map) {
    return AtBat(
      result: map['result'] ?? '',
      dateTime: map['dateTime'] ?? '',
    );
  }
}