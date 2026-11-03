import 'package:supabase_flutter/supabase_flutter.dart';

class HorarioAtencionService {
  final SupabaseClient _client;

  HorarioAtencionService({SupabaseClient? client}) 
      : _client = client ?? Supabase.instance.client;

  Future<List> obtenerHorariosRaw() async {
    try {
      final response = await _client
          .from('HORARIOS_ATENCION')
          .select()
          .order('day_of_week', ascending: true);
          
      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error al cargar horarios desde BD: ${e.message}');
    } catch (e) {
      throw Exception('Error de red obteniendo horarios: $e');
    }
  }
}