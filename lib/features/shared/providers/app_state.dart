import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/data/dummy_data.dart';
import 'package:smart_factory_qc/domain/models/activity_entry.dart';
import 'package:smart_factory_qc/domain/models/audit_event.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';
import 'package:smart_factory_qc/domain/models/delivery.dart';
import 'package:smart_factory_qc/domain/models/inspection_record.dart';
import 'package:smart_factory_qc/domain/models/inventory.dart';
import 'package:smart_factory_qc/domain/stock_calculator.dart';

enum AppTab { home, deliveries, inventory, profile }

class ActiveTabController extends StateNotifier<AppTab> {
  ActiveTabController() : super(AppTab.home);

  void select(AppTab tab) => state = tab;
}

final activeTabProvider = StateNotifierProvider<ActiveTabController, AppTab>(
  (ref) => ActiveTabController(),
);

void returnToTab(BuildContext context, WidgetRef ref, AppTab tab) {
  ref.read(activeTabProvider.notifier).select(tab);
  Navigator.of(context).popUntil((route) => route.isFirst);
}

class DeliveryRepository extends StateNotifier<List<Delivery>> {
  DeliveryRepository() : super(DummyData.deliveries);

  Delivery? byBatch(String batchNumber) {
    for (final delivery in state) {
      if (delivery.batchNumber == batchNumber) return delivery;
    }
    return null;
  }

  void release(
    String batchNumber, {
    required String note,
    required String authorisedBy,
    required String authorisedAt,
  }) {
    state = [
      for (final delivery in state)
        if (delivery.batchNumber == batchNumber)
          delivery.copyWith(
            status: BatchStatus.released,
            needsReview: false,
            releaseNote: note,
            authorisedBy: authorisedBy,
            authorisedAt: authorisedAt,
          )
        else
          delivery,
    ];
  }

  void keepQuarantined(String batchNumber) {
    state = [
      for (final delivery in state)
        if (delivery.batchNumber == batchNumber)
          delivery.copyWith(status: BatchStatus.quarantined)
        else
          delivery,
    ];
  }
}

final deliveryRepositoryProvider =
    StateNotifierProvider<DeliveryRepository, List<Delivery>>(
  (ref) => DeliveryRepository(),
);

final releaseNoteDraftProvider = StateProvider<String>(
  (ref) => 'M. Chen approved dry-and-retest under EX-042.',
);

enum DeliveryStatusFilter { all, passed, quarantined, released }

class DeliveryFilterState {
  const DeliveryFilterState({
    this.query = '',
    this.status = DeliveryStatusFilter.all,
    this.needsReviewOnly = false,
  });

  final String query;
  final DeliveryStatusFilter status;
  final bool needsReviewOnly;

  DeliveryFilterState copyWith({
    String? query,
    DeliveryStatusFilter? status,
    bool? needsReviewOnly,
  }) =>
      DeliveryFilterState(
        query: query ?? this.query,
        status: status ?? this.status,
        needsReviewOnly: needsReviewOnly ?? this.needsReviewOnly,
      );
}

class DeliveryFilterController extends StateNotifier<DeliveryFilterState> {
  DeliveryFilterController() : super(const DeliveryFilterState());

  void setQuery(String query) => state = state.copyWith(query: query);

  void setStatus(DeliveryStatusFilter status) => state = state.copyWith(
        status: status,
        needsReviewOnly: false,
      );

  void showNeedsReview() => state = const DeliveryFilterState(
        needsReviewOnly: true,
      );

  void showQuarantined() => state = const DeliveryFilterState(
        status: DeliveryStatusFilter.quarantined,
      );
}

final deliveryFilterProvider =
    StateNotifierProvider<DeliveryFilterController, DeliveryFilterState>(
  (ref) => DeliveryFilterController(),
);

