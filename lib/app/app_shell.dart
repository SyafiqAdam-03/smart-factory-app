import 'package:flutter/material.dart';
import 'package:smart_factory_qc/app/sync_status.dart';
import 'package:smart_factory_qc/core/widgets/offline_banner.dart';
import 'package:smart_factory_qc/features/home/home_screen.dart';
import 'package:smart_factory_qc/features/inventory/inventory_screen.dart';
import 'package:smart_factory_qc/features/profile/profile_screen.dart';
import 'package:smart_factory_qc/features/shared/placeholder_screen.dart';

/// Bottom navigation: Home, Scan, Deliveries, Inventory, Profile.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.syncStatus, required this.onSignOut});

  final SyncStatus syncStatus;
  final VoidCallback onSignOut;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _goTo(int i) => setState(() => _index = i);

  void _openInspection() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlaceholderScreen(
          title: 'New inspection',
          icon: Icons.fact_check_outlined,
          description: 'Production inspection form comes in the next iteration.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's state (e.g. inventory search).
      // When the Scan tab is built for real, create its camera lazily and
      // stop it when the tab is not selected.
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onScan: () => _goTo(1), onNewInspection: _openInspection),
          const PlaceholderScreen(
            title: 'Scan',
            icon: Icons.qr_code_scanner_rounded,
            description: 'Full-screen barcode scanner (mobile_scanner) comes next.',
          ),
          const PlaceholderScreen(
            title: 'Deliveries',
            icon: Icons.local_shipping_outlined,
            description: 'Delivery list and detail screens come next.',
          ),
          const InventoryScreen(),
          ProfileScreen(syncStatus: widget.syncStatus, onSignOut: widget.onSignOut),
        ],
      ),
      // Banner sits directly above the nav bar so it is pinned on every tab
      // without fighting each screen's AppBar for the status-bar inset.
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
            listenable: widget.syncStatus,
            builder: (_, __) => widget.syncStatus.isOffline
                ? OfflineBanner(pendingRecords: widget.syncStatus.pendingRecords)
                : const SizedBox.shrink(),
          ),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _goTo,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.qr_code_scanner_rounded),
                label: 'Scan',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_shipping_outlined),
                selectedIcon: Icon(Icons.local_shipping_rounded),
                label: 'Deliveries',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'Inventory',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
