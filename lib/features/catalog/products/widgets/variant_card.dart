import 'package:flutter/material.dart';

import '../../../../core/consts/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../data/models/variante_producto_model.dart';
import '../../../../widgets/common/discount_widgets.dart';
import '../../../../widgets/common/price_text.dart';

/// Tarjeta de una variante de producto (SKU + atributos + precio).
class VariantCard extends StatelessWidget {
  const VariantCard({super.key, required this.variant, this.onAddToCart});

  final VarianteProducto variant;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final attributes = variant.atributos.entries
        .where((e) => e.value is String || e.value is num)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  borderRadius: AppRadius.smAll,
                ),
                child: const Icon(
                  Icons.sell_outlined,
                  size: 20,
                  color: AppColors.navy700,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.skuLabel}: ${variant.sku}',
                      style: textTheme.titleSmall,
                    ),
                    if (attributes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: attributes
                            .map(
                              (e) => Text(
                                '${e.key}: ${e.value}',
                                style: textTheme.bodySmall,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Builder(
                builder: (context) {
                  final discount = variant.descuentoActivo;
                  if (discount == null) {
                    return PriceText(price: variant.price, fontSize: 16);
                  }
                  return DiscountPriceText(
                    originalPrice: variant.price,
                    finalPrice: discount.aplicarA(variant.price),
                    fontSize: 16,
                    percentage: discount.porcentageDiscount,
                  );
                },
              ),
            ],
          ),
          if (onAddToCart != null) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text(AppStrings.addToCart),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
