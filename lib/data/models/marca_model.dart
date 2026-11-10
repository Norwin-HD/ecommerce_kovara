class Marca {
  // MODELO PARA REPRESENTAR UNA MARCA DE LOS PRODUCTOS
  final String id;
  final String name;
  final String slug;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  // CONSTRUCTOR
  Marca({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // TOMA LOS VALORES OBTENIDOS DEL JSON Y LOS ASIGNA A LOS ATRIBUTOS DE LA CLASE
  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logoUrl: json['logo_url'] as String?,
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
      'slug': slug,
      'logo_url': logoUrl,
    };
  }

  /// Igualdad por id (útil para comparar selección de filtros).
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Marca && other.id == id);

  @override
  int get hashCode => id.hashCode;
}