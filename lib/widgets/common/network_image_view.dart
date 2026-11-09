import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Imagen de red con placeholder, carga y error integrados.
class NetworkImageView extends StatelessWidget {
  const NetworkImageView({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.icon = Icons.laptop_mac_outlined,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AppColors.surfaceAlt,
      child: Center(
        child: Icon(icon, size: 42, color: AppColors.navy600),
      ),
    );

    Widget child;
    if (url.trim().isEmpty) {
      child = placeholder;
    } else {
      child = Image.network(
        url,
        width: width ?? double.infinity,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    if (radius != null) {
      child = ClipRRect(borderRadius: radius!, child: child);
    }
    return SizedBox(width: width, height: height, child: child);
  }
}
