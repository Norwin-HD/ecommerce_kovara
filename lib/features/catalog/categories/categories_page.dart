import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/repository/categoria_repository.dart';
import '../../../widgets/common/app_empty_state.dart';
import '../../../widgets/common/app_error_state.dart';
import '../../../widgets/common/app_loading.dart';
import 'widgets/category_card.dart';

/// Grid de categorías del catálogo.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, required this.repository});

  final CategoriaRepository repository;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Categoria>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.repository.getCategorias();
  }

  void _retry() => setState(_load);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.categoriesTitle)),
      body: FutureBuilder<List<Categoria>>(
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

          final categories = snapshot.data ?? [];
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
              itemBuilder: (context, index) =>
                  CategoryCard(category: categories[index]),
            ),
          );
        },
      ),
    );
  }
}
