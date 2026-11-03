import '../models/horario_atencion_model.dart';
import '../services/horario_atencion_service.dart';

class HorarioAtencionRepository {
  final HorarioAtencionService _service;

  HorarioAtencionRepository({HorarioAtencionService? service}) 
      : _service = service ?? HorarioAtencionService();

  Future<List<HorarioAtencion>> getHorarios() async {
    try {
      final rawData = await _service.obtenerHorariosRaw();
      return rawData.map((json) => HorarioAtencion.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}