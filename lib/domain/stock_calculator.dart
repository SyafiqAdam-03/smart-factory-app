import 'package:smart_factory_qc/domain/models/inventory.dart';

/// Total stock is ALWAYS computed from per-location stock levels.
double totalStock(String itemId, Iterable<StockLevel> levels) => levels
    .where((l) => l.itemId == itemId)
    .fold<double>(0, (sum, l) => sum + l.quantity);

/// "At or below" reorder level counts as low stock.
bool isLowStock(InventoryItem item, Iterable<StockLevel> levels) =>
    totalStock(item.id, levels) <= item.reorderLevel;
