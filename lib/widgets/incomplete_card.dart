import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/model/game_model.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';

class IncompleteLevelCard extends StatefulWidget {
  final Level currentLevel;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const IncompleteLevelCard({
    Key? key,
    required this.currentLevel,
    required this.onRestart,
    required this.onExit,
  }) : super(key: key);

  @override
  State<IncompleteLevelCard> createState() => _IncompleteLevelCardState();
}

class _IncompleteLevelCardState extends State<IncompleteLevelCard>
    with TickerProviderStateMixin {
  final GameStateController controller = Get.find();

  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _controller3 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Stack(
          children: [
            // Removed the unnecessary container wrapping the time and stars
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      // Time text displayed without a container background
                      Center(
                        child: Text(
                          '00:00',
                          style: AppTheme.textTheme.copyWith(
                            fontSize: 32,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      // Left star
                      Positioned(
                        left: Get.width * 0.2,
                        bottom: Get.width * 0.2,
                        child: ClipRRect(
                          child: SvgPicture.asset(
                            AppImages.whiteStar,
                            height: Get.height * 0.1,
                            width: Get.width * 0.17,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      // Right star
                      Positioned(
                        right: Get.width * 0.2,
                        bottom: Get.width * 0.2,
                        child: ClipRRect(
                          child: SvgPicture.asset(
                            AppImages.whiteStar,
                            height: Get.height * 0.1,
                            width: Get.width * 0.17,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      // Center star, larger and slightly higher
                      Positioned(
                        left: Get.width * 0.4,
                        right: Get.width * 0.4,
                        bottom: Get.width * 0.25,
                        child: ClipRRect(
                          child: SvgPicture.asset(
                            AppImages.whiteStar,
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
                      GestureDetector(
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
                      const SizedBox(width: 8),
                      GestureDetector(
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
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _controller1,
              builder: (context, child) {
                return Positioned(
                  left: context.width * 0.3,
                  top: context.width * 0.4 + 10 * sin(_controller1.value * 2 * pi),
                  child: ClipRRect(
                    child: Transform(
                      transform: Matrix4.rotationY(pi),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.5,
                        child: SvgPicture.asset(
                          AppImages.bibble,
                          height: context.width * 0.2,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: context.width * 0.12,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  AppImages.shell,
                  width: context.width * 0.4,
                  height: context.width * 0.6,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
