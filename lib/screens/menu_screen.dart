import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/screens/game_levels.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/widgets/text_widget.dart';
import '../utils/sounds.dart';
import 'rule_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final GameStateController controller = Get.find<GameStateController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GetBuilder<GameStateController>(
        builder: (_) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.background,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: width * 0.05,
                right: width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    controller.playSound(Sounds.button);
                    _showSettingsDialog(context);
                  },
                  child: Container(
                    height: width * 0.15,
                    width: context.width * 0.15,
                    decoration: BoxDecoration(
                      gradient: AppTheme.pinkGradient,
                      border: Border.all(color: AppTheme.pinkBorder, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.settings,
                        fit: BoxFit.fill,
                        height: context.width * 0.075,
                      ),
                    ),
                  ),
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
                          width: width * 0.28,
                          height: width * 0.2,
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
                              '${controller.game.value.totalStars}',
                              style: AppTheme.textTheme.copyWith(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -width * 0.02,
                        top: -width * 0.05,
                        child: SvgPicture.asset(AppImages.pinkStar,
                            height: width * 0.13,
                            width: width * 0.13,
                            fit: BoxFit.contain),
                      ),
                      Positioned(
                        right: -width * 0.02,
                        top: -width * 0.05,
                        child: SvgPicture.asset(AppImages.pinkStar,
                            height: width * 0.13,
                            width: width * 0.13,
                            fit: BoxFit.contain),
                      ),
                      Positioned(
                        right: width * 0.04,
                        top: -width * 0.13,
                        child: SvgPicture.asset(AppImages.pinkStar,
                            height: width * 0.2,
                            width: width * 0.2,
                            fit: BoxFit.contain),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: width * 0.08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.playSound(Sounds.button);
                              Get.to(() => const GameLevels());
                            },
                            child: Container(
                              width: width * 0.18,
                              height: width * 0.18,
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                border: Border.all(
                                  color: AppTheme.purpleBorder,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                                  child: SvgPicture.asset(AppImages.play),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const StyledText(text: 'Play', fontSize: 42)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
  void _showSettingsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Center(
          child: Text(
            'Settings',
            style: AppTheme.textTheme.copyWith(color: Colors.black),
          ),
        ),
        content: GetBuilder<GameStateController>(
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    controller.game.value.isSoundOn
                        ? AppImages.soundOn
                        : AppImages.soundOff,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    'Sound',
                    style: AppTheme.textTheme.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    controller.playSound(Sounds.button);
                    controller.toggleSound();
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    controller.game.value.isMusicOn
                        ? AppImages.musicOn
                        : AppImages.musicOff,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    'Music',
                    style: AppTheme.textTheme.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    controller.toggleMusic();
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(AppImages.rules, width: 24, height: 24),
                  title: Text(
                    'Rules',
                    style: AppTheme.textTheme.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    controller.playSound(Sounds.button);
                    Get.to(() => const RuleScreen());
                  },
                ),
                ListTile(
                  leading:
                  SvgPicture.asset(AppImages.tutorial, width: 24, height: 24),
                  title: Text(
                    'Tutorial',
                    style: AppTheme.textTheme.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    controller.playSound(Sounds.button);
                    Get.back();
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Close',
              style: AppTheme.textTheme.copyWith(color: Colors.pink),
            ),
            onPressed: () {
              controller.playSound(Sounds.button);
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
