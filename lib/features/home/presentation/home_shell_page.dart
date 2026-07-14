import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  static const int _dailyLimit = 5;
  static const double _unitCost = 2.1;
  static const int _assetTar = 8;

  int _stockCount = 17;
  int _todayTaken = 4;
  final List<_LedgerItem> _ledger = [
    const _LedgerItem(action: '取出', time: '17:36', brand: '南京 炫赫门', tar: 10),
    const _LedgerItem(action: '取出', time: '14:15', brand: '利群 西子', tar: 11),
    const _LedgerItem(action: '取出', time: '10:23', brand: '云烟 细支', tar: 8),
  ];

  double get _lungScore =>
      _todayTaken <= 0 ? 0 : (50 + (_todayTaken - 1) * (50 / 19)).clamp(0, 100);

  int get _dailyHarmScore {
    final n = _todayTaken;
    if (n <= 0) return 0;
    if (n == 1) return 50;
    if (n <= 4) return (50 + (n - 1) * 6).round();
    if (n <= 9) return (68 + (n - 5) * 3).round();
    if (n <= 19) return (82 + (n - 10) * 1.9).round();
    return 100;
  }

  String get _harmLabel {
    if (_todayTaken <= 0) return '未暴露';
    if (_todayTaken <= 4) return '高危';
    if (_todayTaken <= 9) return '强烈警示';
    if (_todayTaken <= 19) return '极高危';
    return '极端暴露';
  }

  double get _trueCost => _todayTaken * _unitCost;
  double get _netHealth => (100 - _lungScore).clamp(0, 100);
  double get _healthDebtHours => _stockCount * 20 / 60;

  void _returnOne() {
    if (_todayTaken <= 0) return;
    setState(() {
      _todayTaken -= 1;
      _stockCount += 1;
      _ledger.insert(
        0,
        _LedgerItem(
          action: '放回',
          time: _clockLabel(),
          brand: '默认资产',
          tar: -_assetTar,
        ),
      );
    });
  }

  Future<void> _openTakeSheet() async {
    final result = await showModalBottomSheet<_TakeResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TakeSheet(stockCount: _stockCount),
    );

    if (result == null || _stockCount <= 0) return;

    setState(() {
      _todayTaken += 1;
      _stockCount -= 1;
      _ledger.insert(
        0,
        _LedgerItem(
          action: '取出',
          time: _clockLabel(),
          brand: '云烟 细支',
          tar: _assetTar,
          note: result.note,
        ),
      );
    });
  }

  void _openDailyHarmInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('当日危害说明'),
        content: const Text(
          '当日危害评分基于今日取出支数计算，用于行为反馈和自我管理。非医学诊断，不提供治疗建议。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

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
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg + AppSpacing.bottomNavHeight + safeBottom,
                    ),
                    sliver: SliverList.list(
                      children: [
                        const _HomeHeader(),
                        const SizedBox(height: AppSpacing.md),
                        _HeroCard(
                          score: _dailyHarmScore,
                          label: _harmLabel,
                          lungScore: _lungScore,
                          stockCount: _stockCount,
                          todayTaken: _todayTaken,
                          dailyLimit: _dailyLimit,
                          onInfo: _openDailyHarmInfo,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _MetricGrid(
                          trueCost: _trueCost,
                          netHealth: _netHealth,
                          healthDebtHours: _healthDebtHours,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _TrendCard(todayTaken: _todayTaken),
                        const SizedBox(height: AppSpacing.sm),
                        _ActionRow(
                          canReturn: _todayTaken > 0,
                          onReturn: _returnOne,
                          onTake: _stockCount > 0 ? _openTakeSheet : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _RecentLedger(items: _ledger),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: _BottomNav(safeBottom: safeBottom),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('戒烟有数', style: AppTextStyles.pageTitle),
              SizedBox(height: AppSpacing.xs),
              Text('每一次选择，都是更好的自己。', style: AppTextStyles.label),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceMint.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text('07/03', style: AppTextStyles.bodyStrong),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.score,
    required this.label,
    required this.lungScore,
    required this.stockCount,
    required this.todayTaken,
    required this.dailyLimit,
    required this.onInfo,
  });

  final int score;
  final String label;
  final double lungScore;
  final int stockCount;
  final int todayTaken;
  final int dailyLimit;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '把每一支烟变成看得见的数据',
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              '今日危害评分',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 24,
                                height: 1.08,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          _InfoIconButton(onPressed: onInfo),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$score',
                      style: AppTextStyles.metricNumber.copyWith(
                        color: AppColors.primary,
                        fontSize: 48,
                      ),
                    ),
                    Text(label,
                        style: AppTextStyles.bodyStrong
                            .copyWith(color: AppColors.danger)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            _LungStage(lungScore: lungScore),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              children: [
                Text(
                  '肺部负担指数 ${lungScore.toStringAsFixed(1)}/100',
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '库存 $stockCount 支 · 今日 $todayTaken/$dailyLimit 支',
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoIconButton extends StatelessWidget {
  const _InfoIconButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.iconButton,
      width: AppSpacing.iconButton,
      child: IconButton(
        tooltip: '查看当日危害说明',
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon:
            const Icon(Icons.help_outline, color: AppColors.primary, size: 18),
      ),
    );
  }
}

class _LungStage extends StatelessWidget {
  const _LungStage({required this.lungScore});

  final double lungScore;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.48,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.riskSoft.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(color: AppColors.risk.withValues(alpha: 0.16)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _LungGridPainter()),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.risk.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 14,
              top: 12,
              child: _StageChip('实时渲染'),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '每取出一支\n肺色加深 1.9%',
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/human-lungs-nih.png',
                height: 172,
                fit: BoxFit.contain,
                color: AppColors.risk
                    .withValues(alpha: (lungScore / 170).clamp(0.12, 0.45)),
                colorBlendMode: BlendMode.multiply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(999),
      ),
      child:
          Text(label, style: AppTextStyles.bodyStrong.copyWith(fontSize: 12)),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({
    required this.trueCost,
    required this.netHealth,
    required this.healthDebtHours,
  });

  final double trueCost;
  final double netHealth;
  final double healthDebtHours;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _MetricTile(
                label: '真实日耗', value: '¥${trueCost.toStringAsFixed(1)}')),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
            child: _MetricTile(label: '健康净值', value: '${netHealth.round()}%')),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
            child: _MetricTile(
                label: '健康负债',
                value: '${healthDebtHours.toStringAsFixed(1)}小时')),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label, maxLines: 1),
            const SizedBox(height: AppSpacing.xs),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTextStyles.bodyStrong.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.todayTaken});

  final int todayTaken;

  @override
  Widget build(BuildContext context) {
    final values = [2, 3, 2, 4, 3, 4, todayTaken];
    final previous = values[values.length - 2];
    final state = todayTaken == previous
        ? '稳定'
        : todayTaken > previous
            ? '上升'
            : '下降';

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.sm,
          AppSpacing.xxs,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '7 日危害趋势',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 17,
                      height: 1.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _StageChip(state),
              ],
            ),
            SizedBox(
              height: 48,
              child: CustomPaint(
                painter: _TrendPainter(values),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.canReturn,
    required this.onReturn,
    required this.onTake,
  });

  final bool canReturn;
  final VoidCallback onReturn;
  final VoidCallback? onTake;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: canReturn ? onReturn : null,
            icon: const Icon(Icons.undo_rounded),
            label: const Text('放回库存'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FilledButton.icon(
            onPressed: onTake,
            icon: const Icon(Icons.monitor_heart_outlined),
            label: const Text('取出一支'),
          ),
        ),
      ],
    );
  }
}

