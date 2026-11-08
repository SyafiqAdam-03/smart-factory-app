import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_factory_qc/data/dummy_data.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';
import 'package:smart_factory_qc/domain/stock_calculator.dart';
import 'package:smart_factory_qc/features/shared/providers/app_state.dart';

void main() {
  test('delivery search and status filters compose', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(deliveryFilterProvider.notifier)
        .setQuery('Meridian Polymers');
    expect(container.read(filteredDeliveriesProvider), hasLength(2));

    container
        .read(deliveryFilterProvider.notifier)
        .setStatus(DeliveryStatusFilter.quarantined);
    final filtered = container.read(filteredDeliveriesProvider);
    expect(filtered, hasLength(1));
    expect(filtered.single.batchNumber, 'B-1007');
    expect(filtered.single.status, BatchStatus.quarantined);
  });

  test('inventory search includes rack and low-stock filtering', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(filteredInventoryProvider), hasLength(24));
    container.read(inventoryFilterProvider.notifier).setQuery('Rack A-03');
    expect(container.read(filteredInventoryProvider).single.sku, 'RM-002');

    container.read(inventoryFilterProvider.notifier).setQuery('');
    container.read(inventoryFilterProvider.notifier).setLowStockOnly(true);
    final lowStock = container.read(filteredInventoryProvider);
    expect(lowStock, hasLength(3));
    expect(
      lowStock.every((item) => isLowStock(item, DummyData.stockLevels)),
      isTrue,
    );
  });
}
