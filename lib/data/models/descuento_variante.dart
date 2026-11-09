import 'package:ecommerce_kovara/data/models/descuento_model.dart';
class DescuentoVariante {
  // ATRIBUTOS
  final int discountId;
  final String? variantId;
  final Descuento? descuento;

  // CONSTRUCTOR
  DescuentoVariante({
    required this.discountId,
    this.variantId,
    this.descuento,
  });

  // TOMA LOS VALORES OBTENIDOS DEL JSON Y LOS ASIGNA A LOS ATRIBUTOS DE LA CLASE
  factory DescuentoVariante.fromJson(Map<String, dynamic> json) {
    final nested = json['DESCUENTO']; // Accedemos al objeto anidado DESCUENTO
    final descuento = nested is Map // Verificamos si DESCUENTO es un Map antes de intentar convertirl
        ? Descuento.fromJson(Map<String, dynamic>.from(nested)) // Convertimos el Map a Descuento
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

  // OBTIENE EL DESCUENTO VIGENTE
  Descuento? get descuentoVigente {
    final d = descuento;
    if (d == null || !d.estaVigente()) return null;
    return d;
  }
}
