import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/models/producto_model.dart';
import '../../../widgets/common/network_image_view.dart';

/// Accesos rápidos a las categorías del catálogo (con portada si hay).
class QuickCategoriesSection extends StatelessWidget {
  const QuickCategoriesSection({
    super.key,
    required this.categories,
    this.products = const [],
    this.onSeeAll,
  });

  final List<Categoria> categories;
  final List<Producto> products;
  final VoidCallback? onSeeAll;

  /// Portada por categoría: primer producto con imagen.
  Map<String, String> get _covers {
    final covers = <String, String>{};
    for (final product in products) {
      if (product.variantes.isEmpty) continue;
      final url = product.variantes.first.imagenPrincipalUrl;
      if (url.isEmpty) continue;
      for (final category in product.categorias) {
        covers.putIfAbsent(category.id, () => url);
      }
    }
    return covers;
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final covers = _covers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xs,
            0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.quickCategoriesTitle,
                  style: textTheme.titleLarge,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text(AppStrings.seeAll),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) => _CategoryPill(
              category: categories[index],
              imageUrl: covers[categories[index].id] ?? '',
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.category, this.imageUrl = ''});

  final Categoria category;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        '/category-products',
        arguments: category,
      ),
      borderRadius: AppRadius.mdAll,
      child: Container(
        width: 132,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppColors.outline),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadius.smAll,
              child: SizedBox(
                width: double.infinity,
                height: 78,
                child: hasImage
                    ? NetworkImageView(
                        url: imageUrl,
                        width: double.infinity,
                        height: 78,
                        fit: BoxFit.cover,
                        icon: Icons.category_outlined,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.navy700, AppColors.navy900],
                          ),
                        ),
                        child: const Icon(
                          Icons.laptop_mac_outlined,
                          size: 32,
                          color: AppColors.textOnDarkMuted,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
