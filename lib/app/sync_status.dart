import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncStatusState {
  const SyncStatusState({
    this.isOffline = false,
    this.pendingRecords = 3,
    this.isSyncing = false,
  });

  final bool isOffline;
  final int pendingRecords;
  final bool isSyncing;

  SyncStatusState copyWith({
    bool? isOffline,
    int? pendingRecords,
    bool? isSyncing,
  }) =>
      SyncStatusState(
        isOffline: isOffline ?? this.isOffline,
        pendingRecords: pendingRecords ?? this.pendingRecords,
        isSyncing: isSyncing ?? this.isSyncing,
      );
}

class SyncStatusController extends StateNotifier<SyncStatusState> {
  SyncStatusController() : super(const SyncStatusState());

  void setOffline(bool value) {
    state = state.copyWith(isOffline: value, isSyncing: false);
  }

  Future<void> sync() async {
    if (state.isSyncing || (!state.isOffline && state.pendingRecords == 0)) {
      return;
    }
    state = state.copyWith(isSyncing: true);
    await Future<void>.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      isOffline: false,
      pendingRecords: 0,
      isSyncing: false,
    );
  }
}

final syncStatusProvider =
    StateNotifierProvider<SyncStatusController, SyncStatusState>(
  (ref) => SyncStatusController(),
);
