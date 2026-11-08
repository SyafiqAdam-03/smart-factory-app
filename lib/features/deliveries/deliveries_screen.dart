import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/utils/format.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';
import 'package:smart_factory_qc/core/widgets/status_badge.dart';
import 'package:smart_factory_qc/domain/models/delivery.dart';
import 'package:smart_factory_qc/features/deliveries/delivery_detail_screen.dart';
import 'package:smart_factory_qc/features/shared/providers/app_state.dart';

class DeliveriesScreen extends ConsumerWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(deliveryFilterProvider);
    final deliveries = ref.watch(filteredDeliveriesProvider);
    final reviewCount =
        deliveries.where((delivery) => delivery.needsReview).length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deliveries'),
            SizedBox(height: 2),
            Text(
              'Incoming materials • Today, 18 Oct',
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
                const SectionLabel('Find delivery'),
                const SizedBox(height: AppSpacing.s8),
                TextField(
                  onChanged: ref.read(deliveryFilterProvider.notifier).setQuery,
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(
                    hintText: 'Search batch or supplier',
                    suffixIcon:
                        Icon(Icons.search_rounded, color: AppColors.slate500),
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in DeliveryStatusFilter.values) ...[
                        if (option != DeliveryStatusFilter.values.first)
                          const SizedBox(width: AppSpacing.s8),
                        _StatusFilterChip(
                          label: switch (option) {
                            DeliveryStatusFilter.all => 'All',
                            DeliveryStatusFilter.passed => 'Passed',
                            DeliveryStatusFilter.quarantined => 'Quarantined',
                            DeliveryStatusFilter.released => 'Released',
                          },
                          selected: filter.status == option &&
                              !filter.needsReviewOnly,
                          onSelected: () => ref
                              .read(deliveryFilterProvider.notifier)
                              .setStatus(option),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '${deliveries.length} recent batches • '
                  '$reviewCount deliveries to review today',
                  style: AppTextStyles.caption.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: deliveries.isEmpty
                ? const Center(
                    child: Text('No deliveries match.',
                        style: AppTextStyles.caption),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      AppSpacing.s8,
                      AppSpacing.s16,
                      AppSpacing.s16,
                    ),
                    itemCount: deliveries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.s12),
                    itemBuilder: (context, index) =>
                        _DeliveryCard(delivery: deliveries[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
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

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.delivery});

  final Delivery delivery;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                DeliveryDetailScreen(batchNumber: delivery.batchNumber),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      delivery.batchNumber,
                      style: AppTextStyles.mono.copyWith(
                        color: AppColors.slate900,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  StatusBadge(delivery.status),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(delivery.supplier,
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 14)),
              const SizedBox(height: AppSpacing.s8),
              Text(
                '${delivery.materialCode} • ${delivery.material}',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.slate600),
              ),
              const SizedBox(height: AppSpacing.s4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${formatQty(delivery.quantity)} ${delivery.unit} · '
                      '${delivery.packaging} · ${delivery.receivedAt}',
                      style: AppTextStyles.caption.copyWith(fontSize: 12),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.slate500),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
