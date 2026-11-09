// ignore_for_file: prefer_initializing_formals

import '../models/categoria_model.dart';
import '../services/categoria_service.dart';

class CategoriaRepository {
  CategoriaService? _categoriaService; // TRAE LOS DATOS OBTENIDOS DE LA BD

  CategoriaRepository({CategoriaService? categoriaService})
    : _categoriaService = categoriaService; // CONSTRUCTOR PARA INYECCION DE DEPENDENCIAS

  CategoriaService get _service => _categoriaService ??= CategoriaService();
  

  // OBTENER CATEGORIAS DESDE LA BD Y CONVERTIRLAS A OBJETOS DE TIPO CATEGORIA
  Future<List<Categoria>> getCategorias() async {
    try {
      final rawData = await _service.obtenerCategoriasRaw(); // PETICION

      final categorias = rawData
          .map((jsonCategoria) => Categoria.fromJson(jsonCategoria)) // TRANSFORMA EL JSON A OBJETO CATEGORIA
          .toList(); // CONVIERTE EL MAP A LISTA Y LO GUARDA

      return categorias;
    } catch (e) {
      rethrow;
    }
  }
}
