import 'package:flutter/foundation.dart';
import 'package:flame_audio/flame_audio.dart';
import '../utils/storage.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;
  SoundManager._();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await FlameAudio.audioCache.loadAll([
        'sfx/jump.wav', 'sfx/coin.wav', 'sfx/crash.wav',
        'sfx/ui_tap.wav', 'sfx/game_over.wav', 'sfx/level_up.wav', 'music/bgm_loop.wav',
      ]);
      _initialized = true;
    } catch (e) {
      debugPrint('SoundManager: Audio init skipped: $e');
    }
  }

  bool get isSoundEnabled => GameStorage().isSoundEnabled();
  bool get isMusicEnabled => GameStorage().isMusicEnabled();

  void playSfx(String name) {
    if (!isSoundEnabled || !_initialized) return;
    try { FlameAudio.play('sfx/$name'); } catch (_) {}
  }

  void playMusic() {
    if (!isMusicEnabled || !_initialized) return;
    try { FlameAudio.bgm().play('music/bgm_loop.wav'); } catch (_) {}
  }

  void pauseMusic() { try { FlameAudio.bgm().pause(); } catch (_) {} }
  void stopMusic() { try { FlameAudio.bgm().stop(); } catch (_) {} }
  void playJump() => playSfx('jump.wav');
  void playCoin() => playSfx('coin.wav');
  void playCrash() => playSfx('crash.wav');
  void playTap() => playSfx('ui_tap.wav');
  void playGameOver() => playSfx('game_over.wav');
  void playLevelUp() => playSfx('level_up.wav');
}
