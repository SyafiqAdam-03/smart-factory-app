import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_factory_qc/domain/models/batch_status.dart';
import 'package:smart_factory_qc/features/deliveries/batch_released_screen.dart';
import 'package:smart_factory_qc/features/deliveries/delivery_detail_screen.dart';
import 'package:smart_factory_qc/features/inspections/production_inspection_screen.dart';
import 'package:smart_factory_qc/features/shared/providers/app_state.dart';
import 'package:smart_factory_qc/features/trace/trace_search_screen.dart';

void main() {
  testWidgets(
      'releasing a quarantined delivery opens confirmation and updates state',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: DeliveryDetailScreen(batchNumber: 'B-1007'),
        ),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Release batch'));
    await tester.pumpAndSettle();

    expect(find.byType(BatchReleasedScreen), findsOneWidget);
    expect(find.text('Released by exception'), findsOneWidget);
    expect(
      container
          .read(deliveryRepositoryProvider)
          .firstWhere((record) => record.batchNumber == 'B-1007')
          .status,
      BatchStatus.released,
    );
  });

  testWidgets('inspection form attaches a photo and signs off', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProductionInspectionScreen(),
                    ),
                  ),
                  child: const Text('Open inspection'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open inspection'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add photo from camera'));
    await tester.tap(find.text('Add photo from camera'));
    await tester.pump();
    expect(find.text('1 photo attached'), findsOneWidget);

    await tester.ensureVisible(find.text('Sign off'));
    await tester.tap(find.text('Sign off'));
    await tester.pumpAndSettle();
    expect(container.read(inspectionRecordsProvider), hasLength(1));
    expect(
      find.text('Inspection signed off successfully.'),
      findsOneWidget,
    );
  });

  testWidgets('trace screen lists newest events and filters by serial',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: TraceSearchScreen()),
      ),
    );

    expect(find.text('Released by authorised exception'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'SN-20481',
    );
    await tester.pumpAndSettle();
    expect(find.text('Sample inspection signed'), findsOneWidget);
    expect(find.text('Delivery received'), findsNothing);
  });
}
