/// أدوات التعامل مع العملات
class CurrencyUtils {
  CurrencyUtils._();

  // أسعار الصرف (ثابتة للتطبيق)
  static const Map<String, double> _exchangeRates = {
    'YER': 1.0,        // الريال اليمني
    'SAR': 66.75,      // الريال السعودي
    'USD': 250.0,      // الدولار الأمريكي
    'EUR': 272.0,      // اليورو
    'GBP': 318.0,      // الجنيه الإسترليني
    'AED': 68.0,       // الدرهم الإماراتي
    'KWD': 815.0,      // الدينار الكويتي
    'QAR': 68.5,       // الريال القطري
    'OMR': 649.0,      // الريال العماني
    'BHD': 663.0,      // الدينار البحريني
    'EGP': 8.0,        // الجنيه المصري
    'JOD': 352.0,      // الدينار الأردني
    'TRY': 9.0,        // الليرة التركية
  };

  // رموز العملات
  static const Map<String, String> _currencySymbols = {
    'YER': '﷼',
    'SAR': 'ر.س',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'AED': 'د.إ',
    'KWD': 'د.ك',
    'QAR': 'ر.ق',
    'OMR': 'ر.ع',
    'BHD': 'د.ب',
    'EGP': 'ج.م',
    'JOD': 'د.أ',
    'TRY': '₺',
  };

  // أسماء العملات بالعربية
  static const Map<String, String> _currencyNames = {
    'YER': 'ريال يمني',
    'SAR': 'ريال سعودي',
    'USD': 'دولار أمريكي',
    'EUR': 'يورو',
    'GBP': 'جنيه إسترليني',
    'AED': 'درهم إماراتي',
    'KWD': 'دينار كويتي',
    'QAR': 'ريال قطري',
    'OMR': 'ريال عماني',
    'BHD': 'دينار بحريني',
    'EGP': 'جنيه مصري',
    'JOD': 'دينار أردني',
    'TRY': 'ليرة تركية',
  };

  /// الحصول على سعر الصرف
  static double getExchangeRate(String currencyCode) {
    return _exchangeRates[currencyCode.toUpperCase()] ?? 1.0;
  }

  /// الحصول على رمز العملة
  static String getCurrencySymbol(String currencyCode) {
    return _currencySymbols[currencyCode.toUpperCase()] ?? currencyCode;
  }

  /// الحصول على اسم العملة
  static String getCurrencyName(String currencyCode) {
    return _currencyNames[currencyCode.toUpperCase()] ?? currencyCode;
  }

  /// تحويل المبلغ من عملة إلى أخرى
  static double convert(double amount, String fromCurrency, String toCurrency) {
    final fromRate = getExchangeRate(fromCurrency);
    final toRate = getExchangeRate(toCurrency);
    
    // تحويل إلى الريال اليمني أولاً ثم إلى العملة المطلوبة
    final amountInYER = amount * fromRate;
    return amountInYER / toRate;
  }

  /// تحويل المبلغ إلى الريال اليمني
  static double toYER(double amount, String fromCurrency) {
    return amount * getExchangeRate(fromCurrency);
  }

  /// تحويل المبلغ من الريال اليمني
  static double fromYER(double amount, String toCurrency) {
    return amount / getExchangeRate(toCurrency);
  }

  /// تنسيق المبلغ مع العملة
  static String format(double amount, String currencyCode) {
    final symbol = getCurrencySymbol(currencyCode);
    final formattedAmount = amount.toStringAsFixed(2);
    return '$formattedAmount $symbol';
  }

  /// تنسيق المبلغ بالريال اليمني
  static String formatYER(double amount) {
    return format(amount, 'YER');
  }

  /// الحصول على قائمة العملات المتاحة
  static List<String> getAvailableCurrencies() {
    return _exchangeRates.keys.toList();
  }

  /// الحصول على تفاصيل جميع العملات
  static List<Map<String, dynamic>> getAllCurrencies() {
    return _exchangeRates.keys.map((code) => {
      'code': code,
      'symbol': getCurrencySymbol(code),
      'name': getCurrencyName(code),
      'rate': getExchangeRate(code),
    }).toList();
  }

