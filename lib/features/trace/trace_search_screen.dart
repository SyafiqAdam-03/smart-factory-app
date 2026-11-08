import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';
import 'package:smart_factory_qc/core/widgets/status_badge.dart';
import 'package:smart_factory_qc/domain/models/audit_event.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';
import 'package:smart_factory_qc/features/shared/providers/app_state.dart';
import 'package:smart_factory_qc/features/shared/widgets/app_bottom_nav_bar.dart';

class TraceSearchScreen extends ConsumerStatefulWidget {
  const TraceSearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<TraceSearchScreen> createState() => _TraceSearchScreenState();
}

class _TraceSearchScreenState extends ConsumerState<TraceSearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final query = widget.initialQuery;
    if (query != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(traceQueryProvider.notifier).state = query;
      });
    }
    _searchController = TextEditingController(
      text: widget.initialQuery ?? 'B-1007',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(traceQueryProvider);
    final events = ref.watch(filteredAuditTrailProvider);
    final recordId = query.trim().isEmpty ? 'Search results' : query.trim();
    final status = ref
        .watch(deliveryRepositoryProvider)
        .where((delivery) => delivery.batchNumber == recordId)
        .firstOrNull
        ?.status;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trace a record'),
            SizedBox(height: 2),
            Text(
              'BATCH HISTORY • 18 OCT 2026',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.slate300,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          const SectionLabel('Search by batch or serial'),
          const SizedBox(height: 4),
          TextField(
            controller: _searchController,
            onChanged: (value) =>
                ref.read(traceQueryProvider.notifier).state = value,
            style: AppTextStyles.body.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search by batch or serial',
              suffixIcon: IconButton(
                tooltip: 'Search',
                onPressed: () => ref.read(traceQueryProvider.notifier).state =
                    _searchController.text,
                icon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  recordId,
                  style: AppTextStyles.mono.copyWith(
                    color: AppColors.slate900,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (status != null) StatusBadge(status),
            ],
          ),
          const SizedBox(height: 8),
          const SectionLabel('Audit trail · newest first'),
          const SizedBox(height: 8),
          if (events.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No audit events match this record.',
                  style: AppTextStyles.caption,
                ),
              ),
            )
          else
            for (var index = 0; index < events.length; index++)
              _AuditTimelineItem(
                event: events[index],
                isLast: index == events.length - 1,
              ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: AppTab.deliveries.index,
        onTap: (index) => returnToTab(context, ref, AppTab.values[index]),
      ),
    );
  }
}

class _AuditTimelineItem extends StatelessWidget {
  const _AuditTimelineItem({required this.event, required this.isLast});

  final AuditEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final foreground = switch (event.status) {
      BatchStatus.passed => AppColors.passed,
      BatchStatus.quarantined => AppColors.quarantined,
      BatchStatus.failed => AppColors.failed,
      BatchStatus.released => AppColors.accent,
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Icon(event.icon, size: 18, color: foreground),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: AppColors.slate300),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.time,
                        style: AppTextStyles.mono.copyWith(
                          color: AppColors.slate500,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.title,
                          style:
                              AppTextStyles.bodyStrong.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
