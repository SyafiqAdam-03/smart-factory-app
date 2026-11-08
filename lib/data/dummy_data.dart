import 'package:smart_factory_qc/domain/models/activity_entry.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';
import 'package:smart_factory_qc/domain/models/delivery.dart';
import 'package:smart_factory_qc/domain/models/inventory.dart';

/// Temporary in-memory data. Replace with repository implementations
/// that talk to the API tier.
class DummyData {
  DummyData._();

  static const deliveries = <Delivery>[
    Delivery(
      batchNumber: 'B-240918-01',
      supplier: 'Nordic Steel AS',
      material: 'Steel coil 1.2 mm',
      quantity: 4800,
      unit: 'kg',
      status: BatchStatus.passed,
      needsReview: false,
    ),
    Delivery(
      batchNumber: 'B-240918-02',
      supplier: 'Apex Polymers',
      material: 'PA66 granules GF30',
      quantity: 1250,
      unit: 'kg',
      status: BatchStatus.quarantined,
      needsReview: true,
    ),
    Delivery(
      batchNumber: 'B-240918-03',
      supplier: 'Delta Fasteners',
      material: 'M8 hex bolts',
      quantity: 12000,
      unit: 'pcs',
      status: BatchStatus.quarantined,
      needsReview: true,
    ),
    Delivery(
      batchNumber: 'B-240917-07',
      supplier: 'AluCast GmbH',
      material: 'Aluminium ingot 6061',
      quantity: 2200,
      unit: 'kg',
      status: BatchStatus.released,
      needsReview: false,
    ),
    Delivery(
      batchNumber: 'B-240917-05',
      supplier: 'SealTech Ltd',
      material: 'Hydraulic seal kit',
      quantity: 150,
      unit: 'pcs',
      status: BatchStatus.passed,
      needsReview: true,
    ),
  ];

  static const activity = <ActivityEntry>[
    ActivityEntry(
      title: 'Batch released',
      reference: 'B-240918-01',
      status: BatchStatus.released,
      minutesAgo: 12,
    ),
    ActivityEntry(
      title: 'Batch quarantined',
      reference: 'B-240918-02',
      status: BatchStatus.quarantined,
      minutesAgo: 47,
    ),
    ActivityEntry(
      title: 'Inspection failed',
      reference: 'SN-77120431',
      status: BatchStatus.failed,
      minutesAgo: 95,
    ),
    ActivityEntry(
      title: 'Inspection signed off',
      reference: 'SN-77120398',
      status: BatchStatus.passed,
      minutesAgo: 130,
    ),
    ActivityEntry(
      title: 'Delivery inspected',
      reference: 'B-240917-07',
      status: BatchStatus.passed,
      minutesAgo: 1560,
    ),
  ];

  static const inventoryItems = <InventoryItem>[
    InventoryItem(id: 'i1', sku: 'RM-STL-012', name: 'Steel coil 1.2 mm', unit: 'kg', reorderLevel: 2000, targetLevel: 10000),
    InventoryItem(id: 'i2', sku: 'RM-PA6-GF30', name: 'PA66 granules GF30', unit: 'kg', reorderLevel: 800, targetLevel: 4000),
    InventoryItem(id: 'i3', sku: 'HW-BLT-M8', name: 'M8 hex bolts', unit: 'pcs', reorderLevel: 5000, targetLevel: 20000),
    InventoryItem(id: 'i4', sku: 'SP-SEL-045', name: 'Hydraulic seal kit', unit: 'pcs', reorderLevel: 40, targetLevel: 200),
    InventoryItem(id: 'i5', sku: 'RM-ALU-6061', name: 'Aluminium ingot 6061', unit: 'kg', reorderLevel: 1500, targetLevel: 6000),
    InventoryItem(id: 'i6', sku: 'CS-OIL-020', name: 'Cutting oil 20 L', unit: 'pcs', reorderLevel: 10, targetLevel: 60),
  ];

  // i2 is below reorder level; i4 sits exactly AT it (still counts as low).
  static const stockLevels = <StockLevel>[
    StockLevel(itemId: 'i1', locationId: 'WH-A', quantity: 4200),
    StockLevel(itemId: 'i1', locationId: 'WH-B', quantity: 3100),
    StockLevel(itemId: 'i1', locationId: 'LINE-1', quantity: 900),
    StockLevel(itemId: 'i2', locationId: 'WH-A', quantity: 400),
    StockLevel(itemId: 'i2', locationId: 'LINE-1', quantity: 250),
    StockLevel(itemId: 'i3', locationId: 'WH-A', quantity: 9800),
    StockLevel(itemId: 'i3', locationId: 'WH-B', quantity: 6200),
    StockLevel(itemId: 'i3', locationId: 'LINE-2', quantity: 1500),
    StockLevel(itemId: 'i4', locationId: 'WH-B', quantity: 28),
    StockLevel(itemId: 'i4', locationId: 'LINE-1', quantity: 12),
    StockLevel(itemId: 'i5', locationId: 'WH-A', quantity: 2100),
    StockLevel(itemId: 'i5', locationId: 'WH-B', quantity: 900),
    StockLevel(itemId: 'i6', locationId: 'WH-A', quantity: 34),
    StockLevel(itemId: 'i6', locationId: 'LINE-1', quantity: 8),
  ];
}
