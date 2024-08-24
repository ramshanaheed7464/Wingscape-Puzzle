import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/services/game_service.dart';
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
  const GameMode({super.key, required this.currentLevel});
  final Level currentLevel;

  @override
  State<GameMode> createState() => _GameModeState();
}

class _GameModeState extends State<GameMode> {
  late final Level currentLevel;
  final GlobalKey<SymbolMatchingState> _gameBoardKey =
      GlobalKey<SymbolMatchingState>();
  Timer? countdownTimer;
  final controller = Get.find<GameStateController>();

  Map<String, dynamic> containerCounts = {};
  Map<String, dynamic> containerTargets = {};
  List<String> containerImages = [
    AppImages.b1,
    AppImages.b2,
    AppImages.b3,
    AppImages.b4,
    AppImages.b5
  ];

  @override
  void initState() {
    super.initState();
    currentLevel = widget.currentLevel;
    initTargetsAndCounts();
    currentLevel.remainingTime = calculateTimeLimit(currentLevel.number);
  }

  Future<void> initTargetsAndCounts() async {
    initializeContainers();
  }

  void initializeContainers() {
    int levelGroup = (currentLevel.number - 1) ~/ 8;

    switch (currentLevel.number % 8) {
      case 0:
        containerCounts[containerImages[0]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[1]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[2]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[3]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[4]] = 10;
        break;
      case 1:
        containerCounts[containerImages[0]] = 20 + (levelGroup * 15);
        containerCounts[containerImages[1]] = 20 + (levelGroup * 15);
        containerCounts[containerImages[2]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[3]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[4]] = 0;
        break;
      case 2:
        containerCounts[containerImages[0]] = 15 + (levelGroup * 15);
        containerCounts[containerImages[1]] = 15 + (levelGroup * 15);
        containerCounts[containerImages[2]] = 15 + (levelGroup * 15);
        containerCounts[containerImages[3]] = 10 + (levelGroup * 15);
        containerCounts[containerImages[4]] = 10 + (levelGroup * 15);
        break;
      case 3:
        containerCounts[containerImages[0]] = 20 + (levelGroup * 15);
        containerCounts[containerImages[1]] = 20 + (levelGroup * 15);
        containerCounts[containerImages[2]] = 20 + (levelGroup * 15);
        containerCounts[containerImages[3]] = 20 + (levelGroup * 15);
        containerCounts[containerImages[4]] = 10 + (levelGroup * 15);
        break;
      case 4:
        containerCounts[containerImages[0]] = 25 + (levelGroup * 15);
        containerCounts[containerImages[1]] = 25 + (levelGroup * 15);
        containerCounts[containerImages[2]] = 25 + (levelGroup * 15);
        containerCounts[containerImages[3]] = 30 + (levelGroup * 15);
        containerCounts[containerImages[4]] = 35 + (levelGroup * 15);
        break;
      case 5:
        containerCounts[containerImages[0]] = 40 + (levelGroup * 15);
        containerCounts[containerImages[1]] = 45 + (levelGroup * 15);
        containerCounts[containerImages[2]] = 40 + (levelGroup * 15);
        containerCounts[containerImages[3]] = 30 + (levelGroup * 15);
        containerCounts[containerImages[4]] = 35 + (levelGroup * 15);
        break;
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
            child: SvgPicture.asset(
              image,
              width: Get.width * 0.07,
              height: Get.width * 0.07,
            ),
          ),
        ),
        Positioned(
          bottom: -Get.width * 0.02,
          right: -Get.width * 0.02,
          child: containerCounts[image]! > 0
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
                    child: SvgPicture.asset(
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
              title: const StyledText(text: 'Game', fontSize: 42),
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
                  padding: EdgeInsets.fromLTRB(16, context.width * 0.2, 16, 16),
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
                                height: Get.height * 0.04,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.line,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Container(
                                    width: Get.width * 0.29,
                                    height: Get.height * 0.05,
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
                            ]),
                            Column(
                              children: [
                                const StyledText(text: 'Score', fontSize: 24),
                                Container(
                                  width: Get.width * 0.26,
                                  height: Get.height * 0.04,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.line,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: Get.width * 0.29,
                                      height: Get.height * 0.05,
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
                                  SvgPicture.asset(
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
                      controller.playSound(Sounds.refresh);
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
                      // controller.playSound(Sounds.pause);
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
          if (currentLevel.isComplete && currentLevel.allTargetsAchieved)
            LevelCard(
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
              onExit: () {
                setState(() {
                  Get.back();
                  resetContainers();
                });
              },
              remainingTime: currentLevel.finalTime,
              stars: calculateStars(currentLevel.remainingTime),
            ),
          if (currentLevel.isComplete && !currentLevel.allTargetsAchieved)
            IncompleteLevelCard(
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
            )
        ],
      ),
    );
  }

  Widget letsStart() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Container(
          color: AppTheme.blur.withOpacity(0.2),
          child: Center(child: StyledText(text: '${'go'.tr}!', fontSize: 64)),
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
                StyledText(text: 'pause'.tr, fontSize: 52),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // controller.playSound(Sounds.button);
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
                          child: SvgPicture.asset(AppImages.restart),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // controller.playSound(Sounds.button);

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
                          child: SvgPicture.asset(AppImages.resume),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // controller.playSound(Sounds.button);

                          currentLevel.isStopped = false;
                          currentLevel.isComplete = true;
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
                          child: SvgPicture.asset(
                            AppImages.exit,
                            height: 4,
                            // fit: BoxFit.fill,
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
      if (currentLevel.number % 5 == 4 || currentLevel.number % 5 == 0) {
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
      GameService.saveGameDetails();
      controller.saveGameState();
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
        if (containerCounts[nonWildSymbol] == 0 &&
            controller.game.value.isSoundOn) {
          // controller.playSound(Sounds.target);
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
          // controller.playSound(Sounds.clock);
        }
      } else {
        if (controller.game.value.isSoundOn) {
          // controller.playSound(Sounds.combo);
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
              color: Colors.green,
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
    final currentIndex = currentLevel.number;
    final nextLevel = currentLevel.number < 99
        ? controller.game.value.levels[currentIndex + 1]
        : null;
    if (currentLevel.number == 0) {
      return;
    }

    if (currentIndex % 5 == 4) {
      currentLevel.allTargetsAchieved =
          currentLevel.score >= currentLevel.points;
    } else if (currentIndex % 5 == 0) {
      currentLevel.allTargetsAchieved =
          currentLevel.score >= currentLevel.points &&
              containerCounts.values.every((count) => count == 0);
    } else {
      currentLevel.allTargetsAchieved =
          containerCounts.values.every((count) => count == 0);
    }

    if (currentLevel.allTargetsAchieved) {
      // controller.playSound(Sounds.levelComplete);

      if (countdownTimer != null) {
        countdownTimer?.cancel();
      }
      endGame(true);
      currentLevel.isComplete = true;
      if (nextLevel != null) {
        nextLevel.isLocked = false;
      }
    }
  }

//give yellow stars according to this logic
  int calculateStars(int remainingTime) {
    if (remainingTime > 30) {
      return 3;
    } else if (remainingTime <= 30 && remainingTime >= 20) {
      return 2;
    } else if (remainingTime > 0 && remainingTime < 20) {
      return 1;
    } else {
      return 0;
    }
  }

  void endGame(bool completed) async {
    setState(() {
      currentLevel.isComplete = true;
      currentLevel.allTargetsAchieved = completed;
      currentLevel.finalTime = currentLevel.remainingTime;

      int earnedStars =
          completed ? calculateStars(currentLevel.remainingTime) : 0;

      if (completed && earnedStars > currentLevel.stars) {
        currentLevel.stars = earnedStars;
        controller.onLevelCompleted(currentLevel);
      }

      // controller.playSound(Sounds.timeOver);
    });
  }

  void nextLevel() {
    final levels = controller.game.value.levels;
    final nextIndex = currentLevel.number + 1;
    if (currentLevel.number % 5 == 4 || currentLevel.number % 5 == 0) {
      currentLevel.resetScore();
    }

    if (nextIndex < levels.length) {
      Get.back();
      Get.to(() => GameMode(currentLevel: levels[nextIndex].copy()));
    }
  }

//change remaining time after every 5 levels
  int calculateTimeLimit(int level) {
    if (level == 0) return 120;

    int baseTime = 80;
    int groupNumber = (level - 1) ~/ 5;
    return baseTime + (groupNumber * 10);
  }

  //reduce time by 5 seconds when refresh button is clicked
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
