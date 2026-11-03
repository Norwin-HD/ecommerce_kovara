import 'package:supabase_flutter/supabase_flutter.dart';

class GeneralSettingsService {
  final SupabaseClient _client;

  GeneralSettingsService({SupabaseClient? client}) 
      : _client = client ?? Supabase.instance.client;

  Future obtenerConfiguracionRaw() async {
    try {
      final response = await _client
          .from('GENERAL_SETTINGS')
          .select()
          .limit(1)
          .single();
          
      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener configuraciones en Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al cargar la configuración global: $e');
    }
  }
}