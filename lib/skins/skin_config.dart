class SkinConfig {
  final String id; final String displayName; final String spritePath; final String bgTheme; final int color;
  const SkinConfig({required this.id, required this.displayName, required this.spritePath, required this.bgTheme, required this.color});
}

class SkinConfigs {
  static const List<SkinConfig> all = [
    SkinConfig(id: 'ninja_frog', displayName: 'Ninja Frog', spritePath: 'assets/images/characters/ninja_frog/player.png', bgTheme: 'city_night', color: 0xFF2ECC71),
    SkinConfig(id: 'pixel_cat', displayName: 'Pixel Cat', spritePath: 'assets/images/characters/pixel_cat/player.png', bgTheme: 'rainbow', color: 0xFFE67E22),
    SkinConfig(id: 'space_dino', displayName: 'Space Dino', spritePath: 'assets/images/characters/space_dino/player.png', bgTheme: 'neon_grid', color: 0xFF3498DB),
    SkinConfig(id: 'neon_samurai', displayName: 'Neon Samurai', spritePath: 'assets/images/characters/neon_samurai/player.png', bgTheme: 'cyberpunk', color: 0xFF9B59B6),
    SkinConfig(id: 'galaxy_bot', displayName: 'Galaxy Bot', spritePath: 'assets/images/characters/galaxy_bot/player.png', bgTheme: 'space', color: 0xFF1ABC9C),
    SkinConfig(id: 'rainbow_dragon', displayName: 'Rainbow Dragon', spritePath: 'assets/images/characters/rainbow_dragon/player.png', bgTheme: 'fantasy', color: 0xFFE74C3C),
    SkinConfig(id: 'void_knight', displayName: 'Void Knight', spritePath: 'assets/images/characters/void_knight/player.png', bgTheme: 'dark_castle', color: 0xFF2C3E50),
    SkinConfig(id: 'golden_phoenix', displayName: 'Golden Phoenix', spritePath: 'assets/images/characters/golden_phoenix/player.png', bgTheme: 'sunset', color: 0xFFFFD700),
    SkinConfig(id: 'dark_matter', displayName: 'Dark Matter', spritePath: 'assets/images/characters/dark_matter/player.png', bgTheme: 'void', color: 0xFF8E44AD),
  ];
}
