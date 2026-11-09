import 'package:flutter/material.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

class _Benefit {
  const _Benefit(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}

/// Franja de beneficios comunes de ecommerce (2x2).
class BenefitsStrip extends StatelessWidget {
  const BenefitsStrip({super.key});

  static const _benefits = [
    _Benefit(
      Icons.local_shipping_outlined,
      AppStrings.benefitShippingTitle,
      AppStrings.benefitShippingDesc,
    ),
    _Benefit(
      Icons.verified_outlined,
      AppStrings.benefitGuaranteeTitle,
      AppStrings.benefitGuaranteeDesc,
    ),
    _Benefit(
      Icons.support_agent_outlined,
      AppStrings.benefitSupportTitle,
      AppStrings.benefitSupportDesc,
    ),
    _Benefit(
      Icons.payments_outlined,
      AppStrings.benefitPaymentTitle,
      AppStrings.benefitPaymentDesc,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.outline),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _BenefitItem(benefit: _benefits[0])),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _BenefitItem(benefit: _benefits[1])),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _BenefitItem(benefit: _benefits[2])),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _BenefitItem(benefit: _benefits[3])),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({required this.benefit});

  final _Benefit benefit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.blue50,
            shape: BoxShape.circle,
          ),
          child: Icon(benefit.icon, size: 18, color: AppColors.navy700),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                benefit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                benefit.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
