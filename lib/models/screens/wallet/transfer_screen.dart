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

/// شاشة التحويل من المحفظة
/// تتيح للمستخدم تحويل الأموال إلى مستخدم آخر
class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientPhoneController.dispose();
    _recipientNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// معالجة التحويل
  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.transfer(
        amount: amount,
        recipientPhone: _recipientPhoneController.text,
        recipientName: _recipientNameController.text.isNotEmpty
            ? _recipientNameController.text
            : null,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التحويل بنجاح')),
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
        title: const Text(AppStrings.transfer),
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
                'تحويل الأموال',
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
              
              // حقل رقم الهاتف المستلم
              CustomTextField(
                controller: _recipientPhoneController,
                label: 'رقم هاتف المستلم',
                hint: 'أدخل رقم هاتف المستلم',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: Validators.validatePhone,
              ).animate().fadeIn(delay: 200.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل اسم المستلم (اختياري)
              CustomTextField(
                controller: _recipientNameController,
                label: 'اسم المستلم (اختياري)',
                hint: 'أدخل اسم المستلم',
                prefixIcon: Icons.person,
              ).animate().fadeIn(delay: 300.ms).slideY(),
              
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
              ).animate().fadeIn(delay: 400.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل الملاحظة (اختياري)
              CustomTextField(
                controller: _noteController,
                label: 'ملاحظة (اختياري)',
                hint: 'أدخل ملاحظة للتحويل',
                prefixIcon: Icons.note,
                maxLines: 3,
              ).animate().fadeIn(delay: 500.ms).slideY(),
              
              const SizedBox(height: 32),
              
              // زر التحويل
              CustomButton(
                text: 'تحويل',
                onPressed: _handleTransfer,
                isLoading: _isLoading,
                icon: Icons.send,
              ).animate().fadeIn(delay: 600.ms).slideY(),
              
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
                        'سيتم إرسال إشعار للمستلم فوراً بعد إتمام التحويل',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}
