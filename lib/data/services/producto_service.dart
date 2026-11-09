import 'package:supabase_flutter/supabase_flutter.dart';

class ProductoService {
  final SupabaseClient _client;

  ProductoService({SupabaseClient? client}) // INYECCION DE DEPENDECIAS
    : _client = client ?? Supabase.instance.client;

  // GET: OBTENER PRODUCTOS
  Future<List> obtenerProductosRaw() async {
    try {
      final response = await _client
          .from('PRODUCTOS')
          .select()
          .isFilter('deleted_at', null) // SOLO LOS PRODUCTOS NO ELIMINADOS
          .order('created_at', ascending: false); // LOS MAS RECIENTES PRIMERO

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error de base de datos en PRODUCTOS: ${e.message}');
    } catch (e) {
      throw Exception('Error de conexión al obtener productos: $e');
    }
  }

  // TODO: HAY QUE IMPLEMENTARLO EN UN FILTRO
  
  // GET: OBTENER PRODUCTOS POR MARCA
  Future<List> obtenerProductosPorMarcaRaw(String brandId) async {
    try {
      final response = await _client
          .from('PRODUCTOS')
          .select()
          .isFilter('deleted_at', null)
          .eq(
            'brand_id',
            brandId,
          ); // VALIDA QUE EL PRODUCTO PERTENEZCA A LA MARCA

      return response;
    } catch (e) {
      throw Exception('Error al obtener productos de la marca: $e');
    }
  }

  // GET: OBTENER CATALOGO PUBLICO
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
