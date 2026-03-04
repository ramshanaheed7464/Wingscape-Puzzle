import 'dart:convert';

import 'package:get/get.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/services/game_repository.dart';
import 'package:wingscape_puzzle/services/local_storage.dart';

class GameService extends GetxService implements GameRepository {
  static const String _gameKey = 'game_data';

  @override
  late Rx<GameModel> game;

  Future<GameService> init() async {
    await load();
    return this;
  }

  @override
  Future<void> load() async {
    final gameString = await Storage.getString(_gameKey);
    if (gameString.isNotEmpty) {
      try {
        final gameJson = jsonDecode(gameString) as Map<String, dynamic>;
        game = GameModel.fromJson(gameJson).obs;
        _validateGameData();
      } catch (_) {
        _initializeNewGame();
      }
    } else {
      _initializeNewGame();
    }
    game.refresh();
  }

  void _initializeNewGame() {
    game = GameModel(
      levels: List.generate(
        400,
        (index) => Level(
          isLocked: index > 0,
          isCompleted: false,
          stars: 0,
          number: index + 1,
          remainingTime: 0,
          score: 0,
          points: 0,
          bestScore: 0,
        ),
      ),
      isSoundOn: true,
      isMusicOn: true,
      currentLevel: 1,
      totalStars: 0,
    ).obs;
  }

  void _validateGameData() {
    for (int i = 1; i < game.value.levels.length; i++) {
      if (!game.value.levels[i - 1].isComplete) {
        game.value.levels[i].isLocked = true;
      }
    }
  }

  @override
  Future<void> save() async {
    final gameJson = game.toJson();
    await Storage.setString(_gameKey, jsonEncode(gameJson));
    game.refresh();
  }
}
