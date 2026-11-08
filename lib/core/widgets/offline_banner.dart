import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';

/// Pinned banner shown while the device has no connection.
/// Wording is fixed by spec: "Offline - [X] records waiting to sync".
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    required this.pendingRecords,
    required this.onTap,
    this.isSyncing = false,
  });

  final int pendingRecords;
  final bool isSyncing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final noun = pendingRecords == 1 ? 'record' : 'records';
    final message = isSyncing
        ? 'Syncing...'
        : 'Offline - $pendingRecords $noun waiting to sync';
    return Semantics(
      liveRegion: true,
      label: message,
      button: true,
      child: Material(
        color: AppColors.slate200,
        child: InkWell(
          onTap: isSyncing ? null : onTap,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSyncing ? Icons.sync_rounded : Icons.cloud_off_rounded,
                  size: 18,
                  color: AppColors.navy,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (isSyncing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.navy,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
