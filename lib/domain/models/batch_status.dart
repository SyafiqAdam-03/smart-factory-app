enum BatchStatus {
  passed,
  quarantined,
  failed,
  released;

  String get label => switch (this) {
        BatchStatus.passed => 'Passed',
        BatchStatus.quarantined => 'Quarantined',
        BatchStatus.failed => 'Failed',
        BatchStatus.released => 'Released',
      };
}
