import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';
import 'package:wingscape_puzzle/widgets/incomplete_card.dart';
import 'package:wingscape_puzzle/widgets/level_card.dart';
import 'package:wingscape_puzzle/widgets/text_widget.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:wingscape_puzzle/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'board.dart';

class GameMode extends StatefulWidget {
  const GameMode({Key? key, required this.currentLevel}) : super(key: key);
  final Level currentLevel;

  @override
  State<GameMode> createState() => _GameModeState();
}

class _GameModeState extends State<GameMode> {
  late Level currentLevel;
  Timer? countdownTimer;
  final controller = Get.find<GameStateController>();

  @override
  void initState() {
    super.initState();
    currentLevel = widget.currentLevel;
    initTargetsAndCounts();
    currentLevel.remainingTime = calculateTimeLimit(currentLevel.number);
    }
  final GlobalKey<SymbolMatchingState> _gameBoardKey =
      GlobalKey<SymbolMatchingState>();

  Map<String, dynamic> containerCounts = {};
  Map<String, dynamic> containerTargets = {};
  List<String> containerImages = [
    AppImages.b1,
    AppImages.b2,
    AppImages.b3,
    AppImages.b4,
    AppImages.b5
  ];

  Future<void> initTargetsAndCounts() async {
    initializeContainers();
  }

  void initializeContainers() {
    int levelGroup = (currentLevel.number - 1) ~/ 8;
    int basePoints = 1000 + (levelGroup * 400); // Reduced points scaling
    int baseDifficulty = 8 + (levelGroup * 4);  // Reduced base difficulty scaling

    int randomize(int base, int range) => base + Random().nextInt(range);

    // Initialize containerCounts with default values
    for (var image in containerImages) {
      containerCounts[image] = 0;
    }

    switch (currentLevel.number % 8) {
      case 1:
      // Logic for level 1, 9, 17, 25...
        for (var image in containerImages) {
          containerCounts[image] = randomize(baseDifficulty, 10);
        }
        currentLevel.points = 0;
        break;
      case 2:
      // Logic for level 2, 10, 18, 26...
        containerCounts[containerImages[0]] = randomize(baseDifficulty * 2, 15);
        containerCounts[containerImages[1]] = randomize(baseDifficulty * 2, 15);
        for (int i = 2; i < 5; i++) {
          containerCounts[containerImages[i]] = randomize(baseDifficulty, 10);
        }
        currentLevel.points = 0;
        break;
      case 3:
      // Logic for level 3, 11, 19, 27...
        for (int i = 0; i < 5; i++) {
          containerCounts[containerImages[i]] = randomize(baseDifficulty + (i * 5), 15);
        }
        currentLevel.points = 0;
        break;
      case 4:
      // Logic for level 4, 12, 20, 28...
        for (var image in containerImages) {
          containerCounts[image] = randomize(baseDifficulty, 30);
        }
        currentLevel.points = 0;
        break;
      case 5:
      // Logic for level 5, 13, 21, 29...
        for (int i = 0; i < 4; i++) {
          containerCounts[containerImages[i]] = randomize(baseDifficulty * 2, 20);
        }
        containerCounts[containerImages[4]] = randomize(baseDifficulty ~/ 2, 10);
        currentLevel.points = basePoints ~/ 2;
        break;
      case 6:
      // Logic for level 6, 14, 22, 30...
        containerCounts[containerImages[0]] = randomize(baseDifficulty * 3, 25);
        containerCounts[containerImages[1]] = randomize(baseDifficulty ~/ 2, 10);
        for (int i = 2; i < 5; i++) {
          containerCounts[containerImages[i]] = randomize((baseDifficulty * 3) ~/ 2, 15);
        }
        currentLevel.points = basePoints ~/ 2;
        break;
      case 7:
      // Logic for level 7, 15, 23, 31...
        for (var image in containerImages) {
          containerCounts[image] = randomize(baseDifficulty * 3, 30);
        }
        currentLevel.points = basePoints ~/ 2;
        break;
      case 0:
      // Logic for level 8, 16, 24, 32... (8th level in each group)
        containerCounts[containerImages[0]] = randomize(baseDifficulty * 4, 40);
        containerCounts[containerImages[1]] = randomize(baseDifficulty * 3, 30);
        containerCounts[containerImages[2]] = randomize(baseDifficulty * 3, 30);
        containerCounts[containerImages[3]] = randomize(baseDifficulty * 2, 20);
        containerCounts[containerImages[4]] = randomize(baseDifficulty * 2, 20);
        currentLevel.points = basePoints;
        break;
    }


    for (var image in containerImages) {
      containerCounts[image] = max<int>(containerCounts[image] ?? 5, 5);
    }
  }

