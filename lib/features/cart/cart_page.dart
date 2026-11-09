import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/consts/app_strings.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/app_empty_state.dart';
import 'cart_controller.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/cart_summary.dart';

/// Página del carrito de compras (pedido por WhatsApp).
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tabCart),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              tooltip: AppStrings.clearCart,
              onPressed: () => _confirmClear(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const AppEmptyState(
              icon: Icons.shopping_cart_outlined,
              message: AppStrings.cartEmpty,
              hint: AppStrings.cartEmptyHint,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.itemsCount(cart.itemCount),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemTile(
                        item: item,
                        onRemove: () => cart.remove(item.variantId),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar:
          cart.isEmpty ? null : const CartSummary(),
    );
  }

  void _confirmClear(BuildContext context) {
    final cart = context.read<CartController>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.clearCart),
        content: const Text(AppStrings.clearCartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cart.clear();
            },
            child: const Text(AppStrings.clearCart),
          ),
        ],
      ),
    );
  }
}
