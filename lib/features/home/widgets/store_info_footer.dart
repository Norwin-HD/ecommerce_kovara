import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/horario_atencion_model.dart';
import '../../../widgets/common/network_image_view.dart';

/// Footer compacto de la tienda: logo, horarios, contacto y redes.
/// Consume GeneralSettings y HorarioAtencion via [SettingsController].
class StoreInfoFooter extends StatelessWidget {
  const StoreInfoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.navy900,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.storeInfoSection,
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _Header(controller: controller),
          if (controller.isTemporarilyClosed) ...[
            const SizedBox(height: AppSpacing.sm),
            const _ClosedTag(),
          ],
          if (controller.isLoading && !controller.hasSettings) ...[
            const SizedBox(height: AppSpacing.md),
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.blue400,
                ),
              ),
            ),
          ],
          if (!controller.hasSettings &&
              !controller.isLoading &&
              controller.error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'No se pudo cargar la información de la tienda.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnDarkMuted,
                  fontSize: 11,
                ),
              ),
            ),
          if (controller.hasSettings) ...[
            if (controller.horarios.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              _HoursCompact(horarios: controller.horarios),
            ],
            const SizedBox(height: AppSpacing.sm),
            _ContactCompact(controller: controller),
          ],
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.navy600, height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  '© ${DateTime.now().year} ${AppStrings.appName}. '
                  '${AppStrings.copyright}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textOnDarkMuted,
                    fontSize: 10,
                  ),
                ),
              ),
              if (controller.currencyCode.isNotEmpty)
                Text(
                  controller.currencyCode,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textOnDarkMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final socials = _socialLinks(controller);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.smAll,
          ),
          clipBehavior: Clip.antiAlias,
          child: controller.logoUrl?.trim().isNotEmpty == true
              ? NetworkImageView(
                  url: controller.logoUrl!,
                  fit: BoxFit.contain,
                  icon: Icons.laptop_mac_outlined,
                )
              : const Icon(
                  Icons.laptop_mac,
                  color: AppColors.navy800,
                  size: 22,
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.appName,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              Text(
                AppStrings.appTagline,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnDarkMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (socials.isNotEmpty)
          Row(
            children: [
              for (final (label, icon, uri) in socials)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Tooltip(
                    message: label,
                    child: InkWell(
                      onTap: () => _launch(uri),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.navy800,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 16,
                          color: AppColors.textOnDark,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// Horarios en dos columnas para ocupar poco alto.
class _HoursCompact extends StatelessWidget {
  const _HoursCompact({required this.horarios});

  final List<HorarioAtencion> horarios;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pairs = <(HorarioAtencion, HorarioAtencion?)>[];
    for (var i = 0; i < horarios.length; i += 2) {
      pairs.add((
        horarios[i],
        i + 1 < horarios.length ? horarios[i + 1] : null,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.openingHours,
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.blue400,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        for (final (first, second) in pairs)
          Row(
            children: [
              Expanded(child: _HourCell(horario: first)),
              Expanded(
                child: second == null
                    ? const SizedBox.shrink()
                    : _HourCell(horario: second),
              ),
            ],
          ),
      ],
    );
  }
}

class _HourCell extends StatelessWidget {
  const _HourCell({required this.horario});

  final HorarioAtencion horario;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Text(
        '${horario.nombreDia}: ${horario.horarioFormateado}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textOnDarkMuted,
          height: 1.3,
        ),
      ),
    );
  }
}

class _ContactCompact extends StatelessWidget {
  const _ContactCompact({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final email = controller.supportEmail?.trim() ?? '';
    final digits = (controller.whatsappNumber ?? '').replaceAll(
      RegExp(r'\D'),
      '',
    );

    return Row(
      children: [
        if (email.isNotEmpty)
          Expanded(
            child: InkWell(
              onTap: () => _launch(Uri.parse('mailto:$email')),
              borderRadius: AppRadius.smAll,
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 16,
                    color: AppColors.blue400,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (email.isNotEmpty && digits.isNotEmpty)
          const SizedBox(width: AppSpacing.sm),
        if (digits.isNotEmpty)
          Tooltip(
            message: AppStrings.writeOnWhatsApp,
            child: FilledButton.icon(
              onPressed: () => _launch(Uri.parse('https://wa.me/$digits')),
              icon: const Icon(Icons.chat, size: 15),
              label: const Text(AppStrings.whatsappLabel),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs + 2,
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ClosedTag extends StatelessWidget {
  const _ClosedTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: AppRadius.smAll,
      ),
      child: const Text(
        AppStrings.temporarilyClosed,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.warning,
        ),
      ),
    );
  }
}

List<(String, IconData, Uri)> _socialLinks(SettingsController controller) {
  final settings = controller.settings;
  if (settings == null) return const [];
  return [
    (
      'Instagram',
      Icons.camera_alt_outlined,
      _socialUri('instagram', settings.socialInstagram),
    ),
    (
      'Facebook',
      Icons.facebook,
      _socialUri('facebook', settings.socialFacebook),
    ),
    (
      'TikTok',
      Icons.music_note,
      _socialUri('tiktok', settings.socialTiktok),
    ),
  ]
      .where((entry) => entry.$3 != null)
      .map((entry) => (entry.$1, entry.$2, entry.$3!))
      .toList();
}

Uri? _socialUri(String platform, String value) {
  final raw = value.trim();
  if (raw.isEmpty) return null;
  if (raw.startsWith('http')) return Uri.tryParse(raw);
  final handle = raw.replaceFirst('@', '');
  switch (platform) {
    case 'instagram':
      return Uri.tryParse('https://instagram.com/$handle');
    case 'facebook':
      return Uri.tryParse('https://facebook.com/$handle');
    case 'tiktok':
      return Uri.tryParse('https://tiktok.com/@$handle');
    default:
      return null;
  }
}

Future<void> _launch(Uri uri) async {
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}
