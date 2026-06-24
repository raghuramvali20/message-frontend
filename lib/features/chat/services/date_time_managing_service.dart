class DateTimeManagingService {
  final String timeStampString;
  DateTimeManagingService(this.timeStampString);

  TimeAndDate convertTimeAndDate() {
    DateTime timeStamp = DateTime.parse(timeStampString).toLocal();
    DateTime now = DateTime.now();

    // Format time (HH:mm)
    String time = "${timeStamp.hour}:${timeStamp.minute.toString().padLeft(2, '0')}";

    // Normalize to midnight for comparison
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime target = DateTime(timeStamp.year, timeStamp.month, timeStamp.day);

    Duration diff = today.difference(target);

    String date;
    if (diff.inDays == 0) {
      date = "Today";
    } else if (diff.inDays == 1) {
      date = "Yesterday";
    } else if (diff.inDays < 7) {
      // Same week → weekday name
      date = _weekdayName(timeStamp.weekday);
    } else if (timeStamp.year == now.year) {
      // Within this year → "1 Mar"
      date = "${timeStamp.day} ${_monthName(timeStamp.month)}";
    } else {
      // Older → "1 Mar 2025"
      date = "${timeStamp.day} ${_monthName(timeStamp.month)} ${timeStamp.year}";
    }

    return TimeAndDate(time, date);
  }

  String _weekdayName(int weekday) {
    const names = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
    return names[weekday - 1];
  }

  String _monthName(int monthNumber) {
    const names = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return names[monthNumber - 1];
  }
}

class TimeAndDate {
  final String time;
  final String date;

  TimeAndDate(this.time, this.date);
}
