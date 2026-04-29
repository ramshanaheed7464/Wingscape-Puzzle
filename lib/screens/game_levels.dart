import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:wingscape_puzzle/widgets/text_widget.dart';
import '../utils/sounds.dart';
import 'game_mode.dart';

class GameLevels extends StatefulWidget {
  const GameLevels({super.key});

  @override
  State<GameLevels> createState() => _GameLevelsState();
}

class _GameLevelsState extends State<GameLevels> {
  final controller = Get.find<GameStateController>();
  List<List<int>> diamondPattern = [];

  @override
  void initState() {
    super.initState();
    _createDiamondPattern();
  }

  void _createDiamondPattern() {
    int currentLevel = 1;
    int maxLevels = controller.game.value.levels.length;
    List<int> rowSizes = [1, 2, 3, 4, 3, 2, 1]; // Diamond shape row sizes
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const StyledText(text: 'Levels', fontSize: 44),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            controller.playSound(Sounds.button);
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth * 0.02, screenWidth * 0.01, 0, screenWidth * 0.01),
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              gradient: AppTheme.purpleGradient,
              border: Border.all(color: AppTheme.purpleBorder, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.022),
              child: SvgPicture.asset(AppImages.back),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.background,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenWidth * 0.3),
                  for (var row in diamondPattern)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var level in row)
                          Obx(() => _buildLevelButton(level, screenWidth)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(int level, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (_isLevelUnlocked(level)) {
            controller.playSound(Sounds.button);
            Get.to(() => GameMode(currentLevel: controller.game.value.levels[level-1].copy()));
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: screenWidth * 0.17,
              height: screenWidth * 0.17,
              decoration: BoxDecoration(
                gradient: AppTheme.pinkGradient,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.pinkBorder, width: 3),
              ),
              child: Center(
                child: _isLevelUnlocked(level)
                    ? Text('$level', style: AppTheme.textTheme)
                    : SvgPicture.asset(
                  AppImages.lock,
                  width: screenWidth * 0.07,
                  height: screenWidth * 0.07,
                ),
              ),
            ),
            if (_isLevelUnlocked(level)) ...[
              ..._buildStars(level, screenWidth, screenWidth),
            ],
          ],
        ),
      ),
    );
  }

  bool _isLevelUnlocked(int level) {
    if (level == 1) return true;
    return controller.game.value.levels[level - 2].isComplete;
  }

  List<Widget> _buildStars(int level, double screenWidth, double screenHeight) {
    int stars = controller.game.value.levels[level - 1].stars;
    return [
      Positioned(
        left: -screenWidth * 0.01,
        top: -screenWidth * 0.02,
        child: ClipRRect(
          child: SvgPicture.asset(
            stars >= 1 ? AppImages.pinkStar : AppImages.whiteStar,
            height: screenWidth * 0.07,
            fit: BoxFit.fill,
          ),
        ),
      ),
      Positioned(
        right: -screenWidth * 0.01,
        top: -screenWidth * 0.02,
        child: ClipRRect(
          child: SvgPicture.asset(
            stars >= 3 ? AppImages.pinkStar : AppImages.whiteStar,
            height: screenWidth * 0.07,
            fit: BoxFit.fill,
          ),
        ),
      ),
      Positioned(
        left: screenWidth * 0.035,
        top: -screenWidth * 0.06,
        child: ClipRRect(
          child: SvgPicture.asset(
            stars >= 2 ? AppImages.pinkStar : AppImages.whiteStar,
            height: screenWidth * 0.1,
            fit: BoxFit.fill,
          ),
        ),
      ),
    ];
  }
}