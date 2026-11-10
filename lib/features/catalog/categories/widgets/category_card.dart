import 'package:flutter/material.dart';

import '../../../../core/consts/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../data/models/categoria_model.dart';
import '../../../../widgets/common/network_image_view.dart';

/// Tarjeta de categoría con foto de portada, overlay y acceso a productos.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.imageUrl = '',
    this.productCount,
  });

  final Categoria category;

  /// Portada tomada de un producto de la categoría (si existe).
  final String imageUrl;
  final int? productCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: AppColors.navy800,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            '/category-products',
            arguments: category,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                NetworkImageView(
                  url: imageUrl,
                  fit: BoxFit.cover,
                  icon: Icons.laptop_mac_outlined,
                )
              else
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.navy700, AppColors.navy900],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.laptop_mac_outlined,
                      size: 48,
                      color: AppColors.textOnDarkMuted,
                    ),
                  ),
                ),
              // Oscurece la foto para que el texto siempre sea legible.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.35, 1.0],
                    colors: [
                      Color(0x000A1628),
                      Color(0xE60A1628),
                    ],
                  ),
                ),
              ),
              // Badge de cantidad de productos (si se conoce).
              if (productCount != null)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${productCount!} ${AppStrings.productsCountLabel}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ),
                ),
              // Contenido inferior.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.description?.trim().isNotEmpty == true
                                  ? category.description!.trim()
                                  : AppStrings.noCategoryDescription,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textOnDarkMuted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.blue600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 12,
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
