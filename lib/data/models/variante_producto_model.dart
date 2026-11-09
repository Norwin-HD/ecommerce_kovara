import 'package:ecommerce_kovara/data/models/descuento_model.dart';
import 'package:ecommerce_kovara/data/models/descuento_variante.dart';
import 'package:ecommerce_kovara/data/models/imagen_producto_model.dart';

class VarianteProducto {
  // MODELO PARA REPRESENTAR UNA VARIANTE DE UN PRODUCTO
  final String id;
  final String? productId;
  final String sku;
  final Map<String, dynamic> atributos; // El JSONB de la BD
  final double price;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ImagenProducto> imagenes;
  final List<DescuentoVariante> descuentosVariante;

  // CONSTRUCTOR 
  VarianteProducto({
    required this.id,
    this.productId,
    required this.sku,
    required this.atributos,
    required this.price,
    required this.createdAt,
    this.updatedAt,
    required this.imagenes,
    this.descuentosVariante = const [],
  });

  factory VarianteProducto.fromJson(Map<String, dynamic> json) {
    return VarianteProducto(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      sku: json['sku'] as String,
      atributos: Map<String, dynamic>.from(json['atributtes'] as Map),
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
      descuentosVariante: _parseDescuentosVariante(json['DESCUENTO_VARIANTE']),
    );
  }

  static List<DescuentoVariante> _parseDescuentosVariante(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => DescuentoVariante.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // OBTENER LA IMAGEN PRINCIPAL DE LA VARIANTE, EN CASO DE NO EXISTIR, SE TOMA LA PRIMERA IMAGEN DISPONIBLE
  String get imagenPrincipalUrl {
    if (imagenes.isEmpty) return '';

    try {
      return imagenes.firstWhere((img) => img.isPrimary).imageUrl;
    } catch (e) {
      return imagenes.first.imageUrl;
    }
  }

  // ELEGIR EL MEJOR DESCUENTO DE TODAS LAS VARIANTES DEL PRODUCTO
  Descuento? get descuentoActivo {
    Descuento? mejor;
    for (final dv in descuentosVariante) {
      final d = dv.descuentoVigente;
      if (d == null) continue;
      if (mejor == null || d.porcentageDiscount > mejor.porcentageDiscount) {
        mejor = d;
      }
    }
    return mejor;
  }

  bool get tieneDescuento => descuentoActivo != null;

  // CALCULA EL PRECIO FINAL DE LA VARIANTE, TOMANDO EN CUENTA EL DESCUENTO ACTIVO SI EXISTE
  double precioFinal([double? precioBase]) {
    final base = precioBase ?? price;
    final d = descuentoActivo;
    return d == null ? base : d.aplicarA(base);
  }
}
