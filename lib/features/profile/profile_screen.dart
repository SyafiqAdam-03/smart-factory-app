import 'package:flutter/material.dart';
import 'package:smart_factory_qc/app/sync_status.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.syncStatus, required this.onSignOut});

  final SyncStatus syncStatus;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel('Signed in as'),
                  SizedBox(height: AppSpacing.s4),
                  Text('A. Rahman', style: AppTextStyles.bodyStrong),
                  SizedBox(height: AppSpacing.s4),
                  Text('E-10482', style: AppTextStyles.mono),
                  SizedBox(height: AppSpacing.s12),
                  SectionLabel('Role'),
                  SizedBox(height: AppSpacing.s4),
                  Text('Quality inspector · Line 2', style: AppTextStyles.body),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          // Demo-only switch so the offline banner can be previewed. Remove
          // once connectivity_plus drives SyncStatus.
          Card(
            child: ListenableBuilder(
              listenable: syncStatus,
              builder: (_, __) => SwitchListTile(
                value: syncStatus.isOffline,
                onChanged: syncStatus.setOffline,
                thumbColor: const WidgetStatePropertyAll(AppColors.white),
                activeTrackColor: AppColors.quarantined,
                title: const Text('Simulate offline', style: AppTextStyles.bodyStrong),
                subtitle: const Text('Demo only', style: AppTextStyles.caption),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          SizedBox(
            height: AppSpacing.primaryButtonHeight,
            child: OutlinedButton.icon(
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}
