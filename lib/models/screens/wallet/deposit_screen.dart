import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// شاشة الإيداع في المحفظة
/// تتيح للمستخدم إيداع الأموال في محفظته
class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'cash', 'name': 'نقدي', 'icon': Icons.money},
    {'id': 'bank', 'name': 'تحويل بنكي', 'icon': Icons.account_balance},
    {'id': 'card', 'name': 'بطاقة ائتمان', 'icon': Icons.credit_card},
    {'id': 'you', 'name': 'YOU Wallet', 'icon': Icons.wallet},
    {'id': 'ypay', 'name': 'YPay', 'icon': Icons.payment},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// معالجة الإيداع
  Future<void> _handleDeposit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار طريقة الدفع')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.deposit(
        amount: amount,
        paymentMethod: _selectedPaymentMethod!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الإيداع بنجاح')),
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
        title: const Text(AppStrings.deposit),
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
                'إيداع الأموال',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 8),
              
              Text(
                'أدخل المبلغ واختر طريقة الدفع',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(),
              
              const SizedBox(height: 32),
              
              // حقل المبلغ
              CustomTextField(
                controller: _amountController,
                label: 'المبلغ',
                hint: 'أدخل المبلغ بالريال اليمني',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.attach_money,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) => Validators.validateAmount(value, min: 100),
              ).animate().fadeIn(delay: 200.ms).slideY(),
              
              const SizedBox(height: 24),
              
              // عنوان طرق الدفع
              Text(
                'طريقة الدفع',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(),
              
              const SizedBox(height: 16),
              
              // قائمة طرق الدفع
              ...List.generate(_paymentMethods.length, (index) {
                final method = _paymentMethods[index];
                final isSelected = _selectedPaymentMethod == method['id'];
                
                return _PaymentMethodCard(
                  icon: method['icon'] as IconData,
                  title: method['name'] as String,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = method['id'] as String;
                    });
                  },
                ).animate().fadeIn(delay: (400 + index * 100).ms).slideX();
              }),
              
              const SizedBox(height: 32),
              
              // زر الإيداع
              CustomButton(
                text: 'إيداع',
                onPressed: _handleDeposit,
                isLoading: _isLoading,
                icon: Icons.arrow_forward,
              ).animate().fadeIn(delay: 800.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'سيتم معالجة الإيداع خلال 24 ساعة عمل',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// بطاقة طريقة الدفع
class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : null,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
