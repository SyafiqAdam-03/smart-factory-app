import 'package:smart_factory_qc/domain/models/batch_status.dart';

class InspectionRecord {
  const InspectionRecord({
    required this.serialNumber,
    required this.batchNumber,
    required this.machine,
    required this.result,
    required this.defectCategory,
    required this.notes,
    required this.photoCount,
    required this.inspector,
    required this.recordedAt,
  });

  final String serialNumber;
  final String batchNumber;
  final String machine;
  final BatchStatus result;
  final String defectCategory;
  final String notes;
  final int photoCount;
  final String inspector;
  final String recordedAt;
}
