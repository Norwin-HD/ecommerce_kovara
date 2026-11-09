import 'package:supabase_flutter/supabase_flutter.dart';

class ProductoService {
  final SupabaseClient _client;

  ProductoService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<List> obtenerProductosRaw() async {
    try {
      final response = await _client
          .from('PRODUCTOS')
          .select()
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false); // Los mas recientes primero

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error de base de datos en PRODUCTOS: ${e.message}');
    } catch (e) {
      throw Exception('Error de conexión al obtener productos: $e');
    }
  }

  Future<List> obtenerProductosPorMarcaRaw(String brandId) async {
    try {
      final response = await _client
          .from('PRODUCTOS')
          .select()
          .isFilter('deleted_at', null)
          .eq('brand_id', brandId); // Filtro por llave foranea

      return response;
    } catch (e) {
      throw Exception('Error al obtener productos de la marca: $e');
    }
  }

  Future<List> obtenerCatalogoPublico() async {
    try {
      final response = await _client
          .from('PRODUCTOS')
          .select('''
          *, 
          CATEGORIAS(*), 
          VARIANTE_PRODUCTOS(
            *,
            IMAGEN_PRODUCTOS(*),
            DESCUENTO_VARIANTE(*, DESCUENTO(*))
          )
        ''')
          .isFilter('deleted_at', null)
          .eq('status', 'ACTIVO');

      return response;
    } catch (e) {
      throw Exception('Error al obtener el catálogo completo: $e');
    }
  }
}
