class Game {
  String date;
  String weather;
  int numAtBats;
  List<AtBat> atBats;

  Game({
    required this.date,
    required this.weather,
    required this.numAtBats,
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