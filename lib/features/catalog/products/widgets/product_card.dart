import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/router.dart';
import '../../../../core/consts/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../data/models/descuento_model.dart';
import '../../../../data/models/producto_model.dart';
import '../../../../data/models/variante_producto_model.dart';
import '../../../cart/cart_controller.dart';
import '../../../../widgets/common/discount_widgets.dart';
import '../../../../widgets/common/network_image_view.dart';
import '../../../../widgets/common/price_text.dart';
import '../../../../widgets/common/status_chip.dart';

/// Tarjeta de producto para el grid del catálogo.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Producto product;

  VarianteProducto? get _mainVariant =>
      product.variantes.isEmpty ? null : product.variantes.first;

  /// Variante con el menor precio final (ya con descuento si aplica).
  VarianteProducto? get _cheapestVariant => product.varianteMasBarata;

  String get _imageUrl => _mainVariant?.imagenPrincipalUrl ?? '';

  Widget _buildPrice() {
    final variant = _cheapestVariant;
    if (variant == null) {
      return const PriceText(price: null, emptyLabel: AppStrings.noPrice);
    }

    final discount = variant.descuentoActivo;
    if (discount == null) {
      return PriceText(price: variant.price);
    }

    return DiscountPriceText(
      originalPrice: variant.price,
      finalPrice: discount.aplicarA(variant.price),
      fontSize: 16,
      percentage: discount.porcentageDiscount,
    );
  }

  void _quickAdd(BuildContext context) {
    final variant = _mainVariant;
    if (variant == null) return;

    context.read<CartController>().add(
          productId: product.id,
          variantId: variant.id,
          name: product.name,
          sku: variant.sku,
          unitPrice: variant.precioFinal(),
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.outline),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.productDetail,
            arguments: product,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSection(
                url: _imageUrl,
                status: product.status,
                discount: _cheapestVariant?.descuentoActivo ??
                    product.descuentoActivo,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _SpecChips(atributos: _mainVariant?.atributos ?? const {}),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPrice(),
                          ),
                          if (_mainVariant != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            _AddButton(onAdd: () => _quickAdd(context)),
                          ],
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.navy900,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({
    required this.url,
    required this.status,
    this.discount,
  });

  final String url;
  final String status;
  final Descuento? discount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NetworkImageView(
          url: url,
          height: 150,
          width: double.infinity,
          icon: Icons.laptop_mac_outlined,
        ),
        if (discount != null)
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: DiscountBadge(
              percentage: discount!.porcentageDiscount,
            ),
          ),
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: StatusChip(status: status),
        ),
      ],
    );
  }
}

/// Muestra hasta 2 atributos de la variante (ej: "RAM: 16 GB").
class _SpecChips extends StatelessWidget {
  const _SpecChips({required this.atributos});

  final Map<String, dynamic> atributos;

  @override
  Widget build(BuildContext context) {
    final entries = atributos.entries
        .where((e) => e.value is String || e.value is num)
        .take(2)
        .toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: entries
          .map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: AppRadius.smAll,
                border: Border.all(color: AppColors.blue100),
              ),
              child: Text(
                '${e.key}: ${e.value}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy700,
                ),
              ),
              ),
            )
            .toList(),
    );
  }
}

/// Botón circular "+" para agregar el producto al carrito desde la tarjeta.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppStrings.addToCart,
      child: Material(
        color: AppColors.blue600,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onAdd,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.add, size: 18, color: AppColors.textOnDark),
          ),
        ),
      ),
    );
  }
}
