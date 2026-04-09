/// أدوات التعامل مع التواريخ
class DateUtils {
  DateUtils._();

  /// الحصول على بداية اليوم
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// الحصول على نهاية اليوم
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// الحصول على بداية الأسبوع
  static DateTime startOfWeek(DateTime date) {
    final daysSinceSaturday = date.weekday % 7;
    return startOfDay(date.subtract(Duration(days: daysSinceSaturday)));
  }

  /// الحصول على نهاية الأسبوع
  static DateTime endOfWeek(DateTime date) {
    final daysUntilFriday = (5 - date.weekday + 7) % 7;
    return endOfDay(date.add(Duration(days: daysUntilFriday)));
  }

  /// الحصول على بداية الشهر
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// الحصول على نهاية الشهر
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  /// الحصول على بداية السنة
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// الحصول على نهاية السنة
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  /// التحقق مما إذا كان التاريخ اليوم
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// التحقق مما إذا كان التاريخ أمس
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  /// التحقق مما إذا كان التاريخ غداً
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  /// التحقق مما إذا كان التاريخ في هذا الأسبوع
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final start = startOfWeek(now);
    final end = endOfWeek(now);
    return date.isAfter(start.subtract(const Duration(seconds: 1))) && 
           date.isBefore(end.add(const Duration(seconds: 1)));
  }

  /// التحقق مما إذا كان التاريخ في هذا الشهر
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// التحقق مما إذا كان التاريخ في هذه السنة
  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  /// الحصول على الفرق بالأيام
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = startOfDay(from);
    final toDate = startOfDay(to);
    return toDate.difference(fromDate).inDays;
  }

  /// الحصول على الفرق بالأسابيع
  static int weeksBetween(DateTime from, DateTime to) {
    return daysBetween(from, to) ~/ 7;
  }

  /// الحصول على الفرق بالأشهر
  static int monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + to.month - from.month;
  }

  /// الحصول على الفرق بالسنوات
  static int yearsBetween(DateTime from, DateTime to) {
    return to.year - from.year;
  }

  /// الحصول على العمر
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// إضافة أيام
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// إضافة أسابيع
  static DateTime addWeeks(DateTime date, int weeks) {
    return date.add(Duration(days: weeks * 7));
  }

  /// إضافة أشهر
  static DateTime addMonths(DateTime date, int months) {
    var newMonth = date.month + months;
    var newYear = date.year;
    
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }
    
    // التعامل مع الأيام التي لا توجد في الشهر الجديد
    final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = date.day > lastDayOfNewMonth ? lastDayOfNewMonth : date.day;
    
    return DateTime(newYear, newMonth, newDay, 
                    date.hour, date.minute, date.second, date.millisecond);
  }

  /// إضافة سنوات
  static DateTime addYears(DateTime date, int years) {
    return addMonths(date, years * 12);
  }

  /// الحصول على اسم اليوم
  static String getDayName(DateTime date, {bool short = false}) {
    final days = short 
      ? ['سبت', 'أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة']
      : ['السبت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
    return days[date.weekday % 7];
  }

  /// الحصول على اسم الشهر
  static String getMonthName(DateTime date, {bool short = false}) {
    final months = short
      ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
         'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
      : ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
         'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return months[date.month - 1];
  }

  /// الحصول على الربع
  static int getQuarter(DateTime date) {
    return ((date.month - 1) ~/ 3) + 1;
  }

  /// الحصول على بداية الربع
  static DateTime startOfQuarter(DateTime date) {
    final quarter = getQuarter(date);
    return DateTime(date.year, (quarter - 1) * 3 + 1, 1);
  }

  /// الحصول على نهاية الربع
  static DateTime endOfQuarter(DateTime date) {
    final quarter = getQuarter(date);
    return endOfMonth(DateTime(date.year, quarter * 3, 1));
  }

  /// الحصول على عدد الأيام في الشهر
  static int daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// التحقق مما إذا كان السنة كبيسة
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// الحصول على عدد الأيام في السنة
  static int daysInYear(int year) {
    return isLeapYear(year) ? 366 : 365;
  }

  /// الحصول على الأسبوع من السنة
  static int weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = daysBetween(firstDayOfYear, date);
    return (daysSinceFirstDay ~/ 7) + 1;
  }

  /// تحويل Timestamp إلى DateTime
  static DateTime? fromTimestamp(int? timestamp) {
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// تحويل DateTime إلى Timestamp
  static int? toTimestamp(DateTime? date) {
    if (date == null) return null;
    return date.millisecondsSinceEpoch;
  }

  /// تحويل ISO String إلى DateTime
  static DateTime? fromIsoString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    return DateTime.tryParse(isoString);
  }

  /// تحويل DateTime إلى ISO String
  static String? toIsoString(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }

  /// مقارنة تاريخين (بدون الوقت)
  static int compareDates(DateTime a, DateTime b) {
    final dateA = DateTime(a.year, a.month, a.day);
    final dateB = DateTime(b.year, b.month, b.day);
    return dateA.compareTo(dateB);
  }

  /// الحصول على قائمة بالأيام بين تاريخين
  static List<DateTime> getDaysBetween(DateTime from, DateTime to) {
    final days = <DateTime>[];
    var current = startOfDay(from);
    final end = startOfDay(to);
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);
      current = addDays(current, 1);
    }
    
    return days;
  }

  /// الحصول على قائمة بالأشهر بين تاريخين
  static List<DateTime> getMonthsBetween(DateTime from, DateTime to) {
    final months = <DateTime>[];
    var current = startOfMonth(from);
    final end = startOfMonth(to);
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      months.add(current);
      current = addMonths(current, 1);
    }
    
    return months;
  }

  /// التحقق مما إذا كان التاريخ في عطلة نهاية الأسبوع
  static bool isWeekend(DateTime date) {
    final dayOfWeek = date.weekday % 7;
    return dayOfWeek == 5 || dayOfWeek == 6; // الجمعة والسبت
  }

  /// التحقق مما إذا كان التاريخ يوم عمل
  static bool isWeekday(DateTime date) {
    return !isWeekend(date);
  }

  /// الحصول على الوقت المنقضي
  static String getTimeAgo(DateTime date, {bool short = false}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return short ? '$years س' : 'منذ $years سنة';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return short ? '$months ش' : 'منذ $months شهر';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return short ? '$weeks أ' : 'منذ $weeks أسبوع';
    } else if (difference.inDays > 0) {
      return short ? '${difference.inDays} ي' : 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return short ? '${difference.inHours} س' : 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return short ? '${difference.inMinutes} د' : 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return short ? 'الآن' : 'منذ لحظات';
    }
  }
}
