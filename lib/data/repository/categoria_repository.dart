// ignore_for_file: prefer_initializing_formals

import '../models/categoria_model.dart';
import '../services/categoria_service.dart';

class CategoriaRepository {
  CategoriaService? _categoriaService;

  CategoriaRepository({CategoriaService? categoriaService})
    : _categoriaService = categoriaService;

  CategoriaService get _service => _categoriaService ??= CategoriaService();

  Future<List<Categoria>> getCategorias() async {
    try {
      final rawData = await _service.obtenerCategoriasRaw();

      final categorias = rawData
          .map((jsonCategoria) => Categoria.fromJson(jsonCategoria))
          .toList();

      return categorias;
    } catch (e) {
      rethrow;
    }
  }
}
