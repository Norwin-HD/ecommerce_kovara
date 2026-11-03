class ImagenProducto {
  final String id;
  final String productId;
  final String variantId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;

  ImagenProducto({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory ImagenProducto.fromJson(Map<String, dynamic> json) {
    return ImagenProducto(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String,
      imageUrl: json['image_url'] as String,
      isPrimary: json['is_primary'] as bool? ?? false, 
      sortOrder: json['sort_order'] as int,
    );
  }
}