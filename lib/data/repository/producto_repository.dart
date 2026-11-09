// ignore_for_file: prefer_initializing_formals

import '../models/producto_model.dart';
import '../services/producto_service.dart';

class ProductoRepository {
  ProductoService? _productoService;

  ProductoRepository({ProductoService? productoService})
    : _productoService = productoService;

  ProductoService get _service => _productoService ??= ProductoService();

  Future<List<Producto>> getProductos() async {
    try {
      final rawData = await _service.obtenerProductosRaw();
      return rawData.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }

  }

  Future<List<Producto>> getCatalogoPublico() async {
    final rawData = await _service.obtenerCatalogoPublico();
    return rawData.map((json) => Producto.fromJson(json)).toList();
  }

  Future<List<Producto>> getProductosPorMarca(String brandId) async {
    try {
      final rawData = await _service.obtenerProductosPorMarcaRaw(brandId);
      return rawData.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}