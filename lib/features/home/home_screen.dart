import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/utils/format.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';
import 'package:smart_factory_qc/core/widgets/status_badge.dart';
import 'package:smart_factory_qc/data/dummy_data.dart';
import 'package:smart_factory_qc/domain/models/activity_entry.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';
import 'package:smart_factory_qc/domain/stock_calculator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onScan,
    required this.onNewInspection,
  });

  final VoidCallback onScan;
  final VoidCallback onNewInspection;

  @override
  Widget build(BuildContext context) {
    final deliveries = DummyData.deliveries;
    final toReview = deliveries.where((d) => d.needsReview).length;
    final quarantined =
        deliveries.where((d) => d.status == BatchStatus.quarantined).length;
    final lowStock = DummyData.inventoryItems
        .where((i) => isLowStock(i, DummyData.stockLevels))
        .length;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SHIFT A  ·  LINE 2',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.slate400,
              ),
            ),
            SizedBox(height: 2),
            Text('Good morning, A. Rahman'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          const SectionLabel('Today'),
          const SizedBox(height: AppSpacing.s8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _SummaryTile(
                    label: 'Deliveries to review',
                    value: toReview,
                    color: AppColors.accent,
                    icon: Icons.local_shipping_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _SummaryTile(
                    label: 'Quarantined batches',
                    value: quarantined,
                    color: AppColors.quarantinedText,
                    icon: Icons.warning_amber_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _SummaryTile(
                    label: 'Low-stock items',
                    value: lowStock,
                    color: AppColors.failedText,
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const SectionLabel('Quick actions'),
          const SizedBox(height: AppSpacing.s8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSpacing.primaryButtonHeight,
                  child: FilledButton.icon(
                    onPressed: onScan,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: const Text('Scan barcode'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: SizedBox(
                  height: AppSpacing.primaryButtonHeight,
                  child: OutlinedButton.icon(
                    onPressed: onNewInspection,
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('New inspection'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          const SectionLabel('Recent activity'),
          const SizedBox(height: AppSpacing.s8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < DummyData.activity.length; i++) ...[
                  if (i > 0) const Divider(),
                  _ActivityRow(entry: DummyData.activity[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final int value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: AppSpacing.s8),
              Text('$value', style: AppTextStyles.bigNumber.copyWith(color: color)),
              const SizedBox(height: AppSpacing.s4),
              SectionLabel(label, maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusBackground(entry.status),
                borderRadius: BorderRadius.circular(AppSpacing.radius),
              ),
              child: Icon(
                statusIcon(entry.status),
                size: 22,
                color: statusForeground(entry.status),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title, style: AppTextStyles.bodyStrong),
                  const SizedBox(height: 2),
                  Text(entry.reference, style: AppTextStyles.mono),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(formatAgo(entry.minutesAgo), style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
