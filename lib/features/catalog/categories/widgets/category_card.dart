import 'package:flutter/material.dart';

import '../../../../core/consts/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../data/models/categoria_model.dart';

/// Tarjeta de categoría con acceso a sus productos.
class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final Categoria category;

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
            '/category-products',
            arguments: category,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.navy800,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(
                    Icons.laptop_mac_outlined,
                    color: AppColors.textOnDark,
                    size: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Expanded(
                  child: Text(
                    category.description?.trim().isNotEmpty == true
                        ? category.description!.trim()
                        : AppStrings.noCategoryDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.seeDetails,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.blue600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.blue600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
