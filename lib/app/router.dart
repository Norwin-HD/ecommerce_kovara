import 'package:flutter/material.dart';

import '../data/models/categoria_model.dart';
import '../data/models/producto_model.dart';
import '../data/repository/categoria_repository.dart';
import '../data/repository/producto_repository.dart';
import '../features/catalog/catalog_shell.dart';
import '../features/catalog/categories/category_products_page.dart';
import '../features/catalog/products/product_detail_page.dart';

/// Nombres de rutas de la app.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const productDetail = '/product-detail';
  static const categoryProducts = '/category-products';
}

/// Generador de rutas centralizado.
/// Para agregar una pantalla nueva: añade la ruta en [AppRoutes] y su case aquí.
class AppRouter {
  AppRouter({
    required this.productoRepository,
    required this.categoriaRepository,
  });

  final ProductoRepository productoRepository;
  final CategoriaRepository categoriaRepository;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CatalogShell(
            productoRepository: productoRepository,
            categoriaRepository: categoriaRepository,
          ),
        );

      case AppRoutes.productDetail:
        final product = settings.arguments;
        if (product is! Producto) return _unknownRoute(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetailPage(product: product),
        );

      case AppRoutes.categoryProducts:
        final category = settings.arguments;
        if (category is! Categoria) return _unknownRoute(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CategoryProductsPage(
            category: category,
            repository: productoRepository,
          ),
        );

      default:
        return _unknownRoute(settings);
    }
  }

  Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Pantalla no encontrada.')),
      ),
    );
  }
}
