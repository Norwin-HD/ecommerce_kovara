import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../widgets/common/network_image_view.dart';

/// Banner superior del home con imagen de la tienda (hero_banner_url).
class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, this.bannerUrl, this.logoUrl});

  final String? bannerUrl;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasBanner = bannerUrl?.trim().isNotEmpty == true;

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasBanner)
            NetworkImageView(url: bannerUrl!, icon: Icons.laptop_mac_outlined)
          else
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy700, AppColors.navy900],
                ),
              ),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE60A1628)],
                stops: [0.35, 1],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            bottom: AppSpacing.lg,
            right: AppSpacing.lg,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.mdAll,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: logoUrl?.trim().isNotEmpty == true
                      ? NetworkImageView(url: logoUrl!, fit: BoxFit.contain)
                      : const Icon(
                          Icons.laptop_mac,
                          color: AppColors.navy800,
                          size: 30,
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                      Text(
                        AppStrings.appTagline,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnDarkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Aviso de "temporalmente cerrado" basado en general settings.
class ClosedNoticeBanner extends StatelessWidget {
  const ClosedNoticeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront, color: AppColors.warning, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              AppStrings.temporarilyClosed,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
