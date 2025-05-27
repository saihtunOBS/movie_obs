
import 'package:intl/intl.dart';

class DateFormatter {
 
  static String formatDate(DateTime dateTime) {
    DateFormat formatter = DateFormat('MMM dd,yyyy');
    String formatted = formatter.format(dateTime);

    return formatted;
  }

  static String formatStringDate(String date) {
    try {
      final formatter = DateFormat('EEE MMM d yyyy HH:mm:ss');
      final dateTime = formatter.parse(date);

      // Format the date to 'MMM dd, yyyy'
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return ""; // Handle errors
    }
  }
}
