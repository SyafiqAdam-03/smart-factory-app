import 'package:flutter/foundation.dart';

/// Connectivity + offline-queue state. Dummy for now; later, feed it from
/// connectivity_plus and the local drift queue length.
class SyncStatus extends ChangeNotifier {
  SyncStatus({bool offline = false, int pendingRecords = 0})
      : _offline = offline,
        _pendingRecords = pendingRecords;

  bool _offline;
  int _pendingRecords;

  bool get isOffline => _offline;
  int get pendingRecords => _pendingRecords;

  void setOffline(bool value) {
    if (value == _offline) return;
    _offline = value;
    notifyListeners();
  }

  void setPending(int value) {
    if (value == _pendingRecords) return;
    _pendingRecords = value;
    notifyListeners();
  }
}
