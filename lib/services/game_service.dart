import 'dart:convert';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/services/local_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GameService {
  static late Rx<GameModel> game;

  static const String _gameKey = 'game_data';

  static initStorageData() async {
    await _loadGameDetails();
  }

  static Future<void> _loadGameDetails() async {
    final gameString = await Storage.getString(_gameKey);
    if (gameString.isNotEmpty) {
      try {
        final gameJson = jsonDecode(gameString);
        game = GameModel.fromJson(gameJson).obs;
        _validateGameData();
      } catch (e) {
        print("Error loading game data: $e");
        _initializeNewGame();
      }
    } else {
      _initializeNewGame();
    }
    game.refresh();
  }

  static void _initializeNewGame() {
    game = GameModel(
        levels: List.generate(
          400,
              (index) => Level(
              isLocked: index > 0,
              isCompleted: false,
              stars: 0,
              number: index+1,
              remainingTime: 0,
              score: 0,
              points: 0,
              bestScore: 0),
        ),
        isSoundOn: true,
        isMusicOn: true,
        currentLevel: 1,
        totalStars: 0).obs;
  }

  static void _validateGameData() {
    for (int i = 1; i < game.value.levels.length; i++) {
      if (!game.value.levels[i - 1].isComplete) {
        game.value.levels[i].isLocked = true;
      }
    }
  }

  static Future<void> saveGameDetails() async {
    try {
      final gameJson = game.toJson();
      await Storage.setString(_gameKey, jsonEncode(gameJson));
      game.refresh();
    } catch (e) {
      print("Error saving game data: $e");
    }
  }
}
