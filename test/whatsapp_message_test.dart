import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_kovara/core/utils/whatsapp.dart';
import 'package:ecommerce_kovara/features/cart/models/cart_item.dart';

void main() {
  group('buildOrderMessage', () {
    test('incluye productos, cantidades, subtotal, IVA y total', () {
      final message = buildOrderMessage(
        items: [
          CartItem(
            productId: 'p1',
            variantId: 'v1',
            name: 'Lenovo IdeaPad 3',
            sku: 'LEN-001',
            unitPrice: 1299.50,
            quantity: 2,
          ),
          CartItem(
            productId: 'p2',
            variantId: 'v2',
            name: 'Mouse Logitech',
            sku: 'LOG-002',
            unitPrice: 29.99,
            quantity: 1,
          ),
        ],
        subtotal: 2629.0,
        taxPercent: 16,
        currencySymbol: r'$',
      );

      expect(message, contains('Lenovo IdeaPad 3'));
      expect(message, contains('LEN-001'));
      expect(message, contains('2 x \$1,299.50'));
      expect(message, contains('Mouse Logitech'));
      expect(message, contains('Subtotal: \$2,629.00'));
      expect(message, contains('IVA (16%): \$420.64'));
      expect(message, contains('Total: \$3,049.64'));
    });

    test('omite la línea de IVA cuando es 0', () {
      final message = buildOrderMessage(
        items: [
          CartItem(
            productId: 'p1',
            variantId: 'v1',
            name: 'Laptop',
            sku: 'SKU-1',
            unitPrice: 100,
          ),
        ],
        subtotal: 100,
        taxPercent: 0,
        currencySymbol: r'$',
      );

      expect(message, contains('Subtotal: \$100.00'));
      expect(message, contains('Total: \$100.00'));
      expect(message, isNot(contains('IVA')));
    });
  });
}
