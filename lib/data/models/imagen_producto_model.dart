// MODELO PIVOTE PARA LAS IMAGENES DE LOS PRODUCTOS
class ImagenProducto {
  final String id;
  final String productId;
  final String variantId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;
  
  // CONSTRUCTOR
  ImagenProducto({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });
  
  // TOMA LOS VALORES OBTENIDOS DEL JSON Y LOS ASIGNA A LOS ATRIBUTOS DE LA CLASE
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