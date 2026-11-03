import '../models/categoria_model.dart';
import '../services/categoria_service.dart';

class CategoriaRepository {
  final CategoriaService _categoriaService;

  CategoriaRepository({CategoriaService? categoriaService}) 
      : _categoriaService = categoriaService ?? CategoriaService();

  Future<List<Categoria>> getCategorias() async {
    try {
      final rawData = await _categoriaService.obtenerCategoriasRaw();
      
      final categorias = rawData
          .map((jsonCategoria) => Categoria.fromJson(jsonCategoria))
          .toList();
          
      return categorias;
    } catch (e) {
      rethrow; 
    }
  }
}