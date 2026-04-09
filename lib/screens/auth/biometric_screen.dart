import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/biometric/biometric_service.dart';
import '../../widgets/common/custom_button.dart';

/// شاشة المصادقة البيومترية
class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isSupported = false;
  String _biometricType = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final isSupported = await _biometricService.isDeviceSupported();
    final canCheck = await _biometricService.canCheckBiometrics();
    final type = await _biometricService.getAvailableBiometricType();

    setState(() {
      _isSupported = isSupported && canCheck;
      _biometricType = type;
    });
  }

  Future<void> _authenticate() async {
    final result = await _biometricService.authenticate();
    
    if (result == BiometricResult.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التحقق بنجاح')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل التحقق')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المصادقة البيومترية'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // الأيقونة
            Icon(
              Icons.fingerprint,
              size: 100,
              color: _isSupported
                  ? AppColors.goldColor
                  : Colors.grey,
            ),
            const SizedBox(height: 40),
            // العنوان
            Text(
              _isSupported
                  ? '$_biometricType متاح'
                  : 'المصادقة البيومترية غير متاحة',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isSupported
                  ? 'يمكنك استخدام $_biometricType لتسجيل الدخول بسرعة وأمان'
                  : 'جهازك لا يدعم المصادقة البيومترية',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // الإعدادات
            if (_isSupported) ...[
              SwitchListTile(
                title: Text('تفعيل $_biometricType'),
                subtitle: Text('استخدم $_biometricType لتسجيل الدخول'),
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.goldColor,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'اختبار $_biometricType',
                onPressed: _authenticate,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
