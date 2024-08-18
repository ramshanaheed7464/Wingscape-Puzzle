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
      final gameJson = jsonDecode(gameString);
      game = GameModel.fromJson(gameJson).obs;
    } else {
      game = GameModel(
              levels: List.generate(
                400,
                (index) => Level(
                    isLocked: index > 1,
                    isCompleted: false,
                    stars: 0,
                    number: index,
                    remainingTime: 0,
                    score: 0,
                    points: 0,
                    bestScore: 0),
              ),
              isSoundOn: true,
              isMusicOn: true,
              currentLevel: 1,
              totalStars: 0)
          .obs;
    }
  }

  static Future<void> saveGameDetails() async {
    final gameJson = game.toJson();
    await Storage.setString(_gameKey, jsonEncode(gameJson));
  }
}
