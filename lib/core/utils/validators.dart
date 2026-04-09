/// أدوات التحقق من صحة البيانات
class Validators {
  Validators._();

  /// التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'بريد إلكتروني غير صالح';
    }
    return null;
  }

  /// التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'يجب أن تحتوي على حرف كبير';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'يجب أن تحتوي على حرف صغير';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'يجب أن تحتوي على رقم';
    }
    return null;
  }

  /// التحقق من تأكيد كلمة المرور
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  /// التحقق من رقم الهاتف
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    // التحقق من رقم الهاتف اليمني
    final phoneRegex = RegExp(r'^(\+967|00967|0)?[7-9][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'رقم هاتف غير صالح';
    }
    return null;
  }

  /// التحقق من الاسم
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    if (value.length > 50) {
      return 'الاسم يجب أن لا يتجاوز 50 حرف';
    }
    return null;
  }

  /// التحقق من الاسم الكامل
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم الكامل مطلوب';
    }
    if (value.length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    if (value.length > 100) {
      return 'الاسم يجب أن لا يتجاوز 100 حرف';
    }
    return null;
  }

  /// التحقق من العنوان
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'العنوان مطلوب';
    }
    if (value.length < 5) {
      return 'العنوان يجب أن يكون 5 أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من المدينة
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'المدينة مطلوبة';
    }
    return null;
  }

  /// التحقق من الرمز البريدي
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرمز البريدي مطلوب';
    }
    if (!RegExp(r'^[0-9]{5}$').hasMatch(value)) {
      return 'رمز بريدي غير صالح';
    }
    return null;
  }

  /// التحقق من رقم البطاقة
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم البطاقة مطلوب';
    }
    final cleaned = value.replaceAll(' ', '').replaceAll('-', '');
    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'رقم بطاقة غير صالح';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'رقم بطاقة غير صالح';
    }
    return null;
  }

  /// التحقق من تاريخ انتهاء البطاقة
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'تاريخ الانتهاء مطلوب';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'تاريخ غير صالح (MM/YY)';
    }
    return null;
  }

  /// التحقق من CVV
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV مطلوب';
    }
    if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
      return 'CVV غير صالح';
    }
    return null;
  }

  /// التحقق من المبلغ
  static String? validateAmount(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return 'المبلغ مطلوب';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) {
      return 'مبلغ غير صالح';
    }
    if (amount <= 0) {
      return 'المبلغ يجب أن يكون أكبر من صفر';
    }
    if (min != null && amount < min) {
      return 'المبلغ يجب أن يكون $min على الأقل';
    }
    if (max != null && amount > max) {
      return 'المبلغ يجب أن لا يتجاوز $max';
    }
    return null;
  }

  /// التحقق من رقم الهوية
  static String? validateIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهوية مطلوب';
    }
    if (!RegExp(r'^[0-9]{9,12}$').hasMatch(value)) {
      return 'رقم هوية غير صالح';
    }
    return null;
  }

  /// التحقق من OTP
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرمز مطلوب';
    }
    if (value.length != 6) {
      return 'الرمز يجب أن يكون 6 أرقام';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'رمز غير صالح';
    }
    return null;
  }

  /// التحقق من النص المطلوب
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName مطلوب' : 'هذا الحقل مطلوب';
    }
    return null;
  }

  /// التحقق من الطول الأدنى
  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName مطلوب' : 'هذا الحقل مطلوب';
    }
    if (value.length < minLength) {
      return 'يجب أن يكون $minLength أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من الطول الأقصى
  static String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'يجب أن لا يتجاوز $maxLength حرف';
    }
    return null;
  }

  /// التحقق من الرابط
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // الرابط اختياري
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'رابط غير صالح';
    }
    return null;
  }

  /// التحقق من السعر
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'السعر مطلوب';
    }
    final price = double.tryParse(value.replaceAll(',', ''));
    if (price == null) {
      return 'سعر غير صالح';
    }
    if (price <= 0) {
      return 'السعر يجب أن يكون أكبر من صفر';
    }
    return null;
  }

  /// التحقق من الكمية
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'الكمية مطلوبة';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'كمية غير صالحة';
    }
    if (quantity <= 0) {
      return 'الكمية يجب أن تكون أكبر من صفر';
    }
    return null;
  }

  /// التحقق من الوصف
  static String? validateDescription(String? value, {int minLength = 10}) {
    if (value == null || value.isEmpty) {
      return 'الوصف مطلوب';
    }
    if (value.length < minLength) {
      return 'الوصف يجب أن يكون $minLength أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من رقم الحساب البنكي
  static String? validateBankAccount(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الحساب مطلوب';
    }
    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length < 10 || cleaned.length > 30) {
      return 'رقم حساب غير صالح';
    }
    return null;
  }

  /// التحقق من SWIFT code
  static String? validateSwiftCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'SWIFT code مطلوب';
    }
    if (!RegExp(r'^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$').hasMatch(value)) {
      return 'SWIFT code غير صالح';
    }
    return null;
  }

  /// التحقق من IBAN
  static String? validateIban(String? value) {
    if (value == null || value.isEmpty) {
      return 'IBAN مطلوب';
    }
    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length < 15 || cleaned.length > 34) {
      return 'IBAN غير صالح';
    }
    return null;
  }
}
