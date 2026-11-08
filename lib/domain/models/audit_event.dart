import 'package:flutter/material.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';

class AuditEvent {
  const AuditEvent({
    required this.recordId,
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
  });

  final String recordId;
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final BatchStatus status;
}
