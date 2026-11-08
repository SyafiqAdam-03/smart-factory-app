import 'package:smart_factory_qc/domain/models/inventory.dart';

/// Immutable ledger contract. There is deliberately NO update or delete
/// method: the type system makes mutation of history impossible.
/// The server enforces the same rule (no UPDATE/DELETE grants on the table).
abstract interface class StockMovementRepository {
  Future<void> append(StockMovement movement);
  Future<List<StockMovement>> history({String? itemId, String? batchNumber});
}
