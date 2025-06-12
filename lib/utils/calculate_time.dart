String formatMinutesToHoursAndMinutes(int minutes) {
  if (minutes < 60) {
    return '$minutes mins';
  }

  final int hours = minutes ~/ 60;
  final int remainingMinutes = minutes % 60;

  return remainingMinutes == 0
      ? '$hours hr'
      : '$hours hr $remainingMinutes mins';
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

String formatWithDashes(String input) {
  final buffer = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    buffer.write(input[i]);
    if ((i + 1) % 3 == 0 && i != input.length - 1) {
      buffer.write('-');
    }
  }
  return buffer.toString();
}
