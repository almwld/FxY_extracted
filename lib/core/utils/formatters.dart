import 'package:intl/intl.dart';

/// أدوات تنسيق البيانات
class Formatters {
  Formatters._();

  // تنسيق الأرقام
  static final NumberFormat _currencyFormat = NumberFormat('#,##0.00', 'ar');
  static final NumberFormat _numberFormat = NumberFormat('#,##0', 'ar');
  static final NumberFormat _compactFormat = NumberFormat.compact(locale: 'ar');

  // تنسيق التواريخ
  static final DateFormat _dateFormat = DateFormat('yyyy/MM/dd', 'ar');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'ar');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm', 'ar');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, d MMMM yyyy', 'ar');
  static final DateFormat _shortDateFormat = DateFormat('d MMM', 'ar');

  /// تنسيق العملة
  static String formatCurrency(double amount, {String currency = 'YER'}) {
    final formatted = _currencyFormat.format(amount);
    return '$formatted $currency';
  }

  /// تنسيق العملة بدون كسور
  static String formatCurrencyInt(double amount, {String currency = 'YER'}) {
    final formatted = _numberFormat.format(amount);
    return '$formatted $currency';
  }

  /// تنسيق الرقم
  static String formatNumber(num number) {
    return _numberFormat.format(number);
  }

  /// تنسيق الرقم المختصر
  static String formatCompact(num number) {
    return _compactFormat.format(number);
  }

  /// تنسيق التاريخ
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// تنسيق الوقت
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// تنسيق التاريخ والوقت
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// تنسيق التاريخ الكامل
  static String formatFullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  /// تنسيق التاريخ المختصر
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// تنسيق التاريخ النسبي
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'الآن';
        }
        return 'منذ ${difference.inMinutes} دقيقة';
      }
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      return 'منذ ${(difference.inDays / 7).floor()} أسابيع';
    } else if (difference.inDays < 365) {
      return 'منذ ${(difference.inDays / 30).floor()} أشهر';
    } else {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    }
  }

  /// تنسيق رقم الهاتف
  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    if (cleaned.startsWith('967')) {
      // رقم دولي
      return '+967 ${cleaned.substring(3, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
    } else if (cleaned.startsWith('0')) {
      // رقم محلي
      return '0${cleaned.substring(1, 2)} ${cleaned.substring(2, 5)} ${cleaned.substring(5)}';
    }
    
    return phone;
  }

  /// تنسيق رقم البطاقة
  static String formatCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleaned[i]);
    }
    
    return buffer.toString();
  }

  /// إخفاء رقم البطاقة
  static String maskCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 4) return cardNumber;
    
    final last4 = cleaned.substring(cleaned.length - 4);
    return '**** **** **** $last4';
  }

  /// تنسيق تاريخ انتهاء البطاقة
  static String formatExpiryDate(String expiryDate) {
    final cleaned = expiryDate.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 2) return cleaned;
    
    return '${cleaned.substring(0, 2)}/${cleaned.substring(2)}';
  }

  /// تنسيق النسبة المئوية
  static String formatPercentage(double value, {int decimals = 0}) {
    final formatter = NumberFormat.decimalPattern('ar');
    formatter.minimumFractionDigits = decimals;
    formatter.maximumFractionDigits = decimals;
    return '${formatter.format(value)}%';
  }

  /// تنسيق الوزن
  static String formatWeight(double weight, {String unit = 'كجم'}) {
    return '${formatNumber(weight)} $unit';
  }

  /// تنسيق المسافة
  static String formatDistance(double distance, {bool useKm = true}) {
    if (useKm) {
      if (distance >= 1) {
        return '${formatNumber(distance)} كم';
      } else {
        return '${formatNumber(distance * 1000)} م';
      }
    }
    return '${formatNumber(distance)} م';
  }

  /// تنسيق المدة
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')} ساعة';
    }
    return '$minutes دقيقة';
  }

  /// تنسيق حجم الملف
  static String formatFileSize(int bytes) {
    const suffixes = ['بايت', 'كيلوبايت', 'ميجابايت', 'جيجابايت', 'تيرابايت'];
    
    if (bytes == 0) return '0 بايت';
    
    final i = (bytes.bitLength ~/ 10).clamp(0, suffixes.length - 1);
    final size = bytes / (1 << (i * 10));
    
    return '${formatNumber(size)} ${suffixes[i]}';
  }

  /// تنسيق الرقم الترتيبي
  static String formatOrdinal(int number) {
    return 'ال$number';
  }

  /// تنسيق النص الكبير
  static String formatLargeText(String text, {int maxLength = 100}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// تنسيق اسم المستخدم
  static String formatUsername(String username) {
    return username.toLowerCase().replaceAll(' ', '_');
  }

  /// تنسيق الاسم الكامل
  static String formatFullName(String firstName, String lastName) {
    return '$firstName $lastName'.trim();
  }

  /// تنسيق الأحرف الأولى
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// تنسيق رقم الطلب
  static String formatOrderNumber(String orderNumber) {
    return '#$orderNumber';
  }

  /// تنسيق رقم المعاملة
  static String formatTransactionId(String id) {
    if (id.length <= 8) return id;
    return '${id.substring(0, 4)}...${id.substring(id.length - 4)}';
  }

  /// تنسيق حالة الطلب
  static String formatOrderStatus(String status) {
    final statusMap = {
      'pending': 'قيد الانتظار',
      'processing': 'قيد المعالجة',
      'shipped': 'تم الشحن',
      'delivered': 'تم التوصيل',
      'cancelled': 'ملغي',
      'refunded': 'مسترد',
    };
    return statusMap[status.toLowerCase()] ?? status;
  }

  /// تنسيق نوع المعاملة
  static String formatTransactionType(String type) {
    final typeMap = {
      'deposit': 'إيداع',
      'withdraw': 'سحب',
      'transfer': 'تحويل',
      'payment': 'دفع',
      'refund': 'استرداد',
      'fee': 'رسوم',
    };
    return typeMap[type.toLowerCase()] ?? type;
  }
}
