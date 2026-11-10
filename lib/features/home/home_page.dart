import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/repository/categoria_repository.dart';
import '../../../data/repository/producto_repository.dart';
import '../../../widgets/common/app_error_state.dart';
import '../../../widgets/common/app_loading.dart';
import 'widgets/benefits_strip.dart';
import 'widgets/featured_products_section.dart';
import 'widgets/hero_banner.dart';
import 'widgets/how_to_buy_section.dart';
import 'widgets/quick_categories_section.dart';
import 'widgets/store_info_footer.dart';

/// Home de la app: banner, beneficios, destacados, categorías,
/// cómo comprar e información de la tienda.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.productoRepository,
    required this.categoriaRepository,
    this.onSeeAllProducts,
    this.onSeeAllCategories,
  });

  final ProductoRepository productoRepository;
  final CategoriaRepository categoriaRepository;
  final VoidCallback? onSeeAllProducts;
  final VoidCallback? onSeeAllCategories;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Producto>> _productsFuture;
  late Future<List<Categoria>> _categoriesFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _productsFuture = widget.productoRepository.getCatalogoPublico();
    _categoriesFuture = widget.categoriaRepository.getCategorias();
  }

  void _retry() => setState(_load);

  Future<void> _refresh() async {
    _retry();
    try {
      await Future.wait([_productsFuture, _categoriesFuture]);
    } catch (_) {}
  }

  /// Los productos más recientes primero (destacados del home).
  List<Producto> _recent(List<Producto> products) {
    final sorted = [...products]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final settings = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.appName),
            Text(
              AppStrings.appTagline,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textOnDarkMuted,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Producto>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoading();
          }

          final products =
              snapshot.hasError ? const <Producto>[] : (snapshot.data ?? []);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      HeroBanner(
                        bannerUrl: settings.heroBannerUrl,
                        logoUrl: settings.logoUrl,
                      ),
                      if (settings.isTemporarilyClosed)
                        const ClosedNoticeBanner(),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: BenefitsStrip()),
                SliverToBoxAdapter(
                  child: FeaturedProductsSection(
                    products: _recent(products),
                    onSeeAll: widget.onSeeAllProducts,
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder<List<Categoria>>(
                    future: _categoriesFuture,
                    builder: (context, categorySnapshot) {
                      final categories = categorySnapshot.data ?? const [];
                      return QuickCategoriesSection(
                        categories: categories,
                        products: products,
                        onSeeAll: widget.onSeeAllCategories,
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: HowToBuySection()),
                if (snapshot.hasError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppErrorState(
                      message: snapshot.error.toString(),
                      onRetry: _retry,
                    ),
                  )
                else
                  const SliverToBoxAdapter(child: StoreInfoFooter()),
              ],
            ),
          );
        },
      ),
    );
  }
}
