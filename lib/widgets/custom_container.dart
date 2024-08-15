import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/style/theme.dart';

class CustomContainer extends StatelessWidget {
  final int number;

  const CustomContainer({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.06,
      height: Get.height * 0.05,
      decoration: const BoxDecoration(
        color: AppTheme.peach,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: AppTheme.textTheme,
        ),
      ),
    );
  }
}
