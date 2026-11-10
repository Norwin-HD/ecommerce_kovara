import 'package:supabase_flutter/supabase_flutter.dart';

class MarcaService {
  final SupabaseClient _client;

  MarcaService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  /// GET: marcas activas ordenadas alfabéticamente.
  Future<List> obtenerMarcasRaw() async {
    try {
      final response = await _client
          .from('MARCA')
          .select()
          .isFilter('deleted_at', null)
          .order('name', ascending: true);

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error de base de datos en MARCA: ${e.message}');
    } catch (e) {
      throw Exception('Error de conexión al obtener marcas: $e');
    }
  }

  /// GET: productos activos de una marca con categorías, variantes,
  /// imágenes y descuentos (mismo shape que el catálogo público).
  Future<List> obtenerProductosPorMarcaRaw(String brandId) async {
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
          .eq('status', 'ACTIVO')
          .eq('brand_id', brandId)
          .order('created_at', ascending: false);

      return response;
    } on PostgrestException catch (e) {
      throw Exception(
        'Error de base de datos en productos por marca: ${e.message}',
      );
    } catch (e) {
      throw Exception('Error al obtener productos de la marca: $e');
    }
  }
}