  /// التحقق مما إذا كانت العملة مدعومة
  static bool isCurrencySupported(String currencyCode) {
    return _exchangeRates.containsKey(currencyCode.toUpperCase());
  }

  /// حساب العمولة
  static double calculateFee(double amount, double feePercentage) {
    return amount * (feePercentage / 100);
  }

  /// حساب المبلغ الإجمالي مع العمولة
  static double calculateTotalWithFee(double amount, double feePercentage) {
    return amount + calculateFee(amount, feePercentage);
  }

  /// حساب المبلغ الصافي بعد العمولة
  static double calculateNetAmount(double amount, double feePercentage) {
    return amount - calculateFee(amount, feePercentage);
  }

  /// تقسيم المبلغ
  static Map<String, double> splitAmount(double amount, int parts) {
    final baseAmount = (amount / parts * 100).round() / 100;
    final remainder = amount - (baseAmount * parts);
    
    final result = <String, double>{};
    for (int i = 0; i < parts; i++) {
      result['part_${i + 1}'] = baseAmount + (i == 0 ? remainder : 0);
    }
    
    return result;
  }

  /// حساب الخصم
  static double calculateDiscount(double amount, double discountPercentage) {
    return amount * (discountPercentage / 100);
  }

  /// حساب المبلغ بعد الخصم
  static double calculateDiscountedAmount(double amount, double discountPercentage) {
    return amount - calculateDiscount(amount, discountPercentage);
  }

  /// حساب الضريبة
  static double calculateTax(double amount, double taxPercentage) {
    return amount * (taxPercentage / 100);
  }

  /// حساب المبلغ الإجمالي مع الضريبة
  static double calculateTotalWithTax(double amount, double taxPercentage) {
    return amount + calculateTax(amount, taxPercentage);
  }

  /// تدوير المبلغ
  static double round(double amount, {int decimals = 2}) {
    final multiplier = pow(10, decimals);
    return (amount * multiplier).round() / multiplier;
  }

  /// التحقق من صحة المبلغ
  static bool isValidAmount(double amount) {
    return amount >= 0 && !amount.isNaN && !amount.isInfinite;
  }

  /// الحصول على المبلغ الأدنى للتحويل
  static double getMinimumTransferAmount(String currencyCode) {
    final minimums = {
      'YER': 100.0,
      'SAR': 5.0,
      'USD': 1.0,
      'EUR': 1.0,
    };
    return minimums[currencyCode.toUpperCase()] ?? 1.0;
  }

  /// الحصول على المبلغ الأقصى للتحويل
  static double getMaximumTransferAmount(String currencyCode) {
    final maximums = {
      'YER': 10000000.0,
      'SAR': 50000.0,
      'USD': 10000.0,
      'EUR': 10000.0,
    };
    return maximums[currencyCode.toUpperCase()] ?? 10000.0;
  }

  /// التحقق من المبلغ ضمن الحدود
  static bool isAmountWithinLimits(double amount, String currencyCode) {
    final min = getMinimumTransferAmount(currencyCode);
    final max = getMaximumTransferAmount(currencyCode);
    return amount >= min && amount <= max;
  }

  /// حساب معدل الصرف العكسي
  static double getInverseRate(String currencyCode) {
    final rate = getExchangeRate(currencyCode);
    return rate > 0 ? 1 / rate : 0;
  }

  /// مقارنة مبلغين
  static int compareAmounts(double a, double b) {
    return a.compareTo(b);
  }

  /// التحقق مما إذا كان المبلغ صفراً
  static bool isZero(double amount) {
    return amount.abs() < 0.01;
  }

  /// التحقق مما إذا كان المبلغ موجباً
  static bool isPositive(double amount) {
    return amount > 0;
  }

  /// التحقق مما إذا كان المبلغ سالباً
  static bool isNegative(double amount) {
    return amount < 0;
  }

  /// حساب النسبة المئوية
  static double calculatePercentage(double part, double total) {
    if (total == 0) return 0;
    return (part / total) * 100;
  }

  /// دالة مساعدة للقوة
  static double pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
