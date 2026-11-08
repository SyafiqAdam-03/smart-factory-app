import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/utils/format.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';
import 'package:smart_factory_qc/core/widgets/status_badge.dart';
import 'package:smart_factory_qc/data/dummy_data.dart';
import 'package:smart_factory_qc/domain/models/inventory.dart';
import 'package:smart_factory_qc/domain/stock_calculator.dart';
import 'package:smart_factory_qc/features/shared/providers/app_state.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(inventoryFilterProvider);
    final items = ref.watch(filteredInventoryProvider);
    final lowCount =
        items.where((item) => isLowStock(item, DummyData.stockLevels)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inventory'),
            SizedBox(height: 2),
            Text(
              'Materials • Assembly plant 01',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.slate300,
              ),
            ),
          ],
        ),
      ),
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
                const SectionLabel('Find material'),
                const SizedBox(height: AppSpacing.s8),
                TextField(
                  onChanged:
                      ref.read(inventoryFilterProvider.notifier).setQuery,
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(
                    hintText: 'Search item or rack',
                    suffixIcon:
                        Icon(Icons.search_rounded, color: AppColors.slate500),
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Row(
                  children: [
                    _InventoryFilterChip(
                      label: 'All items',
                      selected: !filter.lowStockOnly,
                      onSelected: () => ref
                          .read(inventoryFilterProvider.notifier)
                          .setLowStockOnly(false),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    _InventoryFilterChip(
                      label: 'Low stock',
                      selected: filter.lowStockOnly,
                      onSelected: () => ref
                          .read(inventoryFilterProvider.notifier)
                          .setLowStockOnly(true),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '${items.length} items • $lowCount at or below reorder level',
                  style: AppTextStyles.caption.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('No inventory items match.',
                        style: AppTextStyles.caption),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      AppSpacing.s8,
                      AppSpacing.s16,
                      AppSpacing.s16,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.s12),
                    itemBuilder: (context, index) => _InventoryCard(
                      item: items[index],
                      levels: DummyData.stockLevels,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _InventoryFilterChip extends StatelessWidget {
  const _InventoryFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onSelected(),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.white : AppColors.slate700,
        ),
        backgroundColor: AppColors.white,
        selectedColor: AppColors.navy,
        side: BorderSide(color: selected ? AppColors.navy : AppColors.slate300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
      );
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.item, required this.levels});

  final InventoryItem item;
  final List<StockLevel> levels;

  @override
  Widget build(BuildContext context) {
    final total = totalStock(item.id, levels);
    final low = total <= item.reorderLevel;
    final fill = item.targetLevel == 0
        ? 0.0
        : (total / item.targetLevel).clamp(0.0, 1.0);
    final locations = levels.where((level) => level.itemId == item.id).toList();
    final primaryLocation =
        locations.isEmpty ? 'No rack assigned' : locations.first.locationId;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showInventoryDetails(context, item, levels),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.sku,
                      style: AppTextStyles.mono.copyWith(
                        color: AppColors.slate900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (low)
                    const PillBadge(
                      label: 'Low stock',
                      foreground: AppColors.slate900,
                      background: AppColors.slate200,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                    ),
                  ),
                  Text(primaryLocation,
                      style: AppTextStyles.caption.copyWith(fontSize: 11)),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${formatQty(total)} ${item.unit}',
                    style: AppTextStyles.bigNumber.copyWith(fontSize: 20),
                  ),
                  const Spacer(),
                  Text(
                    'Reorder ≤ ${formatQty(item.reorderLevel)} ${item.unit}',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              Semantics(
                label: 'Stock level ${(fill * 100).round()} percent of target',
                child: LinearProgressIndicator(
                  value: fill,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: AppColors.slate200,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showInventoryDetails(
  BuildContext context,
  InventoryItem item,
  List<StockLevel> levels,
) {
  final locations = levels.where((level) => level.itemId == item.id).toList();
  final total = totalStock(item.id, levels);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppSpacing.radius)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Row(
              children: [
                Expanded(child: Text(item.sku, style: AppTextStyles.title)),
                if (total <= item.reorderLevel)
                  const PillBadge(
                    label: 'Low stock',
                    foreground: AppColors.slate900,
                    background: AppColors.slate200,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(item.name, style: AppTextStyles.bodyStrong),
            const SizedBox(height: AppSpacing.s16),
            _InventoryDetailLine(
              label: 'Current stock',
              value: '${formatQty(total)} ${item.unit}',
            ),
            _InventoryDetailLine(
              label: 'Reorder level',
              value: '${formatQty(item.reorderLevel)} ${item.unit}',
            ),
            _InventoryDetailLine(
              label: 'Supplier',
              value: item.supplier,
            ),
            _InventoryDetailLine(
              label: 'Specifications',
              value: item.specifications,
            ),
            const SectionLabel('Rack locations'),
            const SizedBox(height: AppSpacing.s8),
            for (final location in locations)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(location.locationId,
                            style: AppTextStyles.body)),
                    Text(
                      '${formatQty(location.quantity)} ${item.unit}',
                      style: AppTextStyles.bodyStrong,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.s8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _InventoryDetailLine extends StatelessWidget {
  const _InventoryDetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(label),
            const SizedBox(height: AppSpacing.s4),
            Text(value, style: AppTextStyles.body),
          ],
        ),
      );
}
