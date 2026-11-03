class HorarioAtencion {
  final int id;
  final int dayOfWeek;
  final String? openTime; 
  final String? closeTime; 
  final DateTime createdAt;

  HorarioAtencion({
    required this.id,
    required this.dayOfWeek,
    this.openTime,
    this.closeTime,
    required this.createdAt,
  });

  factory HorarioAtencion.fromJson(Map<String, dynamic> json) {
    return HorarioAtencion(
      id: json['id'] as int,
      dayOfWeek: json['day_of_week'] as int,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Devuelve true si la tienda no abre ese dia
  bool get estaCerrado => openTime == null || closeTime == null;

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

  String get horarioFormateado {
    if (estaCerrado) return 'Cerrado';
    final open = openTime!.substring(0, 5); 
    final close = closeTime!.substring(0, 5);
    return '$open - $close';
  }
}