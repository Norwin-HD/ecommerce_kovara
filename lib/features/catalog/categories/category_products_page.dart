import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/repository/producto_repository.dart';
import '../../../widgets/common/app_empty_state.dart';
import '../../../widgets/common/app_error_state.dart';
import '../../../widgets/common/app_loading.dart';
import '../products/widgets/product_card.dart';

/// Lista de productos que pertenecen a una categoría.
class CategoryProductsPage extends StatefulWidget {
  const CategoryProductsPage({
    super.key,
    required this.category,
    required this.repository,
  });

  final Categoria category;
  final ProductoRepository repository;

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late Future<List<Producto>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.repository.getCatalogoPublico();
  }

  void _retry() => setState(_load);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: FutureBuilder<List<Producto>>(
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

          final products = (snapshot.data ?? [])
              .where((product) =>
                  product.categorias.any((c) => c.id == widget.category.id))
              .toList();

          if (products.isEmpty) {
            return const AppEmptyState(
              icon: Icons.inventory_2_outlined,
              message: AppStrings.emptyProducts,
              hint: AppStrings.emptyProductsHint,
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
                maxCrossAxisExtent: 340,
                mainAxisExtent: 330,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: products[index]),
            ),
          );
        },
      ),
    );
  }
}
