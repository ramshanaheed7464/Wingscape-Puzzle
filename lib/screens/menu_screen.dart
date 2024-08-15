import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/screens/game_levels.dart';
import 'package:wingscape_puzzle/services/game_service.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/widgets/text_widget.dart';
import 'rule_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final GameStateController controller = Get.put(GameStateController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<GameStateController>(
        init: GameStateController(),
        builder: (_) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.background,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      Positioned(
                        child: Container(
                          width: screenWidth * 0.28,
                          height: screenHeight * 0.1,
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
                              '${GameService.game.value.totalStars}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -screenWidth * 0.02,
                        top: -screenWidth * 0.05,
                        child: ClipRRect(
                          child: Image.asset(AppImages.pinkStar,
                              height: screenWidth * 0.13,
                              width: screenWidth * 0.13,
                              fit: BoxFit.fill),
                        ),
                      ),
                      Positioned(
                        right: -screenWidth * 0.02,
                        top: -screenWidth * 0.05,
                        child: ClipRRect(
                          child: Image.asset(AppImages.pinkStar,
                              height: screenWidth * 0.13,
                              width: screenWidth * 0.13,
                              fit: BoxFit.fill),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                        top: -screenWidth * 0.13,
                        child: ClipRRect(
                          child: Image.asset(AppImages.pinkStar,
                              height: screenWidth * 0.2,
                              width: screenWidth * 0.2,
                              fit: BoxFit.fill),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (GameService.game.value.isSoundOn) {
                                controller.playSound(Sounds.button);
                              }
                              Get.to(() => const GameLevels());
                            },
                            child: Container(
                              width: screenWidth * 0.16,
                              height: screenWidth * 0.16,
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                border: Border.all(
                                    color: AppTheme.purpleBorder, width: 3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Image.asset(AppImages.play)),
                            ),
                          ),
                          const StyledText(text: 'Play', fontSize: 32)
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (GameService.game.value.isSoundOn) {
                                controller.playSound(Sounds.button);
                              }
                              Get.to(() => const RuleScreen());
                            },
                            child: Container(
                              width: screenWidth * 0.16,
                              height: screenWidth * 0.16,
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                border: Border.all(
                                    color: AppTheme.purpleBorder, width: 3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                                  Center(child: Image.asset(AppImages.rules)),
                            ),
                          ),
                          const StyledText(text: 'Rules', fontSize: 32)
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Positioned(
                left: screenWidth * 0.25,
                bottom: screenWidth * 0.01,
                child: Column(
                  children: [
                    Text(
                      'sound'.tr,
                      style: AppTheme.textTheme.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            GameService.game.value.isSoundOn =
                                !GameService.game.value.isSoundOn;
                          });
                        },
                        child: Image.asset(
                          GameService.game.value.isSoundOn
                              ? AppImages.soundOn
                              : AppImages.soundOff,
                          width: screenWidth * 0.3,
                          fit: BoxFit.fill,
                        )),
                    Text(
                      GameService.game.value.isSoundOn ? 'On' : 'Off',
                      style: AppTheme.textTheme,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: screenWidth * 0.25,
                bottom: screenWidth * 0.01,
                child: Column(
                  children: [
                    Text(
                      'music'.tr,
                      style: AppTheme.textTheme.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                        onTap: () {
                          controller.toggleMusic();
                        },
                        child: Image.asset(
                          GameService.game.value.isMusicOn
                              ? AppImages.musicOn
                              : AppImages.musicOff,
                          width: screenWidth * 0.3,
                          fit: BoxFit.fill,
                        )),
                    Obx(
                      () => Text(
                        GameService.game.value.isMusicOn ? 'On' : 'Off',
                        style: AppTheme.textTheme,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
