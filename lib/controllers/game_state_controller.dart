import 'dart:ui';

import 'package:wingscape_puzzle/services/game_service.dart';
import 'package:wingscape_puzzle/widgets/game_sounds.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/model/game_model.dart';

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

  // void toggleMusic() {
  //   game.value.isMusicOn = !game.value.isMusicOn;
  //   soundManager.toggleMusic(game.value.isMusicOn);
  //   update();
  //   saveGameState();
  // }

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

  void playSound(String asset) {
    if (game.value.isSoundOn) {
      soundManager.playSound(asset);
    }
  }

  void onLevelCompleted(Level level) {
    GameService.game.value.levels[level.number] = level;
    GameService.game.value.totalStars = calculateTotalStars();
    GameService.saveGameDetails();
    saveGameState();
    update();
  }

  int calculateTotalStars() {
    return game.value.levels.fold(0, (sum, level) => sum + level.stars);
  }

  void updateBestScore(Level level) {
    GameService.game.value.levels[level.number].bestScore = level.bestScore;
    saveGameState();
  }
}
