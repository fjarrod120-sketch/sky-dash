import '../utils/storage.dart';

class SkinManager {
  static final SkinManager _instance = SkinManager._();
  factory SkinManager() => _instance;
  SkinManager._();
  final GameStorage _storage = GameStorage();
  String get activeSkin => _storage.getActiveSkin();
  void setActiveSkin(String skinId) => _storage.setActiveSkin(skinId);
  String getPlayerSpritePath(String skinId) => 'assets/images/characters/$skinId/player.png';
  String getBackgroundTheme(String skinId) {
    final themes = {
      'ninja_frog': 'city_night', 'pixel_cat': 'rainbow', 'space_dino': 'neon_grid',
      'neon_samurai': 'cyberpunk', 'galaxy_bot': 'space', 'rainbow_dragon': 'fantasy',
      'void_knight': 'dark_castle', 'golden_phoenix': 'sunset', 'dark_matter': 'void',
    };
    return themes[skinId] ?? 'city_night';
  }
}