  Widget buildContainerStack(String image) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Get.width * 0.1,
          height: Get.width * 0.1,
          decoration: const BoxDecoration(
            color: AppTheme.peach,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              image,
              width: Get.width * 0.07,
              height: Get.width * 0.07,
            ),
          ),
        ),
        Positioned(
          bottom: -Get.width * 0.02,
          right: -Get.width * 0.02,
          child: containerCounts[image] != null && containerCounts[image]! > 0
              ? CustomContainer(number: containerCounts[image]!)
              : Container(
                  width: Get.width * 0.06,
                  height: Get.width * 0.06,
                  decoration: BoxDecoration(
                    color: AppTheme.pink,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppImages.badge,
                      width: Get.width * 0.04,
                      height: Get.width * 0.04,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.playSound(Sounds.button);
        if (!currentLevel.isStarted) {
          setState(() {
            currentLevel.isStarted = true;
            startLevel();
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: StyledText(text: 'Level ${currentLevel.number}', fontSize: 42),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppImages.background,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.9),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(context.width * 0.04, context.width * 0.2, context.width * 0.04, 16),
                  child: Column(
                    children: [
                      if (currentLevel.number % 8 == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              const StyledText(text: 'Target', fontSize: 24),
                              Container(
                                width: Get.width * 0.26,
                                height: Get.width * 0.1,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.line,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Container(
                                    width: Get.width * 0.29,
                                    height: Get.width * 0.1,
                                    decoration: BoxDecoration(
                                        gradient: AppTheme.pinkGradient,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: Center(
                                        child: Text(
                                      '${currentLevel.points}',
                                      style: AppTheme.textTheme
                                          .copyWith(fontSize: 24),
                                    )),
                                  ),
                                ),
                              ),
                            ]),
                            Column(
                              children: [
                                const StyledText(text: 'Points', fontSize: 24),
                                Container(
                                  width: Get.width * 0.26,
                                  height: Get.width * 0.1,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.line,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: Get.width * 0.29,
                                      height: Get.width * 0.1,
                                      decoration: BoxDecoration(
                                          gradient: AppTheme.pinkGradient,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: Center(
                                          child: Text(
                                        '${currentLevel.score}',
                                        style: AppTheme.textTheme
                                            .copyWith(fontSize: 24),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.clock,
                                    width: context.width * 0.15,
                                    height: context.width * 0.15,
                                    fit: BoxFit.fill,
                                  ),
                                  StyledText(
                                      text: formatTime(
                                          currentLevel.remainingTime),
                                      fontSize: 24)
                                ],
                              ),
                              SizedBox(
                                width: context.width * 0.3,
                                height: context.width * 0.02,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return AppTheme.line.createShader(bounds);
                                    },
                                    child: LinearProgressIndicator(
                                      value: calculateProgressValue(),
                                      backgroundColor: Colors.grey,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              AppTheme.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: containerImages
                                .map((image) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.01),
                                      child: buildContainerStack(image),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppTheme.pinkBorder, width: 5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SymbolMatching(
                                constraints: constraints,
                                key: _gameBoardKey,
                                onMatch: updateContainers,
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: context.width * 0.12)
                    ],
                  ),
                ),
                Positioned(
                  bottom: context.width * 0.05,
                  right: Get.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      if (_gameBoardKey.currentState != null) {
                        _gameBoardKey.currentState!.refreshBoard();
                      }
                      reduceTimeByFiveSeconds();
                    },
                    child: Container(
                      width: context.width * 0.15,
                      height: context.width * 0.15,
                      decoration: BoxDecoration(
                        gradient: AppTheme.purpleGradient,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: SvgPicture.asset(AppImages.refresh)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: context.width * 0.05,
                  left: Get.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      controller.playSound(Sounds.pause);
                      setState(() {
                        currentLevel.isStopped = true;
                        pauseTimer();
                      });
                    },
                    child: Container(
                      width: context.width * 0.15,
                      height: context.width * 0.15,
                      decoration: BoxDecoration(
                          gradient: AppTheme.purpleGradient,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(child: SvgPicture.asset(AppImages.pause)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!currentLevel.isStarted) letsStart(),
          if (currentLevel.isStopped) pauseGame(),
          if (currentLevel.isComplete)
            _buildCompletionCard(),
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    if (currentLevel.allTargetsAchieved) {
      return LevelCard(
        currentLevel: currentLevel,
        onPlay: () {
          setState(() {
            resetContainers();
            nextLevel();
          });
        },
        onRestart: () {
          setState(() {
            currentLevel.isComplete = false;
            restartLevel();
          });
        },
        onExit: exitLevel,
        remainingTime: currentLevel.finalTime,
        stars: calculateStars(currentLevel.remainingTime),
      );
    } else {
      return IncompleteLevelCard(
        currentLevel: currentLevel,
        onRestart: () {
          setState(() {
            currentLevel.isComplete = false;
            restartLevel();
          });
        },
        onExit: () {
          setState(() {
            currentLevel.isComplete = false;
            Get.back();
          });
        },
      );
    }
  }

  void exitLevel() {
    if (currentLevel.isComplete && currentLevel.allTargetsAchieved) {
      // If the level is complete and all targets achieved, save the state
      unawaited(controller.onLevelCompleted(currentLevel));
      print("Exiting level ${currentLevel.number}. IsComplete: ${currentLevel.isComplete}, AllTargetsAchieved: ${currentLevel.allTargetsAchieved}");

    } else {
      // If the level is not complete or targets not achieved, reset it
      setState(() {
        currentLevel.isComplete = false;
        currentLevel.allTargetsAchieved = false;
        resetContainers();
      });
      print("Exiting level ${currentLevel.number}. IsComplete: ${currentLevel.isComplete}, AllTargetsAchieved: ${currentLevel.allTargetsAchieved}");

    }

    Get.back();
  }

  void endGame(bool completed) async {
    setState(() {
      currentLevel.isComplete = true;
      currentLevel.allTargetsAchieved = completed;
      currentLevel.finalTime = currentLevel.remainingTime;

      if (completed) {
        int earnedStars = calculateStars(currentLevel.remainingTime);
        if (earnedStars > currentLevel.stars) {
          currentLevel.stars = earnedStars;
        }
        unawaited(controller.onLevelCompleted(currentLevel));
      }
      unawaited(controller.saveGameState());
    });
  }

  Widget letsStart() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: AppTheme.blur.withOpacity(0.5),
          child: const Center(child:  StyledText(text: 'Go!', fontSize: 64)),
        ),
      ),
    );
  }

  Widget pauseGame() {
    pauseTimer();

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const StyledText(text: 'Pause', fontSize: 52),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.playSound(Sounds.button);
                          setState(() {
                            currentLevel.isStopped = false;
                            resumeTimer();
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            border: Border.all(
                                color: AppTheme.purpleBorder, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                            child: SvgPicture.asset(AppImages.resume),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.playSound(Sounds.button);
                          setState(() {
                            currentLevel.isStopped = false;
                            restartLevel();
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            border: Border.all(
                                color: AppTheme.purpleBorder, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(AppImages.restart),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.playSound(Sounds.button);
                          currentLevel.isStopped = false;
                          Get.back();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            border: Border.all(
                                color: AppTheme.purpleBorder, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              AppImages.exit,
                              height: 4,
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startLevel() {
    if (currentLevel.isStarted) {
      setState(() {
        currentLevel.remainingTime = calculateTimeLimit(currentLevel.number);
      });
      startTimer();
    }
  }

  void startTimer() {
    if (countdownTimer != null && countdownTimer!.isActive) {
      return;
    }

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentLevel.remainingTime > 0) {
          currentLevel.remainingTime--;
        } else if(currentLevel.remainingTime == 5){
          controller.playSound(Sounds.timer);
        } else {
          timer.cancel();
          endGame(false);
        }
      });
    });
  }

  void pauseTimer() {
    countdownTimer?.cancel();
  }

  void resumeTimer() {
    if (countdownTimer == null || !countdownTimer!.isActive) {
      startTimer();
    }
  }

  void restartLevel() {
    setState(() {
      resetContainers();
      _gameBoardKey.currentState?.refreshBoard();
      startLevel();
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secondsLeft = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }

  void resetContainers() {
    setState(() {
      initializeContainers();
      if (currentLevel.number % 8 == 0) {
        currentLevel.resetScore();
      }
      currentLevel.allTargetsAchieved = false;
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void updateScore(int scoreGain) {
    setState(() {
      currentLevel.score += scoreGain;
      if (currentLevel.score > currentLevel.bestScore) {
        currentLevel.bestScore = currentLevel.score;
        controller.updateBestScore(currentLevel);
      }
      unawaited(controller.saveGameState());
    });
  }

  void updateContainers(List<String> matchedImages, int matchCount) {
    setState(() {
      int wildCount =
          matchedImages.where((img) => img == AppImages.combo).length;

      if (wildCount == matchedImages.length) {
        return;
      }

      String nonWildSymbol = matchedImages.firstWhere(
            (img) => img != AppImages.combo,
        orElse: () => '',
      );

      if (nonWildSymbol.isNotEmpty &&
          containerCounts.containsKey(nonWildSymbol)) {
        int toRemove = min(matchCount, containerCounts[nonWildSymbol]!);
        int c = containerCounts[nonWildSymbol]!;
        containerCounts[nonWildSymbol] = (max(0, c - toRemove));

        // Play match sound if target is not completed
        if (containerCounts[nonWildSymbol] > 0) {
          controller.playSound(Sounds.match);
        }
        // Play target sound if target is completed
        else if (containerCounts[nonWildSymbol] == 0) {
          controller.playSound(Sounds.target);
        }
      }

      int scoreGain = 0;
      String matchedSymbol =
      nonWildSymbol.isNotEmpty ? nonWildSymbol : matchedImages.first;

      switch (matchedSymbol) {
        case AppImages.b1:
          scoreGain = 2 + (matchCount > 3 ? (matchCount - 3) * 2 : 0);
          break;
        case AppImages.b2:
          scoreGain = 3 + (matchCount > 3 ? (matchCount - 3) * 3 : 0);
          break;
        case AppImages.b3:
          scoreGain = 4 + (matchCount > 3 ? (matchCount - 3) * 3 : 0);
          break;
        case AppImages.b4:
          scoreGain = 4 + (matchCount > 3 ? (matchCount - 3) * 4 : 0);
          break;
        case AppImages.b5:
          scoreGain = 5 + (matchCount > 3 ? (matchCount - 3) * 5 : 0);
          break;
        case AppImages.clock:
          int timeBonus = 5 + (matchCount > 3 ? (matchCount - 3) * 10 : 0);
          currentLevel.remainingTime += timeBonus;
          showTimeBonusIndicator(timeBonus);
          break;
        case AppImages.combo:
          break;
      }

      updateScore(scoreGain);

      // Check if any of the matched images is a clock
      if (matchedImages.contains(AppImages.clock)) {
        if (controller.game.value.isSoundOn) {
          controller.playSound(Sounds.pause);
        }
      }

      checkAllTargetsAchieved();
    });
  }

  void showTimeBonusIndicator(int timeBonus) {
    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2,
        left: MediaQuery.of(context).size.width / 2,
        child: Material(
          color: Colors.transparent,
          child: Text(
            '+$timeBonus',
            style: const TextStyle(
              color: AppTheme.pinkBorder,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);

    Future.delayed(const Duration(milliseconds: 1500), () {
      overlay.remove();
    });
  }

  void checkAllTargetsAchieved() {
    // Standardize level completion logic for all levels
    if (currentLevel.number % 8 == 0) {
      currentLevel.allTargetsAchieved =
          currentLevel.score >= currentLevel.points &&
              containerCounts.values.every((count) => count == 0);
    } else {
      currentLevel.allTargetsAchieved =
          containerCounts.values.every((count) => count == 0);
    }
    if (currentLevel.allTargetsAchieved) {
      if (countdownTimer != null) {
        countdownTimer?.cancel();
      }
      endGame(true);
    }
    controller.saveGameState();
  }

  int calculateStars(int remainingTime) {
    if (remainingTime > 60) {
      return 3;
    } else if (remainingTime <= 60 && remainingTime >= 40) {
      return 2;
    } else if (remainingTime > 0 && remainingTime < 40) {
      return 1;
    } else {
      return 0;
    }
  }

  void nextLevel() {
    final levels = controller.game.value.levels;
    final nextIndex = currentLevel.number;
    if (currentLevel.number % 8 == 0) {
      currentLevel.resetScore();
    }

    if (nextIndex < levels.length) {
      Get.back();
      Get.to(() => GameMode(currentLevel: levels[nextIndex].copy()));
    }
  }

  int calculateTimeLimit(int level) {

    int baseTime = 80;
    int groupNumber = (level - 1) ~/ 8;
    return baseTime + (groupNumber * 10);
  }

  void reduceTimeByFiveSeconds() {
    setState(() {
      currentLevel.remainingTime = max(0, currentLevel.remainingTime - 5);
    });
  }

  double calculateProgressValue() {
    int totalTime = calculateTimeLimit(currentLevel.number);
    return currentLevel.remainingTime / totalTime;
  }
}
