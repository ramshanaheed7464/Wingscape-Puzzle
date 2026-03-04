import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingscape_puzzle/bindings/app_binding.dart';
import 'package:wingscape_puzzle/screens/menu_screen.dart';
import 'package:wingscape_puzzle/services/game_repository.dart';
import 'package:wingscape_puzzle/services/game_service.dart';
import 'package:wingscape_puzzle/services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => Storage().init());
  await Get.putAsync<GameRepository>(() async => GameService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wingscape Puzzle',
      home: MenuScreen(),
      initialBinding: AppBinding(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
    );
  }
}
