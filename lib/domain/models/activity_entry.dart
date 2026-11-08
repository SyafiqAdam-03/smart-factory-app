import 'package:smart_factory_qc/domain/models/batch_status.dart';

class ActivityEntry {
  const ActivityEntry({
    required this.title,
    required this.reference,
    required this.status,
    required this.minutesAgo,
  });

  final String title;

  /// Batch or serial number (rendered in monospace).
  final String reference;
  final BatchStatus status;
  final int minutesAgo;
}
