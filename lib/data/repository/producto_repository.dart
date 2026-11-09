// ignore_for_file: prefer_initializing_formals

import '../models/producto_model.dart';
import '../services/producto_service.dart';

class ProductoRepository {
   // ATRIBUTO
  ProductoService? _productoService;

  // CONSTRUCTOR PARA INYECCION DE DEPENDENCIAS
  ProductoRepository({ProductoService? productoService})
    : _productoService = productoService;

  ProductoService get _service => _productoService ??= ProductoService();
  
  // OBTENER PRODUCTOS DESDE LA BD Y CONVERTIRLOS A OBJETOS DE TIPO PRODUCTO
  Future<List<Producto>> getProductos() async {
    try {
      final rawData = await _service.obtenerProductosRaw(); // PETICION
      return rawData.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }

  }
  
  // OBTENER CATALOGO PUBLICO DESDE LA BD Y CONVERTIRLOS A OBJETOS DE TIPO PRODUCTO
  Future<List<Producto>> getCatalogoPublico() async {
    final rawData = await _service.obtenerCatalogoPublico();
    return rawData.map((json) => Producto.fromJson(json)).toList();
  }
  
  // OBTENER PRODUCTOS POR MARCA DESDE LA BD Y CONVERTIRLOS A OBJETOS DE TIPO PRODUCTO
  Future<List<Producto>> getProductosPorMarca(String brandId) async {
    try {
      final rawData = await _service.obtenerProductosPorMarcaRaw(brandId);
      return rawData.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}