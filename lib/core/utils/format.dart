/// 12400 -> "12,400"
String formatQty(num value) {
  final s = value.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

String formatAgo(int minutes) {
  if (minutes < 1) return 'Just now';
  if (minutes < 60) return '$minutes min ago';
  if (minutes < 1440) return '${minutes ~/ 60} h ago';
  return '${minutes ~/ 1440} d ago';
}
