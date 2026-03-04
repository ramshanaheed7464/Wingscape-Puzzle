import 'package:get/get.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/services/game_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameStateController>(
      () => GameStateController(Get.find<GameRepository>()),
      fenix: true,
    );
  }
}
