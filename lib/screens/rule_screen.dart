import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';
import 'package:wingscape_puzzle/widgets/text_widget.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RuleScreen extends StatefulWidget {
  const RuleScreen({super.key});

  @override
  State<RuleScreen> createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  final gameStateController = Get.find<GameStateController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: StyledText(text: 'rules'.tr, fontSize: 32),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            gameStateController.playSound(Sounds.button);
            Get.back();
          },
          child: Container(
              margin: const EdgeInsets.fromLTRB(8, 2, 0, 2),
              width: screenWidth * 0.03,
              height: screenHeight * 0.03,
              decoration: BoxDecoration(
                  gradient: AppTheme.purpleGradient,
                  border: Border.all(color: AppTheme.purpleBorder, width: 3),
                  borderRadius: BorderRadius.circular(12)),
              child: Image.asset(AppImages.back)),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.background,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      't1'.tr,
                      style: AppTheme.textTheme,
                    ),
                    Text(
                      't2'.tr,
                      style: AppTheme.textTheme,
                    ),
                    Text(
                      't3'.tr,
                      style: AppTheme.textTheme,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      't4'.tr,
                      style: AppTheme.textTheme,
                    ),
                    Text(
                      't5'.tr,
                      style: AppTheme.textTheme,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
