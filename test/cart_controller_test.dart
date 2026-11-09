import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_kovara/features/cart/cart_controller.dart';

void main() {
  group('CartController', () {
    test('agrega items y acumula cantidades por variante', () {
      final cart = CartController();

      cart.add(
        productId: 'p1',
        variantId: 'v1',
        name: 'Laptop A',
        sku: 'SKU-1',
        unitPrice: 1000,
      );
      cart.add(
        productId: 'p1',
        variantId: 'v1',
        name: 'Laptop A',
        sku: 'SKU-1',
        unitPrice: 1000,
      );

      expect(cart.items.length, 1);
      expect(cart.itemCount, 2);
      expect(cart.subtotal, 2000);
    });

    test('incrementa, decrementa y elimina items', () {
      final cart = CartController();
      cart.add(
        productId: 'p1',
        variantId: 'v1',
        name: 'Laptop A',
        sku: 'SKU-1',
        unitPrice: 500,
      );

      cart.increment('v1');
      expect(cart.itemCount, 2);

      cart.decrement('v1');
      expect(cart.itemCount, 1);

      cart.decrement('v1'); // llega a 0 y se elimina
      expect(cart.isEmpty, isTrue);
    });

    test('calcula subtotal y total con impuesto', () {
      final cart = CartController();
      cart.add(
        productId: 'p1',
        variantId: 'v1',
        name: 'Laptop A',
        sku: 'SKU-1',
        unitPrice: 100,
      );
      cart.add(
        productId: 'p2',
        variantId: 'v2',
        name: 'Mouse',
        sku: 'SKU-2',
        unitPrice: 50,
      );

      expect(cart.subtotal, 150);
      expect(cart.totalWithTax(16), 174);
      expect(cart.totalWithTax(0), 150);
    });

    test('vaciar carrito limpia todo', () {
      final cart = CartController();
      cart.add(
        productId: 'p1',
        variantId: 'v1',
        name: 'Laptop A',
        sku: 'SKU-1',
        unitPrice: 100,
      );
      cart.clear();

      expect(cart.isEmpty, isTrue);
      expect(cart.subtotal, 0);
    });
  });
}
