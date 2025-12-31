import 'package:intl/intl.dart';

String formatDateWithSuffix(DateTime date) {
  final day = date.day;

  String suffix;
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }

  final monthYear = DateFormat('MMMM, y').format(date);
  return '$day$suffix $monthYear';
}
