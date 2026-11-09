class HorarioAtencion {
  // Modelo para representar el horario de atención de un negocio
  final int id;
  final int dayOfWeek;
  final String? openTime; 
  final String? closeTime; 
  final DateTime createdAt;

  // Constructor
  HorarioAtencion({
    required this.id,
    required this.dayOfWeek,
    this.openTime,
    this.closeTime,
    required this.createdAt,
  });

  // TRANSFORMA EL JSON RECIBIDO EN UN OBJETO DE TIPO HorarioAtencion
  factory HorarioAtencion.fromJson(Map<String, dynamic> json) {
    return HorarioAtencion(
      id: json['id'] as int,
      dayOfWeek: json['day_of_week'] as int,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // METODOS 

  // HELPER USADO PARA SABER SI EL NEGOCIO ESTA CERRADO O ABIERTO
  bool get estaCerrado => openTime == null || closeTime == null;

  // HELPER PARA TRANSFORMAR LOS DATOS NUMERICOS EN NOMBRES DE DIAS DE LA SEMANA
  String get nombreDia {
    switch (dayOfWeek) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return 'Desconocido';
    }
  }

  // HELPER PARA FORMATEAR EL HORARIO EN UNA CADENA LEGIBLE
  String get horarioFormateado {
    if (estaCerrado) return 'Cerrado';
    final open = openTime!.substring(0, 5); 
    final close = closeTime!.substring(0, 5);
    return '$open - $close';
  }
}