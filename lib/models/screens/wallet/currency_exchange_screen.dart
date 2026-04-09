import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/validators.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// شاشة تحويل العملات
/// تتيح للمستخدم تحويل العملات بين مختلف العملات
class CurrencyExchangeScreen extends StatefulWidget {
  const CurrencyExchangeScreen({super.key});

  @override
  State<CurrencyExchangeScreen> createState() => _CurrencyExchangeScreenState();
}

class _CurrencyExchangeScreenState extends State<CurrencyExchangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _fromCurrency = 'YER';
  String _toCurrency = 'USD';
  double? _convertedAmount;
  bool _isLoading = false;

  final List<String> _currencies = ['YER', 'USD', 'SAR', 'EUR', 'GBP'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// تحويل العملة
  void _convertCurrency() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final rate = CurrencyUtils.getExchangeRate(_toCurrency) /
        CurrencyUtils.getExchangeRate(_fromCurrency);

    setState(() {
      _convertedAmount = amount * rate;
    });
  }

  /// معالجة التحويل
  Future<void> _handleExchange() async {
    if (_convertedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تحويل العملة أولاً')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.exchangeCurrency(
        amount: amount,
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
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

  /// تبديل العملات
  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _convertedAmount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.currencyExchange),
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
                'تحويل العملات',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 8),
              
              Text(
                'حول بين العملات المختلفة بسعر صرف تنافسي',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(),
              
              const SizedBox(height: 32),
              
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
              ).animate().fadeIn(delay: 200.ms).slideY(),
              
              const SizedBox(height: 32),
              
              // العملة المصدر
              _buildCurrencySelector(
                label: 'من',
                selectedCurrency: _fromCurrency,
                onChanged: (value) {
                  setState(() {
                    _fromCurrency = value!;
                    _convertedAmount = null;
                  });
                },
              ).animate().fadeIn(delay: 300.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // زر التبديل
              Center(
                child: IconButton(
                  onPressed: _swapCurrencies,
                  icon: const Icon(Icons.swap_vert),
                  iconSize: 40,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 400.ms).scale(),
              
              const SizedBox(height: 16),
              
              // العملة الهدف
              _buildCurrencySelector(
                label: 'إلى',
                selectedCurrency: _toCurrency,
                onChanged: (value) {
                  setState(() {
                    _toCurrency = value!;
                    _convertedAmount = null;
                  });
                },
              ).animate().fadeIn(delay: 500.ms).slideY(),
              
              const SizedBox(height: 24),
              
              // حقل المبلغ
              CustomTextField(
                controller: _amountController,
                label: 'المبلغ',
                hint: 'أدخل المبلغ',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.attach_money,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) => Validators.validateAmount(value, min: 1),
              ).animate().fadeIn(delay: 600.ms).slideY(),
              
              const SizedBox(height: 24),
              
              // زر التحويل
              CustomButton(
                text: 'تحويل',
                onPressed: _convertCurrency,
                icon: Icons.currency_exchange,
              ).animate().fadeIn(delay: 700.ms).slideY(),
              
              // عرض النتيجة
              if (_convertedAmount != null) ...[
                const SizedBox(height: 32),
                
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'المبلغ المحول',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_convertedAmount!.toStringAsFixed(2)} $_toCurrency',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'سعر الصرف: 1 $_fromCurrency = ${(CurrencyUtils.getExchangeRate(_toCurrency) / CurrencyUtils.getExchangeRate(_fromCurrency)).toStringAsFixed(4)} $_toCurrency',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'تأكيد التحويل',
                        onPressed: _handleExchange,
                        isLoading: _isLoading,
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms).slideY(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// بناء محدد العملة
  Widget _buildCurrencySelector({
    required String label,
    required String selectedCurrency,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Row(
                    children: [
                      Text(
                        CurrencyUtils.getCurrencySymbol(currency),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(currency),
                      const SizedBox(width: 8),
                      Text(
                        '(${CurrencyUtils.getCurrencyName(currency)})',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
