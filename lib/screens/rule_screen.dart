import 'package:flutter_svg/flutter_svg.dart';
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
  final controller = Get.find<GameStateController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const StyledText(text: 'Rules', fontSize: 44),
        centerTitle: true,
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    style: AppTheme.textTheme,
                    children: [
                      TextSpan(
                          text: 'Combo Symbol:\n',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                      const TextSpan(
                          text:
                              'The Combo Symbol is uniquely versatile, allowing it to match with any other symbol on the board. When combined with another symbol, it takes on that symbol\'s properties, enabling successful matches.\n\n'),
                      TextSpan(
                          text: 'Clock Symbol:\n',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                      const TextSpan(
                          text:
                              'The Clock Symbol provides additional time when matched, helping to extend the game duration. Use this symbol strategically to increase your available time and boost your score.\n\n'),
                      TextSpan(
                          text: 'Standard Symbols:\n',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                      const TextSpan(
                          text:
                              'Standard symbols can only be matched with identical symbols. These symbols cannot be combined with different types, except when paired with the Combo Symbol.\n\n'),
                      TextSpan(
                          text: 'Line Matching:\n',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                      const TextSpan(
                          text:
                              'Instead of swapping symbols, players draw lines to connect and match them. Create matches by drawing a continuous line that links at least three identical symbols. Matches can form in straight lines, L-shapes, or other connected patterns, as long as the line remains unbroken.\n\n'),
                      TextSpan(
                          text: 'Targets and Time Management:\n',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                      const TextSpan(
                          text:
                              'Each level has specific targets that must be completed within a time limit. The game concludes when the timer runs out, so focus on achieving your targets quickly and efficiently. Matching the Clock Symbol can extend your time, giving you a better chance to meet your goals.\n\n'),
                      TextSpan(
                          text: 'Scoring:\n',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                      const TextSpan(
                          text:
                              'Higher scores are earned by creating longer chains of symbols in a single move.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
