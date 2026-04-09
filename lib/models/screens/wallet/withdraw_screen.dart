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

/// شاشة السحب من المحفظة
/// تتيح للمستخدم سحب الأموال من محفظته
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  String? _selectedWithdrawMethod;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _withdrawMethods = [
    {'id': 'cash', 'name': 'نقدي', 'icon': Icons.money},
    {'id': 'bank', 'name': 'تحويل بنكي', 'icon': Icons.account_balance},
    {'id': 'card', 'name': 'بطاقة ائتمان', 'icon': Icons.credit_card},
    {'id': 'you', 'name': 'YOU Wallet', 'icon': Icons.wallet},
    {'id': 'ypay', 'name': 'YPay', 'icon': Icons.payment},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  /// معالجة السحب
  Future<void> _handleWithdraw() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWithdrawMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار طريقة السحب')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.withdraw(
        amount: amount,
        withdrawMethod: _selectedWithdrawMethod!,
        accountNumber: _accountNumberController.text,
        accountName: _accountNameController.text.isNotEmpty
            ? _accountNameController.text
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم طلب السحب بنجاح')),
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
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.withdraw),
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
                'سحب الأموال',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 8),
              
              // الرصيد المتاح
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الرصيد المتاح',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          walletProvider.formattedBalance,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(),
              
              const SizedBox(height: 24),
              
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
              
              // عنوان طرق السحب
              Text(
                'طريقة السحب',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(),
              
              const SizedBox(height: 16),
              
              // قائمة طرق السحب
              ...List.generate(_withdrawMethods.length, (index) {
                final method = _withdrawMethods[index];
                final isSelected = _selectedWithdrawMethod == method['id'];
                
                return _WithdrawMethodCard(
                  icon: method['icon'] as IconData,
                  title: method['name'] as String,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedWithdrawMethod = method['id'] as String;
                    });
                  },
                ).animate().fadeIn(delay: (400 + index * 100).ms).slideX();
              }),
              
              const SizedBox(height: 24),
              
              // حقل رقم الحساب
              CustomTextField(
                controller: _accountNumberController,
                label: 'رقم الحساب / الهاتف',
                hint: 'أدخل رقم الحساب أو الهاتف',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: Validators.validatePhone,
              ).animate().fadeIn(delay: 800.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل اسم الحساب (اختياري)
              CustomTextField(
                controller: _accountNameController,
                label: 'اسم صاحب الحساب (اختياري)',
                hint: 'أدخل اسم صاحب الحساب',
                prefixIcon: Icons.person,
              ).animate().fadeIn(delay: 900.ms).slideY(),
              
              const SizedBox(height: 32),
              
              // زر السحب
              CustomButton(
                text: 'سحب',
                onPressed: _handleWithdraw,
                isLoading: _isLoading,
                icon: Icons.arrow_forward,
              ).animate().fadeIn(delay: 1000.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.warning),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'قد تستغرق عملية السحب من 1-3 أيام عمل',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1100.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// بطاقة طريقة السحب
class _WithdrawMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _WithdrawMethodCard({
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
