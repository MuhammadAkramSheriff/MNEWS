
import 'package:intl/intl.dart';

String getTimeDifference(String timeString) {
  DateTime currentTime = DateTime.now();
  DateTime articleTime = DateTime.parse(timeString);
  Duration difference = currentTime.difference(articleTime);

  String formattedDate = DateFormat('dd/MM/yyyy').format(articleTime);

  if (difference.inDays > 7) { //if more than 7 days
    return formattedDate;
  } else if (difference.inDays > 0) { //if less than or equal to 7 day
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) { //if less than 1 day
    return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) { //if less than 1 hour
    return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
  } else { //if less than 1 minute
    return 'Just now';
  }
}