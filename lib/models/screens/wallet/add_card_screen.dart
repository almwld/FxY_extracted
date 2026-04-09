import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// شاشة إضافة بطاقة
/// تتيح للمستخدم إضافة بطاقة ائتمان/خصم جديدة
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;
  bool _isDefault = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  /// معالجة إضافة البطاقة
  Future<void> _handleAddCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.addCard(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cardHolder: _cardHolderController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
        isDefault: _isDefault,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة البطاقة بنجاح')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة بطاقة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان الشاشة
              Text(
                'إضافة بطاقة جديدة',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 8),
              
              Text(
                'أدخل بيانات بطاقتك بأمان',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(),
              
              const SizedBox(height: 32),
              
              // معاينة البطاقة
              _buildCardPreview().animate().fadeIn(delay: 200.ms).slideY(),
              
              const SizedBox(height: 32),
              
              // حقل رقم البطاقة
              CustomTextField(
                controller: _cardNumberController,
                label: 'رقم البطاقة',
                hint: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.credit_card,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  _CardNumberFormatter(),
                ],
                onChanged: (_) => setState(() {}),
                validator: Validators.validateCardNumber,
              ).animate().fadeIn(delay: 300.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل اسم حامل البطاقة
              CustomTextField(
                controller: _cardHolderController,
                label: 'اسم حامل البطاقة',
                hint: 'الاسم كما يظهر على البطاقة',
                prefixIcon: Icons.person,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'اسم حامل البطاقة مطلوب';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 400.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // صف تاريخ الانتهاء و CVV
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _expiryDateController,
                      label: 'تاريخ الانتهاء',
                      hint: 'MM/YY',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.calendar_today,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                      onChanged: (_) => setState(() {}),
                      validator: Validators.validateExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _cvvController,
                      label: 'CVV',
                      hint: '123',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.security,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: Validators.validateCVV,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // خيار البطاقة الافتراضية
              CheckboxListTile(
                title: const Text('تعيين كبطاقة افتراضية'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ).animate().fadeIn(delay: 600.ms),
              
              const SizedBox(height: 32),
              
              // زر الإضافة
              CustomButton(
                text: 'إضافة البطاقة',
                onPressed: _handleAddCard,
                isLoading: _isLoading,
                icon: Icons.add,
              ).animate().fadeIn(delay: 700.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // معلومات الأمان
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'بيانات بطاقتك محمية ومشفرة. لا نخزن بيانات CVV.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء معاينة البطاقة
  Widget _buildCardPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Text(
              _cardNumberController.text.isEmpty
                  ? '**** **** **** ****'
                  : _cardNumberController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حامل البطاقة',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      _cardHolderController.text.isEmpty
                          ? 'YOUR NAME'
                          : _cardHolderController.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ينتهي',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      _expiryDateController.text.isEmpty
                          ? 'MM/YY'
                          : _expiryDateController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// منسق رقم البطاقة
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// منسق تاريخ الانتهاء
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    if (text.length == 2 && !text.contains('/')) {
      return TextEditingValue(
        text: '$text/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
