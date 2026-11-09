import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/models/variante_producto_model.dart';
import '../../cart/cart_controller.dart';
import '../../../widgets/common/app_empty_state.dart';
import '../../../widgets/common/price_text.dart';
import '../../../widgets/common/section_title.dart';
import '../../../widgets/common/status_chip.dart';
import 'widgets/product_image_gallery.dart';
import 'widgets/variant_card.dart';

/// Detalle del producto: galería, descripción y variantes.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Producto product;

  double? get _minPrice => product.variantes.isEmpty
      ? null
      : product.variantes
          .map((v) => v.price)
          .reduce((a, b) => a < b ? a : b);

  void _addToCart(BuildContext context, VarianteProducto variant) {
    context.read<CartController>().add(
          productId: product.id,
          variantId: variant.id,
          name: product.name,
          sku: variant.sku,
          unitPrice: variant.price,
          imageUrl: variant.imagenPrincipalUrl,
        );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${AppStrings.addedToCart}: ${product.name}'),
          duration: const Duration(milliseconds: 1600),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final images =
        ordenarImagenes(product.variantes.expand((v) => v.imagenes));

    return Scaffold(
      appBar: AppBar(title: Text(product.name, maxLines: 1)),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ProductImageGallery(images: images),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusChip(status: product.status),
                    ...product.categorias.map(
                      (category) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.blue100),
                        ),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(product.name, style: textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_minPrice != null) ...[
                      Text(
                        '${AppStrings.fromPrice} ',
                        style: textTheme.bodyMedium,
                      ),
                      PriceText(price: _minPrice, fontSize: 26),
                    ] else
                      const PriceText(
                        price: null,
                        emptyLabel: AppStrings.noPrice,
                        fontSize: 20,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionTitle(title: AppStrings.descriptionSection),
                _DescriptionBox(
                  description: product.description?.trim().isNotEmpty == true
                      ? product.description!.trim()
                      : AppStrings.noDescription,
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionTitle(
                  title: AppStrings.variantsSection,
                  trailing: Text(
                    '${product.variantes.length}',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.blue600,
                    ),
                  ),
                ),
                if (product.variantes.isEmpty)
                  const AppEmptyState(
                    icon: Icons.sell_outlined,
                    message: AppStrings.noVariants,
                  )
                else
                  ...product.variantes.map(
                    (variant) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: VariantCard(
                        variant: variant,
                        onAddToCart: () => _addToCart(context, variant),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionBox extends StatelessWidget {
  const _DescriptionBox({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.outline),
      ),
      child: Text(description, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
