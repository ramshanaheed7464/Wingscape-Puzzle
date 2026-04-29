class GameModel {
  List<Level> levels;
  int? currentLevel;
  bool isEnSelected;
  bool isMusicOn;
  bool isSoundOn;
  int totalStars;

  GameModel({
    required this.levels,
    required this.currentLevel,
    this.isEnSelected = true,
    this.isMusicOn = true,
    this.isSoundOn = true,
    this.totalStars = 0,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      levels: List<Level>.from(
          json['levels'].map((level) => Level.fromJson(level))),
      currentLevel: json['currentLevel'] ?? 0,
      isEnSelected: json['isEnSelected'] as bool? ?? true,
      isMusicOn: json['isMusicOn'] as bool? ?? true,
      isSoundOn: json['isSoundOn'] as bool? ?? true,
      totalStars: json['totalStars'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levels': levels.map((level) => level.toJson()).toList(),
      'isEnSelected': isEnSelected,
      'isMusicOn': isMusicOn,
      'isSoundOn': isSoundOn,
      'totalStars': totalStars,
      'currentLevel': currentLevel,
    };
  }
}

class Level {
  int number;
  int stars;
  bool isLocked;
  bool isStarted;
  bool isComplete;
  bool allTargetsAchieved;
  int remainingTime;
  int finalTime;
  int points;
  int score;
  int bestScore;
  bool isStopped;

  Level({
    required this.number,
    required this.stars,
    this.isLocked = true,
    this.isStarted = false,
    this.isComplete = false,
    this.allTargetsAchieved = false,
    required this.remainingTime,
    this.finalTime = 0,
    required this.points,
    required this.score,
    required this.bestScore,
    this.isStopped = false,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      number: json['number'] as int,
      stars: json['stars'] as int? ?? 0,
      isLocked: json['isLocked'] as bool? ?? true,
      isStarted: json['isStarted'] as bool? ?? false,
      isComplete: json['isComplete'] as bool? ?? false,
      allTargetsAchieved: json['allTargetsAchieved'] as bool? ?? false,
      remainingTime: json['remainingTime'] as int? ?? 0,
      finalTime: json['finalTime'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
      isStopped: json['isStopped'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'stars': stars,
      'isLocked': isLocked,
      'isStarted': isStarted,
      'isComplete': isComplete,
      'allTargetsAchieved': allTargetsAchieved,
      'remainingTime': remainingTime,
      'finalTime': finalTime,
      'points': points,
      'score': score,
      'bestScore': bestScore,
      'isStopped': isStopped,
    };
  }

  void resetScore() {
    score = 0;
  }

  Level copy() {
    return Level(
      number: number,
      stars: stars,
      isLocked: false,
      remainingTime: remainingTime,
      points: 0,
      score: 0,
      bestScore: bestScore,
    );
  }
}
