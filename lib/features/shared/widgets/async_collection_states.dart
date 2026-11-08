import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';

class CollectionEmptyState extends StatelessWidget {
  const CollectionEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.footer,
    required this.onAction,
    this.icon = Icons.inventory_2_outlined,
  });

  final String title;
  final String description;
  final String actionLabel;
  final String footer;
  final VoidCallback onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StateIcon(icon: icon),
              const SizedBox(height: AppSpacing.s12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyStrong.copyWith(fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.slate600,
                  height: 1.4,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(actionLabel),
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  footer,
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      );
}

class CollectionErrorState extends StatelessWidget {
  const CollectionErrorState({
    super.key,
    required this.feature,
    required this.onRetry,
  });

  final String feature;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _StateIcon(icon: Icons.cloud_off_outlined),
              const SizedBox(height: AppSpacing.s12),
              Text(
                'Couldn’t load $feature',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyStrong.copyWith(fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                'Check your connection and try again. Your saved records are safe.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.slate600,
                  height: 1.4,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Last attempt · 18 Oct 2026, 09:41',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      );
}

class CollectionLoadingState extends StatefulWidget {
  const CollectionLoadingState({super.key, required this.feature});

  final String feature;

  @override
  State<CollectionLoadingState> createState() => _CollectionLoadingStateState();
}

class _CollectionLoadingStateState extends State<CollectionLoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Loading ${widget.feature.toLowerCase()}...',
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ),
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _ShimmerCard(animation: _controller),
          ],
        ],
      );
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => Container(
        height: 96,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.slate200),
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment(-1.5 + 3 * animation.value, 0),
              end: Alignment(-0.5 + 3 * animation.value, 0),
              colors: const [
                AppColors.slate200,
                AppColors.slate100,
                AppColors.slate200,
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(bounds),
            child: child,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlaceholderBar(widthFactor: 0.48),
              const SizedBox(height: 8),
              _PlaceholderBar(widthFactor: 0.84),
              const SizedBox(height: 8),
              _PlaceholderBar(widthFactor: 0.65),
            ],
          ),
        ),
      );
}

class _PlaceholderBar extends StatelessWidget {
  const _PlaceholderBar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.slate200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
}

class _StateIcon extends StatelessWidget {
  const _StateIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.slate200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 26, color: AppColors.slate600),
      );
}
