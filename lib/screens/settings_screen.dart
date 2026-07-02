import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'menu_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled; late bool _musicEnabled;
  @override
  void initState() { super.initState(); _soundEnabled = GameStorage().isSoundEnabled(); _musicEnabled = GameStorage().isMusicEnabled(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        title: const Text('SETTINGS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2))),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        _settingRow('🔊 Sound Effects', _soundEnabled, (val) { setState(() => _soundEnabled = val); GameStorage().setSoundEnabled(val); }),
        const Divider(color: Colors.white12),
        _settingRow('🎵 Music', _musicEnabled, (val) { setState(() => _musicEnabled = val); GameStorage().setMusicEnabled(val); }),
        const Divider(color: Colors.white12),
        const SizedBox(height: 40),
        Container(width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('STATISTICS', style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2)),
            const SizedBox(height: 16),
            _statRow('Games Played', '${GameStorage().getTotalGamesPlayed()}'),
            _statRow('Obstacles Dodged', '${GameStorage().getTotalObstaclesPassed()}'),
            _statRow('High Score', '${GameStorage().getHighScore()}'),
          ])),
        const SizedBox(height: 40),
        TextButton(onPressed: _confirmReset, child: const Text('Reset All Data', style: TextStyle(color: Color(0xFFE74C3C), fontSize: 16))),
      ])),
    );
  }

  Widget _settingRow(String label, bool value, ValueChanged<bool> onChanged) => Padding(padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
      Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFF6C63FF)),
    ]));

  Widget _statRow(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    ]));

  void _confirmReset() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text('Reset Data?', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      content: const Text('This will erase all gems, owned skins, and stats.', style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        TextButton(onPressed: () {
          Navigator.pop(ctx);
          GameStorage().setGems(0); GameStorage().setHighScore(0); GameStorage().addSkin('ninja_frog');
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MenuScreen()), (route) => false);
        }, child: const Text('Reset', style: TextStyle(color: Color(0xFFE74C3C)))),
      ],
    ));
  }
}
