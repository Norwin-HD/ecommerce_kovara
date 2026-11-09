import 'package:url_launcher/url_launcher.dart';

import '../consts/app_strings.dart';
import '../../features/cart/models/cart_item.dart';
import 'formatters.dart';

/// Construye el mensaje predefinido del pedido para WhatsApp.
String buildOrderMessage({
  required List<CartItem> items,
  required double subtotal,
  required double taxPercent,
  required String currencySymbol,
}) {
  final total = subtotal * (1 + taxPercent / 100);
  final taxAmount = total - subtotal;

  final buffer = StringBuffer()
    ..writeln(AppStrings.appName)
    ..writeln('Pedido de compra')
    ..writeln('-' * 36);

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    buffer
      ..writeln('${i + 1}. ${item.name}')
      ..writeln('   ${AppStrings.skuLabel}: ${item.sku}')
      ..writeln(
        '   ${AppStrings.quantityLabel}: ${item.quantity} x '
        '${AppFormatters.price(item.unitPrice, symbol: currencySymbol)}',
      )
      ..writeln(
        '   ${AppFormatters.price(item.lineTotal, symbol: currencySymbol)}',
      );
    if (i < items.length - 1) buffer.writeln();
  }

  buffer
    ..writeln('-' * 36)
    ..writeln(
      '${AppStrings.subtotalLabel}: '
      '${AppFormatters.price(subtotal, symbol: currencySymbol)}',
    );

  if (taxPercent > 0) {
    buffer.writeln(
      '${AppStrings.taxLabel} (${taxPercent.toStringAsFixed(0)}%): '
      '${AppFormatters.price(taxAmount, symbol: currencySymbol)}',
    );
  }

  buffer
    ..writeln(
      '${AppStrings.totalLabel}: '
      '${AppFormatters.price(total, symbol: currencySymbol)}',
    )
    ..writeln()
    ..writeln('Enviado desde la app Kovara');

  return buffer.toString();
}

/// Abre WhatsApp con el [message] hacia [phone] (formato internacional).
/// Devuelve false si no hay número o no se pudo abrir.
Future<bool> openWhatsApp({
  required String phone,
  required String message,
}) async {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return false;

  final uri = Uri.parse(
    'https://wa.me/$digits?text=${Uri.encodeComponent(message)}',
  );
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
