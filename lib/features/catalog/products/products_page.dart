import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/repository/categoria_repository.dart';
import '../../../data/repository/producto_repository.dart';
import '../../../widgets/common/app_empty_state.dart';
import '../../../widgets/common/app_error_state.dart';
import '../../../widgets/common/app_loading.dart';
import '../../../widgets/common/search_field.dart';
import 'widgets/product_card.dart';

/// Página del catálogo: búsqueda, filtro por categoría y grid de productos.
class ProductsPage extends StatefulWidget {
  const ProductsPage({
    super.key,
    required this.productoRepository,
    required this.categoriaRepository,
  });

  final ProductoRepository productoRepository;
  final CategoriaRepository categoriaRepository;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Producto>> _productsFuture;
  late Future<List<Categoria>> _categoriesFuture;

  final _searchController = TextEditingController();
  String _query = '';
  String? _selectedCategoryId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    _productsFuture = widget.productoRepository.getCatalogoPublico();
    _categoriesFuture = widget.categoriaRepository.getCategorias();
  }

  void _retry() => setState(_load);

  Future<void> _refresh() async {
    setState(_load);
    try {
      await _productsFuture;
    } catch (_) {}
  }

  void _onQueryChanged(String value) => setState(() => _query = value);

  void _selectCategory(String? id) => setState(() => _selectedCategoryId = id);

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategoryId = null;
    });
  }

  List<Producto> _applyFilters(List<Producto> products) {
    final query = _query.trim().toLowerCase();
    return products.where((product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.categorias.any((c) => c.name.toLowerCase().contains(query)) ||
          product.variantes.any((v) => v.sku.toLowerCase().contains(query));
      final matchesCategory = _selectedCategoryId == null ||
          product.categorias.any((c) => c.id == _selectedCategoryId);
      return matchesQuery && matchesCategory;
    }).toList();
  }

  bool get _isFiltering => _query.trim().isNotEmpty || _selectedCategoryId != null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.catalogTitle),
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
        actions: [
          IconButton(
            tooltip: AppStrings.refresh,
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterToolbar(
            searchController: _searchController,
            categoriesFuture: _categoriesFuture,
            selectedCategoryId: _selectedCategoryId,
            onQueryChanged: _onQueryChanged,
            onCategorySelected: _selectCategory,
          ),
          Expanded(
            child: FutureBuilder<List<Producto>>(
              future: _productsFuture,
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

                final filtered = _applyFilters(snapshot.data ?? []);
                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 340,
                      mainAxisExtent: 330,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        ProductCard(product: filtered[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final state = _isFiltering
        ? AppEmptyState(
            icon: Icons.search_off,
            message: AppStrings.emptySearch,
            hint: AppStrings.emptySearchHint,
            action: FilledButton.tonal(
              onPressed: _clearFilters,
              child: const Text('Limpiar filtros'),
            ),
          )
        : const AppEmptyState(
            icon: Icons.inventory_2_outlined,
            message: AppStrings.emptyProducts,
            hint: AppStrings.emptyProductsHint,
          );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [SliverFillRemaining(child: state)],
      ),
    );
  }
}

/// Barra con buscador y chips de categoría para filtrar el catálogo.
class _FilterToolbar extends StatelessWidget {
  const _FilterToolbar({
    required this.searchController,
    required this.categoriesFuture,
    required this.selectedCategoryId,
    required this.onQueryChanged,
    required this.onCategorySelected,
  });

  final TextEditingController searchController;
  final Future<List<Categoria>> categoriesFuture;
  final String? selectedCategoryId;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          SearchField(
            controller: searchController,
            hint: AppStrings.searchHint,
            onChanged: onQueryChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 36,
            child: FutureBuilder<List<Categoria>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? <Categoria>[];
                if (snapshot.hasError || categories.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _CategoryChips(
                  categories: categories,
                  selectedId: selectedCategoryId,
                  onSelected: onCategorySelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<Categoria> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      children: [
        _chip(
          label: AppStrings.allCategories,
          selected: selectedId == null,
          onTap: () => onSelected(null),
        ),
        ...categories.map(
          (category) => _chip(
            label: category.name,
            selected: selectedId == category.id,
            onTap: () => onSelected(category.id),
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.textOnDark : AppColors.navy700,
        ),
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.navy800,
        side: BorderSide(
          color: selected ? AppColors.navy800 : AppColors.outline,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
