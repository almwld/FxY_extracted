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

/// شاشة دفع الفواتير
/// تتيح للمستخدم دفع الفواتير المختلفة
class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBillType;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _billTypes = [
    {'id': 'electricity', 'name': 'كهرباء', 'icon': Icons.electric_bolt},
    {'id': 'water', 'name': 'مياه', 'icon': Icons.water_drop},
    {'id': 'internet', 'name': 'إنترنت', 'icon': Icons.wifi},
    {'id': 'phone', 'name': 'هاتف', 'icon': Icons.phone},
    {'id': 'gas', 'name': 'غاز', 'icon': Icons.local_fire_department},
    {'id': 'tv', 'name': 'تلفزيون', 'icon': Icons.tv},
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// معالجة دفع الفاتورة
  Future<void> _handlePayBill() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBillType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار نوع الفاتورة')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.payBill(
        billType: _selectedBillType!,
        accountNumber: _accountNumberController.text,
        amount: amount,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم دفع الفاتورة بنجاح')),
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
        title: const Text(AppStrings.billPayment),
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
                'دفع الفواتير',
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
              
              // عنوان أنواع الفواتير
              Text(
                'نوع الفاتورة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(),
              
              const SizedBox(height: 16),
              
              // شبكة أنواع الفواتير
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _billTypes.length,
                itemBuilder: (context, index) {
                  final billType = _billTypes[index];
                  final isSelected = _selectedBillType == billType['id'];
                  
                  return _BillTypeCard(
                    icon: billType['icon'] as IconData,
                    title: billType['name'] as String,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedBillType = billType['id'] as String;
                      });
                    },
                  ).animate().fadeIn(delay: (300 + index * 50).ms).scale();
                },
              ),
              
              const SizedBox(height: 24),
              
              // حقل رقم الحساب
              CustomTextField(
                controller: _accountNumberController,
                label: 'رقم الحساب',
                hint: 'أدخل رقم حساب الفاتورة',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.account_circle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رقم الحساب مطلوب';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 600.ms).slideY(),
              
              const SizedBox(height: 16),
              
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
              ).animate().fadeIn(delay: 700.ms).slideY(),
              
              const SizedBox(height: 32),
              
              // زر الدفع
              CustomButton(
                text: 'دفع',
                onPressed: _handlePayBill,
                isLoading: _isLoading,
                icon: Icons.payment,
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
                        'تأكد من صحة رقم الحساب قبل الدفع',
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

/// بطاقة نوع الفاتورة
class _BillTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _BillTypeCard({
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
