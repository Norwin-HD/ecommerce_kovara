import 'package:flutter/foundation.dart';

import 'models/cart_item.dart';

/// Estado del carrito de compras (provider).
class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Suma de unidades (para el badge de la navegación).
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Líneas distintas en el carrito.
  int get linesCount => _items.length;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Calcula el total aplicando el porcentaje de impuesto.
  double totalWithTax(double taxPercent) =>
      subtotal * (1 + taxPercent / 100);

  void add({
    required String productId,
    required String variantId,
    required String name,
    required String sku,
    required double unitPrice,
    String imageUrl = '',
    int quantity = 1,
  }) {
    final index = _items.indexWhere((item) => item.variantId == variantId);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          productId: productId,
          variantId: variantId,
          name: name,
          sku: sku,
          unitPrice: unitPrice,
          imageUrl: imageUrl,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void increment(String variantId) {
    final item = _item(variantId);
    if (item == null) return;
    item.quantity++;
    notifyListeners();
  }

  void decrement(String variantId) {
    final item = _item(variantId);
    if (item == null) return;
    if (item.quantity <= 1) {
      remove(variantId);
      return;
    }
    item.quantity--;
    notifyListeners();
  }

  void remove(String variantId) {
    _items.removeWhere((item) => item.variantId == variantId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  CartItem? _item(String variantId) {
    for (final item in _items) {
      if (item.variantId == variantId) return item;
    }
    return null;
  }
}
