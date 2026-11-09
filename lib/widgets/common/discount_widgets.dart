import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/utils/formatters.dart';

/// Chip rojo con el porcentaje de descuento (ej: -15%).
class DiscountBadge extends StatelessWidget {
  const DiscountBadge({super.key, required this.percentage});

  final double percentage;

  static String formatPercentage(double percentage) {
    final isWhole = percentage == percentage.roundToDouble();
    final value = isWhole
        ? percentage.toInt().toString()
        : percentage.toStringAsFixed(1);
    return '-$value%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        formatPercentage(percentage),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textOnDark,
        ),
      ),
    );
  }
}

/// Muestra el precio original tachado junto al precio final con descuento.
class DiscountPriceText extends StatelessWidget {
  const DiscountPriceText({
    super.key,
    required this.originalPrice,
    required this.finalPrice,
    this.fontSize = 18,
    this.symbol = r'C$',
    this.percentage,
  });

  final double originalPrice;
  final double finalPrice;
  final double fontSize;
  final String symbol;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppFormatters.price(originalPrice, symbol: symbol),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize * 0.72,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                AppFormatters.price(finalPrice, symbol: symbol),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.danger,
                  height: 1.2,
                ),
              ),
            ),
            if (percentage != null) ...[
              const SizedBox(width: AppSpacing.xs),
              DiscountBadge(percentage: percentage!),
            ],
          ],
        ),
      ],
    );
  }
}
