import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/whatsapp.dart';
import '../cart_controller.dart';

/// Resumen del pedido: subtotal, IVA, total y envío por WhatsApp.
class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();
    final settings = context.watch<SettingsController>();
    final textTheme = Theme.of(context).textTheme;

    final symbol = settings.currencySymbol;
    final taxPercent = settings.taxPercent;
    final subtotal = cart.subtotal;
    final total = cart.totalWithTax(taxPercent);
    final taxAmount = total - subtotal;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline)),
        boxShadow: [
          BoxShadow(
            color: Color(0x140A1628),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.cartSummary,
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _Row(
              label: AppStrings.subtotalLabel,
              value: AppFormatters.price(subtotal, symbol: symbol),
            ),
            if (taxPercent > 0)
              _Row(
                label: '${AppStrings.taxLabel} '
                    '(${taxPercent.toStringAsFixed(0)}%)',
                value: AppFormatters.price(taxAmount, symbol: symbol),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Divider(),
            ),
            _Row(
              label: AppStrings.totalLabel,
              value: AppFormatters.price(total, symbol: symbol),
              emphasized: true,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _sendOrder(context),
                icon: const Icon(Icons.chat, size: 18),
                label: const Text(AppStrings.sendOrderWhatsApp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOrder(BuildContext context) async {
    final cart = context.read<CartController>();
    final settings = context.read<SettingsController>();
    final messenger = ScaffoldMessenger.of(context);

    if (cart.isEmpty) return;

    final phone = settings.whatsappNumber ?? '';
    if (phone.replaceAll(RegExp(r'\D'), '').isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.whatsappMissingNumber)),
      );
      return;
    }

    final message = buildOrderMessage(
      items: cart.items,
      subtotal: cart.subtotal,
      taxPercent: settings.taxPercent,
      currencySymbol: settings.currencySymbol,
    );

    final opened = await openWhatsApp(phone: phone, message: message);
    if (!opened && context.mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.whatsappMissingNumber)),
      );
    } else if (opened && context.mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.whatsappOpened)),
      );
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasized
                  ? textTheme.titleMedium
                  : textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: emphasized
                ? textTheme.titleMedium?.copyWith(color: AppColors.blue600)
                : textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
