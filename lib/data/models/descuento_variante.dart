import 'package:ecommerce_kovara/data/models/descuento_model.dart';

/// Registro de la tabla pivote DESCUENTO_VARIANTE
/// (discount_id → variant_id) con el descuento anidado.
class DescuentoVariante {
  final int discountId;
  final String? variantId;
  final Descuento? descuento;

  DescuentoVariante({
    required this.discountId,
    this.variantId,
    this.descuento,
  });

  /// Soporta:
  /// - Fila de la pivote: {discount_id, variant_id, DESCUENTO: {...}}
  /// - Embedded desde variante: {DESCUENTO: {...}}
  factory DescuentoVariante.fromJson(Map<String, dynamic> json) {
    final nested = json['DESCUENTO'];
    final descuento = nested is Map
        ? Descuento.fromJson(Map<String, dynamic>.from(nested))
        : null;

    return DescuentoVariante(
      discountId:
          (json['discount_id'] as num?)?.toInt() ?? descuento?.id ?? 0,
      variantId: json['variant_id'] as String?,
      descuento: descuento,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount_id': discountId,
      if (variantId != null) 'variant_id': variantId,
    };
  }

  /// Descuento vigente (si el anidado existe y está activo por fecha).
  Descuento? get descuentoVigente {
    final d = descuento;
    if (d == null || !d.estaVigente()) return null;
    return d;
  }
}
