import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.pageBase],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: const _PhaseOneHomePreview(),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhaseOneHomePreview extends StatelessWidget {
  const _PhaseOneHomePreview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('戒烟有数', style: AppTextStyles.pageTitle),
                    SizedBox(height: AppSpacing.xs),
                    Text('真实成本 A1 · Flutter Phase 1',
                        style: AppTextStyles.label),
                  ],
                ),
              ),
              Container(
                height: AppSpacing.iconButton,
                width: AppSpacing.iconButton,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMint,
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                child: const Icon(Icons.info_outline,
                    color: AppColors.primary, size: 19),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('肺部负担指数', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.xs),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('68', style: AppTextStyles.metricNumber),
              SizedBox(width: AppSpacing.xs),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('/100', style: AppTextStyles.bodyStrong),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.riskSoft,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: AppColors.risk.withValues(alpha: 0.22)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '当日危害警示分用于行为干预，不代表医学诊断。',
                    style: AppTextStyles.bodyStrong,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Image.asset(
              'assets/images/human-lungs-nih.png',
              height: 230,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          const Row(
            children: [
              Expanded(child: _MetricTile(label: '真实日耗', value: '¥8.4')),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricTile(label: '健康负债', value: '1.7小时')),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('取出一支'),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.bodyStrong, maxLines: 1),
        ],
      ),
    );
  }
}
