import 'package:flutter_svg/svg.dart';
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

  List<List<int>> diamondPattern = [];

  @override
  void initState() {
    super.initState();
    _createDiamondPattern();
  }

  void _createDiamondPattern() {
    int currentLevel = 1;
    int maxLevels = 400;
    List<int> rowSizes = [1, 2, 3, 4, 3, 2, 1];
    int rowSizeIndex = 0;

    while (currentLevel <= maxLevels) {
      List<int> row = [];
      int rowSize = rowSizes[rowSizeIndex];

      for (int i = 0; i < rowSize; i++) {
        if (currentLevel <= maxLevels) {
          row.add(currentLevel);
          currentLevel++;
        }
      }
      diamondPattern.add(row);

      rowSizeIndex = (rowSizeIndex + 1) % rowSizes.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const StyledText(text: 'Levels', fontSize: 52),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            // gameStateController.playSound(Sounds.button);
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 2, 0, 2),
            width: screenWidth * 0.03,
            height: screenHeight * 0.03,
            decoration: BoxDecoration(
              gradient: AppTheme.purpleGradient,
              border: Border.all(color: AppTheme.purpleBorder, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(AppImages.back),
          ),
        ),
      ),
      body: GetBuilder<GameStateController>(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.background,
                fit: BoxFit.cover,
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.3,
                      horizontal: screenWidth * 0.05),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, rowIndex) {
                        return Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: screenWidth * 0.02,
                            children: diamondPattern[rowIndex].map((level) {
                              bool isLevelUnlocked = level == 1 ||
                                  GameService
                                      .game.value.levels[level - 1].isComplete;
                              int stars = GameService
                                  .game.value.levels[level - 1].stars;

                              return _buildLevelButton(
                                level,
                                isLevelUnlocked,
                                stars,
                                screenWidth,
                                screenHeight,
                              );
                            }).toList(),
                          ),
                        );
                      },
                      childCount: diamondPattern.length,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLevelButton(int level, bool isLevelUnlocked, int stars,
      double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () {
        // gameStateController.playSound(Sounds.button);
        if (isLevelUnlocked) {
          Get.to(() => GameMode(
              currentLevel: GameService.game.value.levels[level - 1].copy()));
        }
      },
      child: Container(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        margin: EdgeInsets.all(screenWidth * 0.01),
        decoration: BoxDecoration(
          gradient: AppTheme.pinkGradient,
          border: Border.all(color: AppTheme.pinkBorder, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: [
            Center(
              child: isLevelUnlocked
                  ? Text(
                      '$level',
                      style: AppTheme.textTheme.copyWith(fontSize: 24),
                    )
                  : SvgPicture.asset(
                      AppImages.lock,
                      height: screenHeight * 0.05,
                    ),
            ),
            if (isLevelUnlocked) ...[
              Positioned(
                left: -screenWidth * 0.04,
                top: -screenWidth * 0.04,
                child: ClipRRect(
                  child: SvgPicture.asset(
                    stars >= 1 ? AppImages.pinkStar : AppImages.whiteStar,
                    height: screenWidth * 0.1,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                right: -screenWidth * 0.04,
                top: -screenWidth * 0.04,
                child: ClipRRect(
                  child: SvgPicture.asset(
                    stars >= 3 ? AppImages.pinkStar : AppImages.whiteStar,
                    height: screenWidth * 0.1,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                left: -screenWidth * 0.01,
                right: -screenWidth * 0.01,
                top: -screenWidth * 0.1,
                child: ClipRRect(
                  child: SvgPicture.asset(
                    stars >= 2 ? AppImages.pinkStar : AppImages.whiteStar,
                    height: screenWidth * 0.15,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
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
//                                 : SvgPicture.asset(
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
//                             child: SvgPicture.asset(
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
//                             child: SvgPicture.asset(
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
//                             child: SvgPicture.asset(
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
          