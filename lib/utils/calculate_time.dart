String formatMinutesToHoursAndMinutes(int minutes) {
  final int hours = minutes ~/ 60; // Integer division
  final int remainingMinutes = minutes % 60;

  return '$hours hr $remainingMinutes mins';
}

String formatViewCount(int count) {
  if (count >= 1000000000) {
    return '${(count / 1000000000).toStringAsFixed(1).replaceAll('.0', '')}B';
  } else if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
  } else {
    return count.toString();
  }
}
