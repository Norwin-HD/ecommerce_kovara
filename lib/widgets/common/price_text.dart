import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';

/// Texto de precio destacado en azul. Muestra [emptyLabel] si es null.
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.emptyLabel = '—',
    this.fontSize = 18,
    this.color = AppColors.blue600,
    this.symbol = r'C$',
  });

  final double? price;
  final String emptyLabel;
  final double fontSize;
  final Color color;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final text =
        price == null ? emptyLabel : AppFormatters.price(price!, symbol: symbol);
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: price == null ? Theme.of(context).textTheme.bodySmall?.color : color,
        height: 1.2,
      ),
    );
  }
}
