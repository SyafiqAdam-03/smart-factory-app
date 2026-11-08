import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/utils/format.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';
import 'package:smart_factory_qc/core/widgets/status_badge.dart';
import 'package:smart_factory_qc/data/dummy_data.dart';
import 'package:smart_factory_qc/domain/models/inventory.dart';
import 'package:smart_factory_qc/domain/stock_calculator.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _query = '';
  bool _lowOnly = false;

  @override
  Widget build(BuildContext context) {
    const levels = DummyData.stockLevels;

    final q = _query.trim().toLowerCase();
    final items = DummyData.inventoryItems.where((item) {
      final matches = q.isEmpty ||
          item.name.toLowerCase().contains(q) ||
          item.sku.toLowerCase().contains(q);
      return matches && (!_lowOnly || isLowStock(item, levels));
    }).toList()
      // Low-stock items first, then alphabetical.
      ..sort((a, b) {
        final la = isLowStock(a, levels) ? 0 : 1;
        final lb = isLowStock(b, levels) ? 0 : 1;
        return la != lb ? la.compareTo(lb) : a.name.compareTo(b.name);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s16,
              AppSpacing.s16,
              AppSpacing.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(
                    hintText: 'Search item or SKU',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.slate500),
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                FilterChip(
                  label: const Text('Low stock only'),
                  selected: _lowOnly,
                  onSelected: (v) => setState(() => _lowOnly = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('No items match.', style: AppTextStyles.caption),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      AppSpacing.s8,
                      AppSpacing.s16,
                      AppSpacing.s16,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s12),
                    itemBuilder: (_, i) => _InventoryCard(item: items[i], levels: levels),
                  ),
          ),
        ],
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.item, required this.levels});

  final InventoryItem item;
  final List<StockLevel> levels;

  @override
  Widget build(BuildContext context) {
    // Total is derived by summing per-location stock levels, never stored.
    final total = totalStock(item.id, levels);
    final low = total <= item.reorderLevel;
    final fill = (total / item.targetLevel).clamp(0.0, 1.0);
    final barColor = low ? AppColors.quarantined : AppColors.accent;
    final locations = levels.where((l) => l.itemId == item.id).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
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
                      Text(item.name, style: AppTextStyles.bodyStrong),
                      const SizedBox(height: 2),
                      Text(item.sku, style: AppTextStyles.mono),
                    ],
                  ),
                ),
                if (low) ...[
                  const SizedBox(width: AppSpacing.s8),
                  const PillBadge(
                    label: 'Low stock',
                    foreground: AppColors.quarantinedText,
                    background: AppColors.quarantinedSoft,
                    icon: Icons.warning_amber_rounded,
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(formatQty(total), style: AppTextStyles.bigNumber),
                const SizedBox(width: AppSpacing.s8),
                Text(item.unit, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.slate500)),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            Semantics(
              label: 'Stock level ${(fill * 100).round()} percent of target',
              child: LinearProgressIndicator(
                value: fill,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: AppColors.slate200,
                color: barColor,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionLabel('Reorder at ${formatQty(item.reorderLevel)} ${item.unit}'),
                SectionLabel('Target ${formatQty(item.targetLevel)}'),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            const Divider(),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s16,
              runSpacing: AppSpacing.s4,
              children: [
                for (final l in locations)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${l.locationId}  ',
                          style: AppTextStyles.mono.copyWith(color: AppColors.slate500),
                        ),
                        TextSpan(
                          text: formatQty(l.quantity),
                          style: AppTextStyles.mono.copyWith(
                            color: AppColors.slate900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
