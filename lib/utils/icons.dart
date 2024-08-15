import 'dart:math';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:get/get.dart';

class GameIcons {
  static final Random random = Random();

  static final List<String> iconPaths = [
    AppImages.b1,
    AppImages.b2,
    AppImages.b3,
    AppImages.clock,
    AppImages.b4,
    AppImages.b5,
    AppImages.combo,
  ];

  static final List<int> cumulativeProbabilities = [
    45,
    90,
    125,
    160,
    180,
    200,
    220
  ];

  static String getRandomIcon() {
    int randomNumber = random.nextInt(220);
    for (int i = 0; i < cumulativeProbabilities.length; i++) {
      if (randomNumber < cumulativeProbabilities[i]) {
        return iconPaths[i];
      }
    }
    return iconPaths.last;
  }

  static List<RxString> get observableIcon {
    return iconPaths.map((path) => path.obs).toList();
  }
}
