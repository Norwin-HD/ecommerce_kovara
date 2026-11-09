import 'package:supabase_flutter/supabase_flutter.dart';

class GeneralSettingsService {
  final SupabaseClient _client;

  GeneralSettingsService({SupabaseClient? client}) // INYECCION DE DEPENDECIAS
      : _client = client ?? Supabase.instance.client;

  // GET: OBTENER CONFIGURACION GLOBAL
  Future obtenerConfiguracionRaw() async {
    try {
      final response = await _client
          .from('GENERAL_SETTINGS')
          .select()
          .limit(1) // SOLO OBTENEMOS UNA CONFIGURACION GLOBAL ES DECIR UN REGISTRO
          .single();
          
      return response;
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener configuraciones en Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al cargar la configuración global: $e');
    }
  }
}