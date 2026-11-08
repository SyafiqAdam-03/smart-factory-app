import 'package:smart_factory_qc/domain/models/batch_status.dart';

class Delivery {
  const Delivery({
    required this.batchNumber,
    required this.supplier,
    required this.material,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.needsReview,
  });

  final String batchNumber;
  final String supplier;
  final String material;
  final double quantity;
  final String unit;
  final BatchStatus status;
  final bool needsReview;
}
