import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/repository/categoria_repository.dart';
import '../../../data/repository/producto_repository.dart';
import '../../../widgets/common/app_empty_state.dart';
import '../../../widgets/common/app_error_state.dart';
import '../../../widgets/common/app_loading.dart';
import 'widgets/category_card.dart';

/// Resultado de cargar categorías + portadas/count desde el catálogo.
class _CategoriesData {
  const _CategoriesData({
    required this.categories,
    required this.covers,
    required this.counts,
  });

  final List<Categoria> categories;
  final Map<String, String> covers;
  final Map<String, int> counts;
}

/// Grid de categorías del catálogo con foto de portada por categoría.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.repository,
    required this.productoRepository,
  });

  final CategoriaRepository repository;
  final ProductoRepository productoRepository;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  late Future<_CategoriesData> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _loadData();
  }

  /// Carga categorías y, con el catálogo, arma portada + contador por id.
  Future<_CategoriesData> _loadData() async {
    final results = await Future.wait([
      widget.repository.getCategorias(),
      widget.productoRepository.getCatalogoPublico(),
    ]);

    final categories = results[0] as List<Categoria>;
    final products = results[1] as List<Producto>;

    final covers = <String, String>{};
    final counts = <String, int>{};

    for (final product in products) {
      final imageUrl = product.variantes.isEmpty
          ? ''
          : product.variantes.first.imagenPrincipalUrl;
      for (final category in product.categorias) {
        counts[category.id] = (counts[category.id] ?? 0) + 1;
        if (imageUrl.isNotEmpty && !covers.containsKey(category.id)) {
          covers[category.id] = imageUrl;
        }
      }
    }

    return _CategoriesData(
      categories: categories,
      covers: covers,
      counts: counts,
    );
  }

  void _retry() => setState(_load);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.categoriesTitle)),
      body: FutureBuilder<_CategoriesData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoading();
          }
          if (snapshot.hasError) {
            return AppErrorState(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          final data = snapshot.data;
          final categories = data?.categories ?? const <Categoria>[];
          if (categories.isEmpty) {
            return const AppEmptyState(
              icon: Icons.category_outlined,
              message: AppStrings.emptyCategories,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _retry();
              try {
                await _future;
              } catch (_) {}
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisExtent: 172,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  imageUrl: data?.covers[category.id] ?? '',
                  productCount: data?.counts[category.id],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
