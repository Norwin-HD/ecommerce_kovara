import 'package:ecommerce_kovara/data/models/imagen_producto_model.dart';

class VarianteProducto {
  final String id;
  final String? productId;
  final String sku;
  final Map<String, dynamic> atributos; // El JSONB de la BD
  final double price;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ImagenProducto> imagenes;

  VarianteProducto({
    required this.id,
    this.productId,
    required this.sku,
    required this.atributos,
    required this.price,
    required this.createdAt,
    this.updatedAt,
    required this.imagenes,
  });

  factory VarianteProducto.fromJson(Map<String, dynamic> json) {
    return VarianteProducto(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      sku: json['sku'] as String,
      atributos: Map<String, dynamic>.from(json['atributtes'] as Map),
      // Parseo seguro de numeric (puede llegar como int o double desde el JSON)
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
        imagenes: json['IMAGEN_PRODUCTOS'] != null
          ? ((json['IMAGEN_PRODUCTOS'] as List)
            .map((i) => ImagenProducto.fromJson(i))
            .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)))
          : [],
    );
  }

  String get imagenPrincipalUrl {
    if (imagenes.isEmpty) return '';
    
    try {
      return imagenes.firstWhere((img) => img.isPrimary).imageUrl;
    } catch (e) {
      return imagenes.first.imageUrl;
    }
  }
}