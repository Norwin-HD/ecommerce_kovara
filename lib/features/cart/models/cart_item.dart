/// Línea del carrito: una variante de producto con su cantidad.
class CartItem {
  CartItem({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.sku,
    required this.unitPrice,
    this.imageUrl = '',
    this.quantity = 1,
  });

  final String productId;
  final String variantId;
  final String name;
  final String sku;
  final double unitPrice;
  final String imageUrl;
  int quantity;

  double get lineTotal => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'variantId': variantId,
        'name': name,
        'sku': sku,
        'unitPrice': unitPrice,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };
}
