import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    initializeDateFormatting('it_IT', null);
    return DateFormat('EEEE d MMMM yyyy', 'it_IT').format(date);
  }
}
