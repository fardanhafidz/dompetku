import 'package:intl/intl.dart';

class DateFormatter {
  static String toShortDate(DateTime date) {
    // Result: 06 Mar 2026
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String toFullDateTime(DateTime date) {
    // Result: Jumat, 06 Maret 2026 18:45
    return DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(date);
  }
}
