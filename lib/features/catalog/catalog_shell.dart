import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/consts/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repository/categoria_repository.dart';
import '../../data/repository/marca_repository.dart';
import '../../data/repository/producto_repository.dart';
import '../../features/cart/cart_controller.dart';
import '../../features/cart/cart_page.dart';
import '../../features/home/home_page.dart';
import 'products/products_page.dart';
import 'categories/categories_page.dart';

/// Contenedor principal con la navegación inferior (4 pestañas).
class CatalogShell extends StatefulWidget {
  const CatalogShell({
    super.key,
    required this.productoRepository,
    required this.categoriaRepository,
    required this.marcaRepository,
  });

  final ProductoRepository productoRepository;
  final CategoriaRepository categoriaRepository;
  final MarcaRepository marcaRepository;

  @override
  State<CatalogShell> createState() => _CatalogShellState();
}

class _CatalogShellState extends State<CatalogShell> {
  int _selectedIndex = 0;

  void _goToProducts() => setState(() => _selectedIndex = 1);

  void _goToCategories() => setState(() => _selectedIndex = 2);

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartController>().itemCount;

    // IndexedStack conserva el estado (y scroll) de cada pestaña.
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            productoRepository: widget.productoRepository,
            categoriaRepository: widget.categoriaRepository,
            onSeeAllProducts: _goToProducts,
            onSeeAllCategories: _goToCategories,
          ),
          ProductsPage(
            productoRepository: widget.productoRepository,
            categoriaRepository: widget.categoriaRepository,
            marcaRepository: widget.marcaRepository,
          ),
          CategoriesPage(
            repository: widget.categoriaRepository,
            productoRepository: widget.productoRepository,
          ),
          const CartPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.tabHome,
          ),
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: AppStrings.tabProducts,
          ),
          const NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: AppStrings.tabCategories,
          ),
          NavigationDestination(
            icon: _CartIcon(count: cartCount),
            selectedIcon: _CartIcon(count: cartCount, selected: true),
            label: AppStrings.tabCart,
          ),
        ],
      ),
    );
  }
}

/// Icono de carrito con badge de cantidad.
class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, this.selected = false});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
    );
    if (count == 0) return icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.blue500,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.navy900, width: 1.5),
            ),
            child: Text(
              count > 9 ? '9+' : '$count',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnDark,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