class _RecentLedger extends StatelessWidget {
  const _RecentLedger({required this.items});

  final List<_LedgerItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '最近账本',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text('今日',
                    style:
                        AppTextStyles.label.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            ...items.take(3).map((item) => _LedgerRow(item: item)),
          ],
        ),
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.item});

  final _LedgerItem item;

  @override
  Widget build(BuildContext context) {
    final isReturn = item.action == '放回';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            isReturn ? Icons.keyboard_return_rounded : Icons.add_circle_outline,
            size: 18,
            color: isReturn ? AppColors.primary : AppColors.risk,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              '${item.time} · ${item.action} · ${item.brand}',
              style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${item.tar >= 0 ? item.tar : -item.tar}mg',
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.safeBottom});

  final double safeBottom;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.98),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 8, 14, 8 + safeBottom),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(icon: Icons.home_outlined, label: '首页', active: true),
            _NavItem(icon: Icons.inventory_2_outlined, label: '资产'),
            _QuickNavButton(),
            _NavItem(icon: Icons.menu_book_outlined, label: '账本'),
            _NavItem(icon: Icons.person_outline, label: '我的'),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.icon, required this.label, this.active = false});

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.muted;
    return SizedBox(
      width: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? AppColors.surfaceMint : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickNavButton extends StatelessWidget {
  const _QuickNavButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 34),
        ),
        const SizedBox(height: 2),
        const Text(
          '快记',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TakeSheet extends StatefulWidget {
  const _TakeSheet({required this.stockCount});

  final int stockCount;

  @override
  State<_TakeSheet> createState() => _TakeSheetState();
}

class _TakeSheetState extends State<_TakeSheet> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '记录取出',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '当前可取库存 ${widget.stockCount} 支',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.pageBase,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                '云烟 细支 · 8mg 焦油 · ¥2.1/支',
                style: AppTextStyles.bodyStrong,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '补充备注（选填）',
                hintText: '例如：饭后、压力、社交场景',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.stockCount > 0
                    ? () => Navigator.of(context).pop(
                          _TakeResult(note: _noteController.text.trim()),
                        )
                    : null,
                icon: const Icon(Icons.monitor_heart_outlined),
                label: const Text('记录取出'),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              '触发严厉警示时会连发手机通知栏提醒，记录仍会写入账本。',
              style: AppTextStyles.label,
            ),
          ],
        ),
      ),
    );
  }
}

class _LungGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.risk.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += size.width / 9) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += size.height / 7) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 1.3;
    canvas.drawCircle(
        size.center(Offset.zero), size.shortestSide * 0.32, circlePaint);
    canvas.drawCircle(
        size.center(Offset.zero), size.shortestSide * 0.44, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.values);

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * 0.72;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(Offset(8, baseY), Offset(size.width - 8, baseY), gridPaint);

    final maxValue = values.reduce((a, b) => a > b ? a : b).clamp(1, 20);
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = 18 + i * ((size.width - 36) / (values.length - 1));
      final y = baseY - (values[i] / maxValue) * size.height * 0.34;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    final shadowPaint = Paint()
      ..color = AppColors.risk.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 7;
    final pathPaint = Paint()
      ..color = AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, pathPaint);

    final dotPaint = Paint()..color = AppColors.danger;
    for (final point in points) {
      canvas.drawCircle(point, 3, dotPaint);
      canvas.drawCircle(point, 1.4, Paint()..color = AppColors.surface);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.values != values;
}

class _LedgerItem {
  const _LedgerItem({
    required this.action,
    required this.time,
    required this.brand,
    required this.tar,
    this.note = '',
  });

  final String action;
  final String time;
  final String brand;
  final int tar;
  final String note;
}

class _TakeResult {
  const _TakeResult({required this.note});

  final String note;
}

String _clockLabel() {
  final now = TimeOfDay.now();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
