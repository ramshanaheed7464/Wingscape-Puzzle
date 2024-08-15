import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/screens/game_screens/game_mode.dart';
import 'package:wingscape_puzzle/services/game_service.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';
import 'package:wingscape_puzzle/widgets/text_widget.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameLevels extends StatefulWidget {
  const GameLevels({super.key});

  @override
  State<GameLevels> createState() => _GameLevelsState();
}

class _GameLevelsState extends State<GameLevels> {
  final gameStateController = Get.find<GameStateController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GetBuilder<GameStateController>(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.background,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: screenWidth * 0.15,
              left: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () {
                  gameStateController.playSound(Sounds.button);
                  Get.back();
                },
                child: Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    gradient: AppTheme.purpleGradient,
                    border: Border.all(color: AppTheme.purpleBorder, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(AppImages.back),
                ),
              ),
            ),
            Positioned(
                top: screenWidth * 0.13,
                left: screenWidth * 0.40,
                right: screenWidth * 0.40,
                child: StyledText(text: 'level'.tr, fontSize: 42)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 50,
                    itemBuilder: (context, index) {
                      bool isLevelUnlocked =
                          GameService.game.value.levels[index].isComplete ||
                              index == 0;
                      // int stars = GameService.game.value.levels[index].stars;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LevelPattern(index * 8 + 1, isLevelUnlocked),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}

class LevelPattern extends StatelessWidget {
  final int startLevel;
  final bool isLevelUnlocked;

  const LevelPattern(this.startLevel, this.isLevelUnlocked, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: RectangleWidget(
            level: startLevel,
            isLevelUnlocked: isLevelUnlocked,
            stars: GameService.game.value.levels[startLevel - 1].stars,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RectangleWidget(
              level: startLevel + 1,
              isLevelUnlocked: isLevelUnlocked,
              stars: GameService.game.value.levels[startLevel].stars,
            ),
            RectangleWidget(
              level: startLevel + 2,
              isLevelUnlocked: isLevelUnlocked,
              stars: GameService.game.value.levels[startLevel + 1].stars,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RectangleWidget(
              level: startLevel + 3,
              isLevelUnlocked: isLevelUnlocked,
              stars: GameService.game.value.levels[startLevel + 2].stars,
            ),
            RectangleWidget(
              level: startLevel + 4,
              isLevelUnlocked: isLevelUnlocked,
              stars: GameService.game.value.levels[startLevel + 3].stars,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RectangleWidget(
              level: startLevel + 5,
              isLevelUnlocked: isLevelUnlocked,
              stars: GameService.game.value.levels[startLevel + 4].stars,
            ),
            RectangleWidget(
              level: startLevel + 6,
              isLevelUnlocked: isLevelUnlocked,
              stars: GameService.game.value.levels[startLevel + 5].stars,
            ),
          ],
        ),
        Center(
          child: RectangleWidget(
            level: startLevel + 7,
            isLevelUnlocked: isLevelUnlocked,
            stars: GameService.game.value.levels[startLevel + 6].stars,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class RectangleWidget extends StatelessWidget {
  final int level;
  final bool isLevelUnlocked;
  final int stars;

  const RectangleWidget(
      {super.key,
      required this.level,
      required this.isLevelUnlocked,
      required this.stars});

  @override
  Widget build(BuildContext context) {
    final GameStateController controller = Get.find<GameStateController>();

    final screenWidth = context.width;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        GestureDetector(
          onTap: () {
            controller.playSound(Sounds.button);

            if (isLevelUnlocked) {
              Get.to(() => GameMode(
                  currentLevel: GameService.game.value.levels[level].copy()));
            }
          },
          child: Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.pinkGradient,
              border: Border.all(color: AppTheme.pinkBorder, width: 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: isLevelUnlocked
                  ? Text(
                      level.toString(),
                      style: AppTheme.textTheme.copyWith(fontSize: 24),
                    )
                  : Image.asset(
                      AppImages.lock,
                      height: screenWidth * 0.1,
                    ),
            ),
          ),
        ),
        if (isLevelUnlocked) ...[
          Positioned(
            left: -screenWidth * 0.05,
            top: -screenWidth * 0.06,
            child: ClipRRect(
              child: Image.asset(
                stars >= 1 ? AppImages.pinkStar : AppImages.whiteStar,
                height: screenWidth * 0.2,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            right: -screenWidth * 0.08,
            top: -screenWidth * 0.06,
            child: ClipRRect(
              child: Image.asset(
                stars >= 3 ? AppImages.pinkStar : AppImages.whiteStar,
                height: screenWidth * 0.2,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            left: -screenWidth * 0.01,
            // right: screenWidth * 0.01,
            top: -screenWidth * 0.12,
            child: ClipRRect(
              child: Image.asset(
                stars >= 2 ? AppImages.pinkStar : AppImages.whiteStar,
                height: screenWidth * 0.25,
                width: screenWidth * 0.25,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                 ),
//                 itemCount: GameService.game.value.levels.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   bool isLevelUnlocked = index == 0 ||
//                       GameService.game.value.levels[index - 1].isComplete;
//                   int stars = GameService.game.value.levels[index].stars;

//                   return Stack(
//                     clipBehavior: Clip.none,
//                     fit: StackFit.passthrough,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           gameStateController.playSound(Sounds.button);

//                           if (isLevelUnlocked) {
//                             Get.to(() => GameMode(
//                                 currentLevel: GameService
//                                     .game.value.levels[index]
//                                     .copy()));
//                           }
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             gradient: AppTheme.pinkGradient,
//                             border: Border.all(
//                                 color: AppTheme.pinkBorder, width: 3),
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           child: Center(
//                             child: isLevelUnlocked
//                                 ? Text(
//                                     '${index + 1}',
//                                     style: AppTheme.textTheme
//                                         .copyWith(fontSize: 24),
//                                   )
//                                 : Image.asset(
//                                     AppImages.lock,
//                                     height: screenWidth * 0.1,
//                                   ),
//                           ),
//                         ),
//                       ),
//                       if (isLevelUnlocked) ...[
//                         Positioned(
//                           left: -screenWidth * 0.014,
//                           top: -screenWidth * 0.03,
//                           child: ClipRRect(
//                             child: Image.asset(
//                               stars >= 1
//                                   ? AppImages.pinkStar
//                                   : AppImages.whiteStar,
//                               height: screenWidth * 0.25,
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           right: -screenWidth * 0.05,
//                           top: -screenWidth * 0.03,
//                           child: ClipRRect(
//                             child: Image.asset(
//                               stars >= 3
//                                   ? AppImages.pinkStar
//                                   : AppImages.whiteStar,
//                               height: screenWidth * 0.25,
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: screenWidth * 0.07,
//                           right: screenWidth * 0.001,
//                           top: -screenWidth * 0.1,
//                           child: ClipRRect(
//                             child: Image.asset(
//                               stars >= 2
//                                   ? AppImages.pinkStar
//                                   : AppImages.whiteStar,
//                               height: screenWidth * 0.3,
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   );
//                 },
//               ),
//             ),
          