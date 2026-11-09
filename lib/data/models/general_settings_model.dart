class GeneralSettings {
  // ATRIBUTOS
  final int id;
  final String whatsappNumber;
  final double tax;
  final String heroBannerUrl;
  final String supportEmail;
  final String socialInstagram;
  final String socialFacebook;
  final String socialTiktok;
  final String logoUrl;
  final bool isTemporarilyClosed;
  final String baseCurrencyCode;
  final String baseCurrencySymbol;
  final DateTime createdAt;

  // CONSTRUCTOR
  GeneralSettings({
    required this.id,
    required this.whatsappNumber,
    required this.tax,
    required this.heroBannerUrl,
    required this.supportEmail,
    required this.socialInstagram,
    required this.socialFacebook,
    required this.socialTiktok,
    required this.logoUrl,
    required this.isTemporarilyClosed,
    required this.baseCurrencyCode,
    required this.baseCurrencySymbol,
    required this.createdAt,
  });

  // TOMA LOS VALORES OBTENIDOS DEL JSON Y LOS ASIGNA A LOS ATRIBUTOS DE LA CLASE
  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    return GeneralSettings(
      id: json['id'] as int,
      whatsappNumber: json['whatsapp_number'] as String,
      // El valor de tax a double para evitar problemas de tipo
      tax: (json['tax'] as num).toDouble(),
      heroBannerUrl: json['hero_banner_url'] as String,
      supportEmail: json['support_email'] as String,
      socialInstagram: json['social_instagram'] as String,
      socialFacebook: json['social_facebook'] as String,
      socialTiktok: json['social_tiktok'] as String,
      logoUrl: json['logo_url'] as String,
      isTemporarilyClosed: json['is_temporarily_closed'] as bool? ?? false,
      baseCurrencyCode: json['base_currency_code'] as String,
      baseCurrencySymbol: json['base_currency_symbol'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}