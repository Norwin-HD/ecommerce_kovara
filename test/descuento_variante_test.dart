import 'package:ecommerce_kovara/data/models/descuento_variante.dart';
import 'package:ecommerce_kovara/data/models/producto_model.dart';
import 'package:ecommerce_kovara/data/models/variante_producto_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DescuentoVariante', () {
    test('parsea embedded desde DESCUENTO_VARIANTE(DESCUENTO(*))', () {
      final json = {
        'DESCUENTO': {
          'id': 1,
          'name': 'DESCUENTO FLASH',
          'date_init': '2026-09-14',
          'date_expiration': '2026-12-09',
          'porcentage_discount': 20,
          'created_at': '2026-09-15T02:16:14.631251+00:00',
        },
      };

      final dv = DescuentoVariante.fromJson(json);

      expect(dv.discountId, 1);
      expect(dv.descuento, isNotNull);
      expect(dv.descuento!.porcentageDiscount, 20);
      expect(dv.descuentoVigente, isNotNull);
    });

    test('descuentoVigente es null si está fuera de rango', () {
      final json = {
        'discount_id': 2,
        'variant_id': 'abc',
        'DESCUENTO': {
          'id': 2,
          'name': 'Vencido',
          'date_init': '2020-01-01',
          'date_expiration': '2020-12-31',
          'porcentage_discount': 50,
          'created_at': '2020-01-01T00:00:00+00:00',
        },
      };

      final dv = DescuentoVariante.fromJson(json);

      expect(dv.discountId, 2);
      expect(dv.variantId, 'abc');
      expect(dv.descuentoVigente, isNull);
    });
  });

  group('VarianteProducto con descuento', () {
    test('parsea DESCUENTO_VARIANTE y aplica precio final', () {
      final json = {
        'id': '3d4e5d30-b55a-42ee-aa2d-1026e7d46049',
        'product_id': '938c1793-2d69-4af9-b17f-a9676f23bad5',
        'sku': 'dell-inspiron-standard',
        'atributtes': {'RAM': '8GB'},
        'price': 25637,
        'created_at': '2026-09-15T02:15:02.062693+00:00',
        'updated_at': null,
        'IMAGEN_PRODUCTOS': <dynamic>[],
        'DESCUENTO_VARIANTE': [
          {
            'discount_id': 1,
            'variant_id': '3d4e5d30-b55a-42ee-aa2d-1026e7d46049',
            'DESCUENTO': {
              'id': 1,
              'name': 'DESCUENTO FLASH',
              'date_init': '2026-09-14',
              'date_expiration': '2026-12-09',
              'porcentage_discount': 20,
              'created_at': '2026-09-15T02:16:14.631251+00:00',
            },
          },
        ],
      };

      final v = VarianteProducto.fromJson(json);

      expect(v.tieneDescuento, isTrue);
      expect(v.descuentoActivo!.porcentageDiscount, 20);
      expect(v.precioFinal(), closeTo(25637 * 0.8, 0.001));
    });

    test('variante sin descuento mantiene precio', () {
      final json = {
        'id': '8b07b56e-3866-47ef-a7da-9aa5f442a41a',
        'sku': 'mouse-dell-standard',
        'atributtes': <String, dynamic>{},
        'price': 366.24,
        'created_at': '2026-09-21T18:10:51.768754+00:00',
        'IMAGEN_PRODUCTOS': <dynamic>[],
        'DESCUENTO_VARIANTE': <dynamic>[],
      };

      final v = VarianteProducto.fromJson(json);

      expect(v.tieneDescuento, isFalse);
      expect(v.precioFinal(), 366.24);
    });
  });

  group('Producto con descuentos por variante', () {
    test('descuentoActivo toma el mejor entre variantes', () {
      final json = {
        'id': '938c1793-2d69-4af9-b17f-a9676f23bad5',
        'name': 'Laptop Dell Inspiron 3520',
        'slug': 'laptop-dell',
        'brand_id': 'c1c5e320-dfd1-4fa6-90b6-08b7ef6db8c0',
        'status': 'ACTIVO',
        'created_at': '2026-09-15T01:44:39.12912+00:00',
        'CATEGORIAS': <dynamic>[],
        'VARIANTE_PRODUCTOS': [
          {
            'id': 'v1',
            'sku': 'con-desc',
            'atributtes': <String, dynamic>{},
            'price': 1000,
            'created_at': '2026-09-15T02:15:02+00:00',
            'IMAGEN_PRODUCTOS': <dynamic>[],
            'DESCUENTO_VARIANTE': [
              {
                'DESCUENTO': {
                  'id': 1,
                  'name': '20%',
                  'date_init': '2026-09-14',
                  'date_expiration': '2026-12-09',
                  'porcentage_discount': 20,
                  'created_at': '2026-09-15T02:16:14+00:00',
                },
              },
            ],
          },
          {
            'id': 'v2',
            'sku': 'sin-desc',
            'atributtes': <String, dynamic>{},
            'price': 500,
            'created_at': '2026-09-15T02:15:02+00:00',
            'IMAGEN_PRODUCTOS': <dynamic>[],
            'DESCUENTO_VARIANTE': <dynamic>[],
          },
        ],
      };

      final p = Producto.fromJson(json);

      expect(p.tieneDescuento, isTrue);
      expect(p.descuentoActivo!.porcentageDiscount, 20);
      // La más barata es v2 sin descuento → precio final 500
      expect(p.varianteMasBarata!.id, 'v2');
      expect(p.varianteMasBarata!.precioFinal(), 500);
    });
  });
}