final filteredDeliveriesProvider = Provider<List<Delivery>>((ref) {
  final filter = ref.watch(deliveryFilterProvider);
  final records = ref.watch(deliveryRepositoryProvider);
  final query = filter.query.trim().toLowerCase();
  return records.where((delivery) {
    final matchesQuery = query.isEmpty ||
        delivery.batchNumber.toLowerCase().contains(query) ||
        delivery.supplier.toLowerCase().contains(query) ||
        delivery.material.toLowerCase().contains(query) ||
        delivery.materialCode.toLowerCase().contains(query);
    final matchesStatus = filter.status == DeliveryStatusFilter.all ||
        switch (filter.status) {
          DeliveryStatusFilter.all => true,
          DeliveryStatusFilter.passed => delivery.status == BatchStatus.passed,
          DeliveryStatusFilter.quarantined =>
            delivery.status == BatchStatus.quarantined,
          DeliveryStatusFilter.released =>
            delivery.status == BatchStatus.released,
        };
    return matchesQuery &&
        matchesStatus &&
        (!filter.needsReviewOnly || delivery.needsReview);
  }).toList(growable: false);
});

class InspectionDraft {
  const InspectionDraft({
    this.serialNumber = 'SN-20481',
    this.batchNumber = 'B-1007',
    this.machine = 'M-04 · Injection press',
    this.result = BatchStatus.failed,
    this.defectCategory = 'Scratch',
    this.notes = 'Surface scratch, 12 mm, near gate. Sample held for review.',
    this.photoCount = 0,
  });

  final String serialNumber;
  final String batchNumber;
  final String machine;
  final BatchStatus? result;
  final String defectCategory;
  final String notes;
  final int photoCount;

  InspectionDraft copyWith({
    String? serialNumber,
    String? batchNumber,
    String? machine,
    BatchStatus? result,
    String? defectCategory,
    String? notes,
    int? photoCount,
    bool clearResult = false,
  }) =>
      InspectionDraft(
        serialNumber: serialNumber ?? this.serialNumber,
        batchNumber: batchNumber ?? this.batchNumber,
        machine: machine ?? this.machine,
        result: clearResult ? null : result ?? this.result,
        defectCategory: defectCategory ?? this.defectCategory,
        notes: notes ?? this.notes,
        photoCount: photoCount ?? this.photoCount,
      );
}

class InspectionController extends StateNotifier<InspectionDraft> {
  InspectionController() : super(const InspectionDraft());

  void setSerialNumber(String value) =>
      state = state.copyWith(serialNumber: value);
  void setBatchNumber(String value) =>
      state = state.copyWith(batchNumber: value);
  void setMachine(String value) => state = state.copyWith(machine: value);
  void setResult(BatchStatus value) => state = state.copyWith(result: value);
  void setDefectCategory(String value) =>
      state = state.copyWith(defectCategory: value);
  void setNotes(String value) => state = state.copyWith(notes: value);
  void attachPhoto() =>
      state = state.copyWith(photoCount: state.photoCount + 1);
  void reset() => state = const InspectionDraft();
}

final inspectionDraftProvider =
    StateNotifierProvider<InspectionController, InspectionDraft>(
  (ref) => InspectionController(),
);

class InspectionRecordsController
    extends StateNotifier<List<InspectionRecord>> {
  InspectionRecordsController() : super(const []);

  void add(InspectionRecord record) => state = [record, ...state];
}

final inspectionRecordsProvider =
    StateNotifierProvider<InspectionRecordsController, List<InspectionRecord>>(
  (ref) => InspectionRecordsController(),
);

final auditTrailProvider =
    StateNotifierProvider<AuditTrailController, List<AuditEvent>>(
  (ref) => AuditTrailController(),
);

