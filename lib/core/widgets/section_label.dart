import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';

/// Small uppercase field / section label.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color, this.maxLines});

  final String text;
  final Color? color;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: color == null
            ? AppTextStyles.label
            : AppTextStyles.label.copyWith(color: color),
      );
}
