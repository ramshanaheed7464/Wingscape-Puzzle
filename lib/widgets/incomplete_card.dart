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
    final w = Get.width;
    final btnSize = w * 0.12;
    final btnPad = w * 0.025;

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      Center(
                        child: Text(
                          '00:00',
                          style: AppTheme.textTheme.copyWith(
                            fontSize: w * 0.08,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Positioned(
                        left: w * 0.2,
                        bottom: w * 0.2,
                        child: ClipRRect(
                          child: SvgPicture.asset(
                            AppImages.whiteStar,
                            height: Get.height * 0.1,
                            width: w * 0.17,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        right: w * 0.2,
                        bottom: w * 0.2,
                        child: ClipRRect(
                          child: SvgPicture.asset(
                            AppImages.whiteStar,
                            height: Get.height * 0.1,
                            width: w * 0.17,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        left: w * 0.4,
                        right: w * 0.4,
                        bottom: w * 0.25,
                        child: ClipRRect(
                          child: SvgPicture.asset(
                            AppImages.whiteStar,
                            height: Get.height * 0.13,
                            width: w * 0.15,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.playSound(Sounds.button);
                          widget.onRestart();
                        },
                        child: Container(
                          width: btnSize,
                          height: btnSize,
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            border: Border.all(
                              color: AppTheme.purpleBorder,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(btnPad),
                            child: SvgPicture.asset(AppImages.restart),
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      GestureDetector(
                        onTap: () {
                          controller.playSound(Sounds.button);
                          widget.onExit();
                        },
                        child: Container(
                          width: btnSize,
                          height: btnSize,
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            border: Border.all(
                              color: AppTheme.purpleBorder,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(btnPad),
                            child: SvgPicture.asset(AppImages.exit),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.04),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _controller1,
              builder: (context, child) {
                return Positioned(
                  left: w * 0.3,
                  top: w * 0.4 + 10 * sin(_controller1.value * 2 * pi),
                  child: ClipRRect(
                    child: Transform(
                      transform: Matrix4.rotationY(pi),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.5,
                        child: SvgPicture.asset(
                          AppImages.bibble,
                          height: w * 0.2,
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
              left: w * 0.12,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  AppImages.shell,
                  width: w * 0.4,
                  height: w * 0.6,
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
