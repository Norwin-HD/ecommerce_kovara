import '../models/producto_model.dart';
import '../services/producto_service.dart';

class ProductoRepository {
  final ProductoService _productoService;

  ProductoRepository({ProductoService? productoService}) 
      : _productoService = productoService ?? ProductoService();

  Future<List<Producto>> getProductos() async {
    try {
      final rawData = await _productoService.obtenerProductosRaw();
      return rawData.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Producto>> getProductosPorMarca(String brandId) async {
    try {
      final rawData = await _productoService.obtenerProductosPorMarcaRaw(brandId);
      return rawData.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}