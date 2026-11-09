import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../data/models/imagen_producto_model.dart';
import '../../../../widgets/common/network_image_view.dart';

/// Carrusel de imágenes del producto con indicadores de página.
class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({
    super.key,
    required this.images,
    this.height = 280,
  });

  final List<ImagenProducto> images;
  final double height;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return NetworkImageView(
        url: '',
        height: widget.height,
        icon: Icons.laptop_mac_outlined,
      );
    }

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _current = index),
            itemBuilder: (context, index) => NetworkImageView(
              url: widget.images[index].imageUrl,
              icon: Icons.laptop_mac_outlined,
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: AppSpacing.md,
              child: Row(
                children: List.generate(
                  widget.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _current == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _current == index
                          ? AppColors.blue500
                          : AppColors.outlineStrong,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Ordena las imágenes: primero las principales, luego por sortOrder.
List<ImagenProducto> ordenarImagenes(Iterable<ImagenProducto> images) {
  final list = images.toList();
  list.sort((a, b) {
    if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
    return a.sortOrder.compareTo(b.sortOrder);
  });
  return list;
}
