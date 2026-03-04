import 'dart:ui';

import 'package:get/get.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/services/game_repository.dart';
import 'package:wingscape_puzzle/widgets/sound_manager.dart';

class GameStateController extends GetxController {
  GameStateController(this._repository);

  final GameRepository _repository;
  late final SoundManager soundManager;

  Rx<GameModel> get game => _repository.game;

  @override
  void onInit() {
    super.onInit();
    soundManager = SoundManager(
      isSoundOn: game.value.isSoundOn,
      isMusicOn: game.value.isMusicOn,
    );
  }

  Future<void> toggleSound() async {
    game.value.isSoundOn = !game.value.isSoundOn;
    update();
    await saveGameState();
  }

  Future<void> toggleMusic() async {
    game.value.isMusicOn = !game.value.isMusicOn;
    soundManager.toggleMusic(game.value.isMusicOn);
    update();
    await saveGameState();
  }

  void playSound(String asset) {
    if (game.value.isSoundOn) {
      soundManager.playSound(asset);
    }
  }

  Future<void> switchToEnglish() async {
    game.value.isEnSelected = true;
    Get.updateLocale(const Locale('en', 'US'));
    update();
    await saveGameState();
  }

  Future<void> switchToPortuguese() async {
    game.value.isEnSelected = false;
    Get.updateLocale(const Locale('pt', 'BR'));
    update();
    await saveGameState();
  }

  Future<void> saveGameState() async {
    await _repository.save();
  }

  Future<void> onLevelCompleted(Level level) async {
    final index = level.number - 1;
    if (index >= 0 && index < game.value.levels.length) {
      game.value.levels[index] = level;

      if (index + 1 < game.value.levels.length && level.isComplete) {
        game.value.levels[index + 1].isLocked = false;
      }

      game.value.totalStars = calculateTotalStars();
      game.refresh();
      await saveGameState();
    }
  }

  int calculateTotalStars() {
    return game.value.levels.fold(0, (sum, level) => sum + level.stars);
  }

  Future<void> updateBestScore(Level level) async {
    final index = level.number - 1;
    if (index >= 0 && index < game.value.levels.length) {
      game.value.levels[index].bestScore = level.bestScore;
      game.refresh();
      await saveGameState();
    }
  }
}
