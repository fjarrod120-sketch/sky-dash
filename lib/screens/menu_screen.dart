import 'package:flutter/material.dart';
import '../economy/currency.dart';
import 'game_screen.dart';
import 'shop_screen.dart';
import 'settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gems = PlayerEconomy().gems;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('SKY DASH', style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 6)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
            child: const Text('DODGE THE SKY', style: TextStyle(fontSize: 14, color: Colors.white38, letterSpacing: 4))),
          const SizedBox(height: 60),
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('💎', style: TextStyle(fontSize: 28)), const SizedBox(width: 8),
              Text('$gems', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
            ])),
          const SizedBox(height: 40),
          _menuButton('▶  PLAY', const Color(0xFF6C63FF), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()))),
          const SizedBox(height: 16),
          _menuButton('👤  SKINS', const Color(0xFF9B59B6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()))),
          const SizedBox(height: 16),
          _menuButton('⚙  SETTINGS', Colors.white24, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
        ],
      ))),
    );
  }

  Widget _menuButton(BuildContext context, String label, Color color, VoidCallback onTap) => SizedBox(width: 280, child: ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 4),
    child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
  ));
}
