class Game {
  String date;
  String weather;
  int numAtBats;
  int runsBattedIn;        // 打点
  int stealSuccesses;      // 盗塁成功数
  int stealAttempts;       // 盗塁試行数
  List<AtBat> atBats;

  Game({
    required this.date,
    required this.weather,
    required this.numAtBats,
    this.runsBattedIn = 0,
    this.stealSuccesses = 0,
    this.stealAttempts =0,
    required this.atBats,
  });
}

class AtBat {
  String? result;
  String? dateTime;

  AtBat({
    this.result,
    this.dateTime,
  });
}