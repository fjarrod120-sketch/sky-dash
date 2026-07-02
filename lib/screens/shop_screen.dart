import 'package:flutter/material.dart';
import '../economy/currency.dart';
import '../economy/shop_data.dart';
import '../skins/skin_manager.dart';
import '../utils/storage.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late PlayerEconomy _economy;
  @override
  void initState() { super.initState(); _economy = PlayerEconomy(); }

  @override
  Widget build(BuildContext context) {
    final owned = GameStorage().getOwnedSkins();
    final activeSkin = SkinManager().activeSkin;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        title: const Text('SKIN SHOP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: Row(children: [
          const Text('💎', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 4),
          Text('${_economy.gems}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
        ]))],
      ),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: ShopData.skins.length,
        itemBuilder: (context, index) {
          final skin = ShopData.skins[index];
          final isOwned = owned.contains(skin.id);
          final isActive = activeSkin == skin.id;
          return _SkinCard(skin: skin, isOwned: isOwned, isActive: isActive,
            canAfford: _economy.gems >= skin.gemCost, onTap: () => _handleSkinTap(skin, isOwned, isActive));
        },
      ),
    );
  }

  void _handleSkinTap(SkinData skin, bool isOwned, bool isActive) {
    if (isActive) return;
    if (isOwned) {
      SkinManager().setActiveSkin(skin.id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${skin.name} equipped!'), backgroundColor: const Color(0xFF6C63FF)));
    } else if (_economy.spendGems(skin.gemCost)) {
      GameStorage().addSkin(skin.id);
      SkinManager().setActiveSkin(skin.id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${skin.name} unlocked!'), backgroundColor: const Color(0xFF2ECC71)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough gems!'), backgroundColor: Color(0xFFE74C3C)));
    }
  }
}

class _SkinCard extends StatelessWidget {
  final SkinData skin; final bool isOwned; final bool isActive; final bool canAfford; final VoidCallback onTap;
  const _SkinCard({required this.skin, required this.isOwned, required this.isActive, required this.canAfford, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const tierColors = [Color(0xFF95A5A6), Color(0xFF2ECC71), Color(0xFF3498DB), Color(0xFF9B59B6), Color(0xFFFFD700)];
    const tierLabels = ['Common', 'Uncommon', 'Rare', 'Epic', 'Legendary'];
    final tier = skin.tier.clamp(0, 4);
    return Card(
      color: isActive ? const Color(0xFF2C3E50) : const Color(0xFF16213E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isActive ? const Color(0xFF6C63FF) : Colors.white12, width: isActive ? 2 : 1)),
      child: InkWell(borderRadius: BorderRadius.circular(16), onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Container(width: 64, height: 64,
            decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
            child: const Center(child: Text('👤', style: TextStyle(fontSize: 28)))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(skin.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(tierLabels[tier], style: TextStyle(fontSize: 12, color: tierColors[tier], fontWeight: FontWeight.w600)),
          ])),
          if (isActive)
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFF6C63FF), borderRadius: BorderRadius.circular(20)),
              child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))
          else if (isOwned)
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
              child: const Text('EQUIP', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)))
          else
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: canAfford ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C).withOpacity(0.5),
                borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('💎', style: TextStyle(fontSize: 14)), const SizedBox(width: 4),
                Text('${skin.gemCost}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ])),
        ]))),
    );
  }
}
