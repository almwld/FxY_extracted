import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/// خدمة البصمة
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// التحقق مما إذا كان الجهاز يدعم البيومترية
  Future<bool> isDeviceSupported() async {
    return await _localAuth.isDeviceSupported();
  }

  /// التحقق مما إذا كانت البيومترية متاحة
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  /// الحصول على أنواع البيومترية المتاحة
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _localAuth.getAvailableBiometrics();
  }

  /// التحقق مما إذا كانت البصمة متاحة
  Future<bool> isFingerprintAvailable() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint) ||
           availableBiometrics.contains(BiometricType.strong);
  }

  /// التحقق مما إذا كان Face ID متاحاً
  Future<bool> isFaceIdAvailable() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.face) ||
           availableBiometrics.contains(BiometricType.weak);
  }

  /// المصادقة بالبيومترية
  Future<BiometricResult> authenticate({
    String localizedReason = 'يرجى المصادقة للمتابعة',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool sensitiveTransaction = true,
  }) async {
    try {
      final isAvailable = await canCheckBiometrics();
      if (!isAvailable) {
        return BiometricResult.notAvailable;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'المصادقة البيومترية',
            cancelButton: 'إلغاء',
            biometricHint: 'تحقق من هويتك',
            biometricNotRecognized: 'لم يتم التعرف على البصمة',
            biometricRequiredTitle: 'المصادقة البيومترية مطلوبة',
            biometricSuccess: 'تم التعرف بنجاح',
            deviceCredentialsRequiredTitle: 'بيانات الاعتماد مطلوبة',
            deviceCredentialsSetupDescription: 'يرجى إعداد بيانات الاعتماد',
            goToSettingsButton: 'الإعدادات',
            goToSettingsDescription: 'يرجى إعداد البصمة في الإعدادات',
          ),
          IOSAuthMessages(
            cancelButton: 'إلغاء',
            goToSettingsButton: 'الإعدادات',
            goToSettingsDescription: 'يرجى إعداد Face ID في الإعدادات',
            lockOut: 'يرجى إعادة تمكين Face ID',
          ),
        ],
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          sensitiveTransaction: sensitiveTransaction,
          biometricOnly: false,
        ),
      );

      return didAuthenticate 
          ? BiometricResult.success 
          : BiometricResult.cancelled;
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notAvailable:
          return BiometricResult.notAvailable;
        case auth_error.notEnrolled:
          return BiometricResult.notEnrolled;
        case auth_error.passcodeNotSet:
          return BiometricResult.passcodeNotSet;
        case auth_error.lockedOut:
          return BiometricResult.lockedOut;
        case auth_error.permanentlyLockedOut:
          return BiometricResult.permanentlyLockedOut;
        default:
          return BiometricResult.error;
      }
    } catch (e) {
      return BiometricResult.error;
    }
  }

  /// المصادقة بالبصمة فقط
  Future<BiometricResult> authenticateWithFingerprint() async {
    final isAvailable = await isFingerprintAvailable();
    if (!isAvailable) {
      return BiometricResult.notAvailable;
    }

    return await authenticate(
      localizedReason: 'ضع إصبعك على مستشعر البصمة',
    );
  }

  /// المصادقة بـ Face ID فقط
  Future<BiometricResult> authenticateWithFaceId() async {
    final isAvailable = await isFaceIdAvailable();
    if (!isAvailable) {
      return BiometricResult.notAvailable;
    }

    return await authenticate(
      localizedReason: 'انظر إلى الكاميرا للمصادقة',
    );
  }

  /// إيقاف المصادقة
  Future<bool> stopAuthentication() async {
    return await _localAuth.stopAuthentication();
  }

  /// الحصول على اسم نوع البيومترية
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'بصمة الإصبع';
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.iris:
        return 'قزحية العين';
      case BiometricType.strong:
        return 'بيومترية قوية';
      case BiometricType.weak:
        return 'بيومترية ضعيفة';
      default:
        return 'بيومترية';
    }
  }

  /// الحصول على نوع البيومترية المتاح
  Future<String> getAvailableBiometricType() async {
    final availableBiometrics = await getAvailableBiometrics();
    
    if (availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong)) {
      return 'بصمة الإصبع';
    }
    
    if (availableBiometrics.contains(BiometricType.face) ||
        availableBiometrics.contains(BiometricType.weak)) {
      return 'Face ID';
    }
    
    return 'بيومترية';
  }
}

/// نتيجة المصادقة البيومترية
enum BiometricResult {
  success,
  cancelled,
  notAvailable,
  notEnrolled,
  passcodeNotSet,
  lockedOut,
  permanentlyLockedOut,
  error,
}

/// امتداد PlatformException
class PlatformException implements Exception {
  final String code;
  final String? message;
  final dynamic details;

  PlatformException({
    required this.code,
    this.message,
    this.details,
  });
}
