/// Formateadores de datos para presentación.
class AppFormatters {
  AppFormatters._();

  /// Formatea un precio con separador de miles y dos decimales: 12999.5 -> $12,999.50
  static String price(double value, {String symbol = r'$'}) {
    final negative = value < 0;
    final parts = value.abs().toStringAsFixed(2).split('.');
    final whole = parts[0];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return '${negative ? '-' : ''}$symbol$buffer.${parts[1]}';
  }
}

extension StringX on String {
  /// 'activo' -> 'Activo'
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