class AuditTrailController extends StateNotifier<List<AuditEvent>> {
  AuditTrailController()
      : super([
          const AuditEvent(
            recordId: 'B-1007',
            time: '09:41',
            title: 'Released by authorised exception',
            description:
                'Maya Chen · EX-042 / Dry-and-retest.\nMoisture still failed: 8.7% (limit ≤ 8.0%).',
            icon: Icons.lock_open_rounded,
            status: BatchStatus.released,
          ),
          const AuditEvent(
            recordId: 'B-1007',
            time: '09:36',
            title: 'QA lead approval signed',
            description:
                'M. Chen approved conditional release.\nNote: dry-and-retest under EX-042.',
            icon: Icons.edit_note_rounded,
            status: BatchStatus.passed,
          ),
          const AuditEvent(
            recordId: 'B-1007',
            time: '09:24',
            title: 'Batch quarantined',
            description:
                'A. Patel · Moisture exceeds limit by\n0.7 percentage points.',
            icon: Icons.shield_outlined,
            status: BatchStatus.quarantined,
          ),
          const AuditEvent(
            recordId: 'B-1007',
            time: '09:22',
            title: 'Receiving checks signed',
            description:
                'A. Patel · Weight & dimension passed.\nMoisture 8.7% — failed.',
            icon: Icons.assignment_turned_in_outlined,
            status: BatchStatus.failed,
          ),
          const AuditEvent(
            recordId: 'SN-20481',
            time: '09:18',
            title: 'Sample inspection signed',
            description:
                'A. Patel · SN-20481 / M-04\nFailed: Scratch, 12 mm near gate.',
            icon: Icons.cancel_outlined,
            status: BatchStatus.failed,
          ),
          const AuditEvent(
            recordId: 'B-1007',
            time: '08:40',
            title: 'Delivery received',
            description:
                'Meridian Polymers · RM-002 / Nylon PA6\n500 kg · 100 × 5 kg bags / Rack A-03',
            icon: Icons.local_shipping_outlined,
            status: BatchStatus.passed,
          ),
        ]);

  void add(AuditEvent event) => state = [
        event,
        ...state.where(
          (existing) =>
              existing.recordId != event.recordId ||
              existing.title != event.title,
        ),
      ];
}

final traceQueryProvider = StateProvider<String>((ref) => 'B-1007');

final filteredAuditTrailProvider = Provider<List<AuditEvent>>((ref) {
  final query = ref.watch(traceQueryProvider).trim().toLowerCase();
  final entries = ref.watch(auditTrailProvider);
  if (query.isEmpty) return entries;
  return entries
      .where((event) =>
          event.recordId.toLowerCase().contains(query) ||
          event.title.toLowerCase().contains(query) ||
          event.description.toLowerCase().contains(query))
      .toList(growable: false);
});

class InventoryFilterState {
  const InventoryFilterState({this.query = '', this.lowStockOnly = false});

  final String query;
  final bool lowStockOnly;

  InventoryFilterState copyWith({String? query, bool? lowStockOnly}) =>
      InventoryFilterState(
        query: query ?? this.query,
        lowStockOnly: lowStockOnly ?? this.lowStockOnly,
      );
}

class InventoryFilterController extends StateNotifier<InventoryFilterState> {
  InventoryFilterController() : super(const InventoryFilterState());

  void setQuery(String query) => state = state.copyWith(query: query);

  void setLowStockOnly(bool value) =>
      state = state.copyWith(lowStockOnly: value);

  void showLowStock() => state = const InventoryFilterState(lowStockOnly: true);
}

final inventoryFilterProvider =
    StateNotifierProvider<InventoryFilterController, InventoryFilterState>(
  (ref) => InventoryFilterController(),
);

final filteredInventoryProvider = Provider<List<InventoryItem>>((ref) {
  final filter = ref.watch(inventoryFilterProvider);
  final query = filter.query.trim().toLowerCase();
  final levels = DummyData.stockLevels;
  final items = DummyData.inventoryItems.where((item) {
    final itemLocations =
        levels.where((level) => level.itemId == item.id).toList();
    final matchesQuery = query.isEmpty ||
        item.sku.toLowerCase().contains(query) ||
        item.name.toLowerCase().contains(query) ||
        itemLocations
            .any((level) => level.locationId.toLowerCase().contains(query));
    return matchesQuery && (!filter.lowStockOnly || isLowStock(item, levels));
  }).toList();
  items.sort((a, b) {
    final aLow = isLowStock(a, levels) ? 0 : 1;
    final bLow = isLowStock(b, levels) ? 0 : 1;
    return aLow != bLow ? aLow.compareTo(bLow) : a.sku.compareTo(b.sku);
  });
  return items;
});

class ActivityController extends StateNotifier<List<ActivityEntry>> {
  ActivityController() : super(DummyData.activity);

  void add(ActivityEntry entry) => state = [entry, ...state];
}

final activityProvider =
    StateNotifierProvider<ActivityController, List<ActivityEntry>>(
  (ref) => ActivityController(),
);
