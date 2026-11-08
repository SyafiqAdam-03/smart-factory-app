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
    this.materialCode = '',
    this.packaging = '',
    this.receivedAt = '',
    this.inspectionNotes = '',
    this.holdReason = '',
    this.releaseNote = '',
    this.authorisedBy = '',
    this.authorisedAt = '',
  });

  final String batchNumber;
  final String supplier;
  final String material;
  final double quantity;
  final String unit;
  final BatchStatus status;
  final bool needsReview;
  final String materialCode;
  final String packaging;
  final String receivedAt;
  final String inspectionNotes;
  final String holdReason;
  final String releaseNote;
  final String authorisedBy;
  final String authorisedAt;

  Delivery copyWith({
    BatchStatus? status,
    bool? needsReview,
    String? releaseNote,
    String? authorisedBy,
    String? authorisedAt,
  }) =>
      Delivery(
        batchNumber: batchNumber,
        supplier: supplier,
        material: material,
        quantity: quantity,
        unit: unit,
        status: status ?? this.status,
        needsReview: needsReview ?? this.needsReview,
        materialCode: materialCode,
        packaging: packaging,
        receivedAt: receivedAt,
        inspectionNotes: inspectionNotes,
        holdReason: holdReason,
        releaseNote: releaseNote ?? this.releaseNote,
        authorisedBy: authorisedBy ?? this.authorisedBy,
        authorisedAt: authorisedAt ?? this.authorisedAt,
      );
}
