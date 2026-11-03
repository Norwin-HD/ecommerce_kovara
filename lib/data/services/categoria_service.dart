import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriaService {
  final SupabaseClient _client;

  CategoriaService({SupabaseClient? client}) 
      : _client = client ?? Supabase.instance.client;

  Future<List> obtenerCategoriasRaw() async {
    try {
      final response = await _client
          .from('CATEGORIAS')
          .select()
          .isFilter('deleted_at', null)
          .order('name', ascending: true);
          
      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error en Supabase (CATEGORIAS): ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al obtener categorías: $e');
    }
  }
}