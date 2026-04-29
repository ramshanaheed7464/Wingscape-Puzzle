import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';

class LevelCard extends StatefulWidget {
  final Level currentLevel;
  final VoidCallback onPlay;
  final VoidCallback onRestart;
  final VoidCallback onExit;
  final int remainingTime;
  final int stars;

  const LevelCard({
    Key? key,
    required this.currentLevel,
    required this.onPlay,
    required this.onRestart,
    required this.onExit,
    required this.remainingTime,
    required this.stars,
  }) : super(key: key);

  @override
  LevelCardState createState() => LevelCardState();
}

class LevelCardState extends State<LevelCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Tween to animate between 0.5 (dim) and 1.0 (full glow).
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameStateController controller = Get.find();
    final minutes = widget.remainingTime ~/ 60;
    final seconds = widget.remainingTime % 60;

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Stack(
          children: [
            Positioned(
              child: FadeTransition(
                opacity: _glowAnimation,
                child: SvgPicture.asset(
                  AppImages.sparkle,
                  height: Get.height,
                  width: Get.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              color: AppTheme.blur.withValues(alpha: 0.2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.passthrough,
                      children: [
                        Positioned(
                          child: Container(
                            width: Get.width * 0.36,
                            height: Get.height * 0.17,
                            decoration: BoxDecoration(
                              gradient: AppTheme.pinkGradient,
                              border: Border.all(
                                color: AppTheme.pinkBorder,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '$formattedMinutes:$formattedSeconds',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppTheme.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20,
                          bottom: 90,
                          child: ClipRRect(
                            child: SvgPicture.asset(
                              widget.stars >= 1
                                  ? AppImages.pinkStar
                                  : AppImages.whiteStar,
                              height: Get.height * 0.1,
                              width: Get.width * 0.17,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -20,
                          bottom: 90,
                          child: ClipRRect(
                            child: SvgPicture.asset(
                              widget.stars >= 3
                                  ? AppImages.pinkStar
                                  : AppImages.whiteStar,
                              height: Get.height * 0.1,
                              width: Get.width * 0.17,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          right: 25,
                          bottom: 100,
                          child: ClipRRect(
                            child: SvgPicture.asset(
                              widget.stars >= 2
                                  ? AppImages.pinkStar
                                  : AppImages.whiteStar,
                              height: Get.height * 0.13,
                              width: Get.width * 0.15,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              controller.playSound(Sounds.button);
                              widget.onPlay();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                border: Border.all(
                                  color: AppTheme.purpleBorder,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(AppImages.next),
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
                              widget.onRestart();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                border: Border.all(
                                  color: AppTheme.purpleBorder,
                                  width: 3,
                                ),
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
                              widget.onExit();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                border: Border.all(
                                  color: AppTheme.purpleBorder,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(AppImages.exit),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
