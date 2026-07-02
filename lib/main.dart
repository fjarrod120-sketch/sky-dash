import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'economy/ads_manager.dart';
import 'economy/iap_manager.dart';
import 'economy/currency.dart';
import 'screens/menu_screen.dart';
import 'utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await GameStorage().init();
  PlayerEconomy();
  await AdsManager().init();
  AdsManager().preload();
  await IAPManager().init();
  runApp(const SkyDashApp());
}

class SkyDashApp extends StatelessWidget {
  const SkyDashApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Dash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        fontFamily: 'monospace',
      ),
      home: const MenuScreen(),
    );
  }
}
