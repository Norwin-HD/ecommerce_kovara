import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/consts/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../widgets/common/price_text.dart';
import '../cart_controller.dart';
import '../models/cart_item.dart';

/// Fila de un producto dentro del carrito: imagen, datos y controles.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    this.onRemove,
  });

  final CartItem item;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: SizedBox(
              width: 72,
              height: 72,
              child: item.imageUrl.isEmpty
                  ? const ColoredBox(
                      color: AppColors.surfaceAlt,
                      child: Icon(
                        Icons.laptop_mac_outlined,
                        color: AppColors.navy600,
                      ),
                    )
                  : Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: AppColors.surfaceAlt,
                        child: Icon(
                          Icons.laptop_mac_outlined,
                          color: AppColors.navy600,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppStrings.skuLabel}: ${item.sku}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                PriceText(
                  price: item.unitPrice,
                  fontSize: 14,
                  emptyLabel: AppStrings.noPrice,
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuantityControls(item: item),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PriceText(price: item.lineTotal, fontSize: 15),
              IconButton(
                tooltip: AppStrings.removeItem,
                visualDensity: VisualDensity.compact,
                onPressed: () => _confirmRemove(context),
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    if (onRemove == null) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.removeItem),
        content: Text(item.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onRemove!();
            },
            child: const Text(AppStrings.removeItem),
          ),
        ],
      ),
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartController>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundButton(
            tooltip: AppStrings.decrementQuantity,
            icon: Icons.remove,
            onTap: () => cart.decrement(item.variantId),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          _RoundButton(
            tooltip: AppStrings.incrementQuantity,
            icon: Icons.add,
            onTap: () => cart.increment(item.variantId),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.navy700),
    );
  }
}
