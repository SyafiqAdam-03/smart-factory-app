import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';

Color statusForeground(BatchStatus s) => switch (s) {
      BatchStatus.passed => AppColors.passedText,
      BatchStatus.quarantined => AppColors.quarantinedText,
      BatchStatus.failed => AppColors.failedText,
      BatchStatus.released => AppColors.accent,
    };

Color statusBackground(BatchStatus s) => switch (s) {
      BatchStatus.passed => AppColors.passedSoft,
      BatchStatus.quarantined => AppColors.quarantinedSoft,
      BatchStatus.failed => AppColors.failedSoft,
      BatchStatus.released => AppColors.accentSoft,
    };

/// Icon + text so status is never conveyed by colour alone.
IconData statusIcon(BatchStatus s) => switch (s) {
      BatchStatus.passed => Icons.check_circle_rounded,
      BatchStatus.quarantined => Icons.warning_amber_rounded,
      BatchStatus.failed => Icons.cancel_rounded,
      BatchStatus.released => Icons.lock_open_rounded,
    };

/// Generic flat pill (also used for the "Low stock" badge).
class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
  });

  final String label;
  final Color foreground;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: foreground.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});

  final BatchStatus status;

  @override
  Widget build(BuildContext context) => PillBadge(
        label: status.label,
        foreground: statusForeground(status),
        background: statusBackground(status),
        icon: statusIcon(status),
      );
}
