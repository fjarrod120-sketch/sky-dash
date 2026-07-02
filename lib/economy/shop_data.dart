class SkinData {
  final String id;
  final String name;
  final int tier;
  final int gemCost;
  const SkinData({required this.id, required this.name, required this.tier, required this.gemCost});
}

class ShopData {
  static const List<SkinData> skins = [
    SkinData(id: 'ninja_frog', name: 'Ninja Frog', tier: 0, gemCost: 0),
    SkinData(id: 'pixel_cat', name: 'Pixel Cat', tier: 1, gemCost: 500),
    SkinData(id: 'space_dino', name: 'Space Dino', tier: 1, gemCost: 500),
    SkinData(id: 'neon_samurai', name: 'Neon Samurai', tier: 2, gemCost: 2000),
    SkinData(id: 'galaxy_bot', name: 'Galaxy Bot', tier: 2, gemCost: 2500),
    SkinData(id: 'rainbow_dragon', name: 'Rainbow Dragon', tier: 3, gemCost: 8000),
    SkinData(id: 'void_knight', name: 'Void Knight', tier: 3, gemCost: 10000),
    SkinData(id: 'golden_phoenix', name: 'Golden Phoenix', tier: 4, gemCost: 25000),
    SkinData(id: 'dark_matter', name: 'Dark Matter', tier: 4, gemCost: 35000),
  ];
  static SkinData? getSkin(String id) {
    try { return skins.firstWhere((s) => s.id == id); } catch (_) { return null; }
  }
}
