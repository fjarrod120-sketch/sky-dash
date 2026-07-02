import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPManager {
  static final IAPManager _instance = IAPManager._();
  factory IAPManager() => _instance;
  IAPManager._();

  final InAppPurchase _purchase = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  bool _isPurchasing = false;

  static const List<String> _productIds = [
    'coin_pack_small',
    'coin_pack_medium',
    'coin_pack_large',
    'coin_pack_mega',
  ];

  static const Map<String, int> _gemRewards = {
    'coin_pack_small': 500,
    'coin_pack_medium': 1750,
    'coin_pack_large': 4900,
    'coin_pack_mega': 12800,
  };

  bool get available => _available;
  bool get isPurchasing => _isPurchasing;
  List<ProductDetails> get products => _products;

  Future<void> init() async {
    _available = await _purchase.isAvailable();
    if (!_available) return;
    final response = await _purchase.queryProductDetails(_productIds.toSet());
    _products = response.productDetails;
    _purchase.purchaseStream.listen(_handlePurchaseUpdate);
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _isPurchasing = false;
        final gems = _gemRewards[purchase.productID] ?? 0;
        if (gems > 0) {
          _onPurchaseComplete?.call(purchase.productID, gems);
        }
        if (purchase.pendingCompletePurchase) {
          _purchase.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        _isPurchasing = false;
        _onPurchaseError?.call(purchase.error?.message ?? 'Unknown error');
      } else if (purchase.status == PurchaseStatus.canceled) {
        _isPurchasing = false;
      }
    }
  }

  Future<bool> buyProduct(String productId) async {
    if (!_available || _isPurchasing) return false;
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => _products.first,
    );
    final purchaseParam = PurchaseParam(productDetails: product);
    _isPurchasing = true;
    try {
      await _purchase.buyConsumable(purchaseParam: purchaseParam);
      return true;
    } catch (e) {
      _isPurchasing = false;
      return false;
    }
  }

  Function(String productId, int gems)? _onPurchaseComplete;
  Function(String error)? _onPurchaseError;
  void set onPurchaseComplete(void Function(String productId, int gems)? cb) => _onPurchaseComplete = cb;
  void set onPurchaseError(void Function(String error)? cb) => _onPurchaseError = cb;

  Future<void> restorePurchases() async {
    if (!_available) return;
    await _purchase.restorePurchases();
  }

  void dispose() { _products = []; }
}
