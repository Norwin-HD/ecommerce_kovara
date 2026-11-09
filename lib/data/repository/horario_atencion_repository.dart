import '../models/horario_atencion_model.dart';
import '../services/horario_atencion_service.dart';

class HorarioAtencionRepository {

   // ATRIBUTO
  final HorarioAtencionService _service;

  // CONSTRUCTOR PARA INYECCION DE DEPENDENCIAS
  HorarioAtencionRepository({HorarioAtencionService? service}) 
      : _service = service ?? HorarioAtencionService();

  // OBTENER HORARIOS DE ATENCION DESDE LA BD Y CONVERTIRLOS A OBJETOS DE TIPO HORARIOATENCION
  Future<List<HorarioAtencion>> getHorarios() async {
    try {
      final rawData = await _service.obtenerHorariosRaw();
      return rawData.map((json) => HorarioAtencion.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}