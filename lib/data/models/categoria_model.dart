class Categoria {
  // ATRIBUTOS
  final String id;
  final String name;
  final String slug;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  // CONSTRUCTOR
  Categoria({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // TOMA LOS VALORES OBTENIDOS DEL JSON Y LOS ASIGNA A LOS ATRIBUTOS DE LA CLASE
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
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
      'description': description,
    };
  }
}