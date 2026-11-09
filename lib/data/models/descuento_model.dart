class Descuento {
  final int id;
  final String name;
  final DateTime dateInit;
  final DateTime dateExpiration;
  final double porcentageDiscount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Descuento({
    required this.id,
    required this.name,
    required this.dateInit,
    required this.dateExpiration,
    required this.porcentageDiscount,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Descuento.fromJson(Map<String, dynamic> json) {
    return Descuento(
      id: json['id'] as int,
      name: json['name'] as String,
      dateInit: DateTime.parse(json['date_init'] as String),
      dateExpiration: DateTime.parse(json['date_expiration'] as String),
      porcentageDiscount: (json['porcentage_discount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      deletedAt: json['deleted_at'] != null 
          ? DateTime.parse(json['deleted_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date_init': dateInit.toIso8601String(),
      'date_expiration': dateExpiration.toIso8601String(),
      'porcentage_discount': porcentageDiscount,
    };
  }

  /// Indica si el descuento está vigente en [fecha] (por defecto hoy),
  /// considerando que no esté eliminado y que la fecha caiga dentro
  /// del rango [dateInit, dateExpiration] (inclusive, por día).
  bool estaVigente([DateTime? fecha]) {
    if (deletedAt != null) return false;

    final ahora = fecha ?? DateTime.now();
    final dia = DateTime(ahora.year, ahora.month, ahora.day);
    final inicio = DateTime(dateInit.year, dateInit.month, dateInit.day);
    final fin = DateTime(
      dateExpiration.year,
      dateExpiration.month,
      dateExpiration.day,
    );

    return !dia.isBefore(inicio) && !dia.isAfter(fin);
  }

  /// Aplica el porcentaje de descuento sobre [precio].
  /// Ej: precio 10000 con 15% -> 8500
  double aplicarA(double precio) {
    if (porcentageDiscount <= 0) return precio;
    if (porcentageDiscount >= 100) return 0;
    return precio * (1 - porcentageDiscount / 100);
  }
}


