import 'dart:ui';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/services/game_service.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/widgets/sound_manager.dart';

class GameStateController extends GetxController {
  late SoundManager soundManager;
  Rx<GameModel> get game => GameService.game;

  @override
  void onInit() {
    super.onInit();
    soundManager = SoundManager(
      isSoundOn: game.value.isSoundOn == true,
      isMusicOn: game.value.isMusicOn == true,
    );
  }

  void toggleMusic() {
    game.value.isMusicOn = !game.value.isMusicOn;
    soundManager.toggleMusic(game.value.isMusicOn);
    update();
    saveGameState();
  }

  void playSound(String asset) {
    if (game.value.isSoundOn) {
      soundManager.playSound(asset);
    }
  }

  void switchToEnglish() {
    game.value.isEnSelected = true;
    Get.updateLocale(const Locale('en', 'US'));
    update();
    saveGameState();
  }

  void switchToPortuguese() {
    game.value.isEnSelected = false;
    Get.updateLocale(const Locale('pt', 'BR'));
    update();
    saveGameState();
  }

  Future<void> saveGameState() async {
    await GameService.saveGameDetails();
  }

  void onLevelCompleted(Level level) {
    int index = level.number - 1;
    if (index >= 0 && index < game.value.levels.length) {
      game.value.levels[index] = level;

      if (index + 1 < game.value.levels.length && level.isComplete) {
        game.value.levels[index + 1].isLocked = false;
      }

      game.value.totalStars = calculateTotalStars();
      saveGameState();
      game.refresh();
    }
  }

  int calculateTotalStars() {
    return game.value.levels.fold(0, (sum, level) => sum + level.stars);
  }

  void updateBestScore(Level level) {
    int index = level.number - 1;
    if (index >= 0 && index < game.value.levels.length) {
      game.value.levels[index].bestScore = level.bestScore;
      saveGameState();
      game.refresh();
    }
  }
}