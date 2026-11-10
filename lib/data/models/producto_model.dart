import 'package:ecommerce_kovara/data/models/categoria_model.dart';
import 'package:ecommerce_kovara/data/models/descuento_model.dart';
import 'package:ecommerce_kovara/data/models/variante_producto_model.dart';

class Producto {
  // MODELO PARA REPRESENTAR UN PRODUCTO
  final String id;
  final String name;
  final String slug;
  final String brandId;
  final String status;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<Categoria> categorias;
  final List<VarianteProducto> variantes;

 // CONSTRUCTOR
  Producto({
    required this.id,
    required this.name,
    required this.slug,
    required this.brandId,
    required this.status,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.categorias,
    required this.variantes,
  });
  
  // TOMA LOS VALORES OBTENIDOS DEL JSON Y LOS ASIGNA A LOS ATRIBUTOS DE LA CLASE
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      brandId: json['brand_id'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      categorias: json['CATEGORIAS'] != null
          ? (json['CATEGORIAS'] as List)
                .map((c) => Categoria.fromJson(c))
                .toList()
          : [],
      variantes: json['VARIANTE_PRODUCTOS'] != null
          ? (json['VARIANTE_PRODUCTOS'] as List)
                // Filtramos internamente las eliminadas (por si acaso)
                .where((v) => v['deleted_at'] == null)
                .map((v) => VarianteProducto.fromJson(v))
                .toList()
          : [],
    );
  }

  /// ELEGIR EL MEJOR DESCUENTO DE TODAS LAS VARIANTES DEL PRODUCTO
  Descuento? get descuentoActivo {
    Descuento? mejor;
    for (final v in variantes) {
      final d = v.descuentoActivo;
      if (d == null) continue;
      if (mejor == null || d.porcentageDiscount > mejor.porcentageDiscount) {
        mejor = d;
      }
    }
    return mejor;
  }

  bool get tieneDescuento => descuentoActivo != null;

  // CALCULA EL PRECIO FINAL DEL PRODUCTO, TOMANDO EN CUENTA EL DESCUENTO ACTIVO SI EXISTE
  double precioFinal(double precioBase) {
    final d = descuentoActivo;
    return d == null ? precioBase : d.aplicarA(precioBase);
  }

  // OBTENER LA VARIANTE MAS BARATA DEL PRODUCTO
  VarianteProducto? get varianteMasBarata {
    if (variantes.isEmpty) return null;
    return variantes.reduce((a, b) {
      final pa = a.precioFinal();
      final pb = b.precioFinal();
      return pb < pa ? b : a;
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'brand_id': brandId,
      'status': status,
      'description': description,
    };
  }
}
