// ignore_for_file: prefer_initializing_formals

import '../models/marca_model.dart';
import '../models/producto_model.dart';
import '../services/marca_service.dart';

class MarcaRepository {
  MarcaService? _marcaService;

  MarcaRepository({MarcaService? marcaService}) : _marcaService = marcaService;

  MarcaService get _service => _marcaService ??= MarcaService();

  /// Marcas activas desde la BD.
  Future<List<Marca>> getMarcas() async {
    final rawData = await _service.obtenerMarcasRaw();
    return rawData
        .map((json) => Marca.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  /// Productos activos de una marca (con variantes, imágenes y descuentos).
  Future<List<Producto>> getProductosPorMarca(String brandId) async {
    final rawData = await _service.obtenerProductosPorMarcaRaw(brandId);
    return rawData
        .map((json) => Producto.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
