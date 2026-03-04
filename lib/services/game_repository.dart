import 'package:get/get.dart';
import 'package:wingscape_puzzle/model/game_model.dart';

abstract class GameRepository {
  Rx<GameModel> get game;

  Future<void> load();
  Future<void> save();
}
