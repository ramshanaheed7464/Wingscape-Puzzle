import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/style/theme.dart';

class CustomContainer extends StatelessWidget {
  final int number;

  const CustomContainer({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.07,
      height: Get.width * 0.07,
      decoration: BoxDecoration(
        color: AppTheme.pink,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.005),
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: Get.width * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
