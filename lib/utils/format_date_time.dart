const millisInMinute = 60 * 1000;
const millisInHour = 60 * millisInMinute;
const millisInDay = 24 * millisInHour;

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final duration = now.difference(dateTime);

  if (duration.inDays >= 2) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
  if (duration.inDays >= 1) {
    return 'Yesterday';
  }
  if (duration.inHours >= 1) {
    return '${duration.inHours} hours ago';
  }
  if (duration.inMinutes >= 1) {
    return '${duration.inMinutes} minutes ago';
  }
  return 'Just now';
}
