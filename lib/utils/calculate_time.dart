String formatMinutesToHoursAndMinutes(int minutes) {
  final int hours = minutes ~/ 60; // Integer division
  final int remainingMinutes = minutes % 60;

  return '$hours hr $remainingMinutes mins';
}
