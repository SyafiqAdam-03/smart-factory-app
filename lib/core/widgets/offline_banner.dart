import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';

/// Pinned banner shown while the device has no connection.
/// Wording is fixed by spec: "Offline - [X] records waiting to sync".
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.pendingRecords});

  final int pendingRecords;

  @override
  Widget build(BuildContext context) {
    final noun = pendingRecords == 1 ? 'record' : 'records';
    final message = 'Offline - $pendingRecords $noun waiting to sync';
    return Semantics(
      liveRegion: true,
      label: message,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: AppColors.quarantined,
        child: Row(
          children: [
            const Icon(Icons.cloud_off_rounded, size: 18, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
