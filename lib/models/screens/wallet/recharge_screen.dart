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

/// شاشة شحن الجوال
/// تتيح للمستخدم شحن رصيد الهاتف
class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _selectedAmount;
  String? _selectedOperator;
  bool _isLoading = false;

  final List<String> _amounts = [
    '500',
    '1000',
    '2000',
    '5000',
    '10000',
  ];

  final List<Map<String, dynamic>> _operators = [
    {'id': 'yemen_mobile', 'name': 'يمن موبايل', 'color': Colors.red},
    {'id': 'sabafon', 'name': 'صبافون', 'color': Colors.blue},
    {'id': 'you', 'name': 'YOU', 'color': Colors.orange},
    {'id': 'y', 'name': 'Y', 'color': Colors.green},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// معالجة الشحن
  Future<void> _handleRecharge() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المبلغ')),
      );
      return;
    }
    if (_selectedOperator == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المشغل')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_selectedAmount!);
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.rechargePhone(
        phoneNumber: _phoneController.text,
        amount: amount,
        operator: _selectedOperator!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الشحن بنجاح')),
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
        title: const Text(AppStrings.mobileRecharge),
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
                'شحن رصيد الجوال',
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
              
              // حقل رقم الهاتف
              CustomTextField(
                controller: _phoneController,
                label: 'رقم الهاتف',
                hint: 'أدخل رقم الهاتف للشحن',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: Validators.validatePhone,
              ).animate().fadeIn(delay: 200.ms).slideY(),
              
              const SizedBox(height: 24),
              
              // عنوان المشغل
              Text(
                'اختر المشغل',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(),
              
              const SizedBox(height: 16),
              
              // قائمة المشغلين
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _operators.map((operator) {
                  final isSelected = _selectedOperator == operator['id'];
                  return _OperatorChip(
                    name: operator['name'] as String,
                    color: operator['color'] as Color,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedOperator = operator['id'] as String;
                      });
                    },
                  );
                }).toList(),
              ).animate().fadeIn(delay: 400.ms),
              
              const SizedBox(height: 24),
              
              // عنوان المبلغ
              Text(
                'اختر المبلغ',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 500.ms).slideX(),
              
              const SizedBox(height: 16),
              
              // شبكة المبالغ
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _amounts.map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return _AmountChip(
                    amount: amount,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedAmount = amount;
                      });
                    },
                  );
                }).toList(),
              ).animate().fadeIn(delay: 600.ms),
              
              const SizedBox(height: 32),
              
              // زر الشحن
              CustomButton(
                text: 'شحن',
                onPressed: _handleRecharge,
                isLoading: _isLoading,
                icon: Icons.phone_android,
              ).animate().fadeIn(delay: 700.ms).slideY(),
              
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
                        'سيتم إضافة الرصيد فوراً بعد تأكيد الدفع',
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
}

/// شريحة المشغل
class _OperatorChip extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _OperatorChip({
    required this.name,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// شريحة المبلغ
class _AmountChip extends StatelessWidget {
  final String amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmountChip({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          '$amount ر.ي',
          style: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
