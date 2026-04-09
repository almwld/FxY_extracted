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

/// شاشة إضافة حساب بنكي
/// تتيح للمستخدم إضافة حساب بنكي جديد
class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _ibanController = TextEditingController();
  String? _selectedBank;
  String? _selectedAccountType;
  bool _isLoading = false;
  bool _isDefault = false;

  final List<Map<String, dynamic>> _banks = [
    {'id': 'cby', 'name': 'البنك المركزي اليمني'},
    {'id': 'tadhamon', 'name': 'بنك التضامن'},
    {'id': 'saba', 'name': 'بنك صنعاء'},
    {'id': 'ahli', 'name': 'البنك الأهلي'},
    {'id': 'yemen_kuwait', 'name': 'بنك اليمن الكويتي'},
    {'id': 'yemen_gulf', 'name': 'بنك اليمن والخليج'},
    {'id': 'yemen_international', 'name': 'البنك اليمني الدولي'},
    {'id': 'shamil', 'name': 'بنك الشامل'},
  ];

  final List<Map<String, dynamic>> _accountTypes = [
    {'id': 'current', 'name': 'حساب جاري'},
    {'id': 'savings', 'name': 'حساب توفير'},
    {'id': 'business', 'name': 'حساب تجاري'},
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  /// معالجة إضافة الحساب
  Future<void> _handleAddAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار البنك')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final walletProvider = context.read<WalletProvider>();
      
      await walletProvider.addBankAccount(
        bankId: _selectedBank!,
        accountNumber: _accountNumberController.text,
        accountName: _accountNameController.text,
        iban: _ibanController.text.isNotEmpty ? _ibanController.text : null,
        accountType: _selectedAccountType,
        isDefault: _isDefault,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة الحساب البنكي بنجاح')),
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
        title: const Text('إضافة حساب بنكي'),
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
                'إضافة حساب بنكي جديد',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 8),
              
              Text(
                'أدخل بيانات حسابك البنكي',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(),
              
              const SizedBox(height: 32),
              
              // اختيار البنك
              _buildBankSelector().animate().fadeIn(delay: 200.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل رقم الحساب
              CustomTextField(
                controller: _accountNumberController,
                label: 'رقم الحساب',
                hint: 'أدخل رقم الحساب البنكي',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.account_balance,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رقم الحساب مطلوب';
                  }
                  if (value.length < 10) {
                    return 'رقم الحساب يجب أن يكون 10 أرقام على الأقل';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 300.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل اسم صاحب الحساب
              CustomTextField(
                controller: _accountNameController,
                label: 'اسم صاحب الحساب',
                hint: 'أدخل الاسم كما يظهر في البنك',
                prefixIcon: Icons.person,
                validator: Validators.validateName,
              ).animate().fadeIn(delay: 400.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // حقل IBAN (اختياري)
              CustomTextField(
                controller: _ibanController,
                label: 'رقم IBAN (اختياري)',
                hint: 'YE00 0000 0000 0000 0000 0000',
                prefixIcon: Icons.format_list_numbered,
                textCapitalization: TextCapitalization.characters,
              ).animate().fadeIn(delay: 500.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // اختيار نوع الحساب
              _buildAccountTypeSelector().animate().fadeIn(delay: 600.ms).slideY(),
              
              const SizedBox(height: 16),
              
              // خيار الحساب الافتراضي
              CheckboxListTile(
                title: const Text('تعيين كحساب افتراضي'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ).animate().fadeIn(delay: 700.ms),
              
              const SizedBox(height: 32),
              
              // زر الإضافة
              CustomButton(
                text: 'إضافة الحساب',
                onPressed: _handleAddAccount,
                isLoading: _isLoading,
                icon: Icons.add,
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
                        'سيتم التحقق من الحساب البنكي قبل تفعيله',
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

  /// بناء محدد البنك
  Widget _buildBankSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر البنك',
          style: TextStyle(
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
              value: _selectedBank,
              isExpanded: true,
              hint: const Text('اختر البنك'),
              items: _banks.map((bank) {
                return DropdownMenuItem(
                  value: bank['id'] as String,
                  child: Text(bank['name'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// بناء محدد نوع الحساب
  Widget _buildAccountTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع الحساب',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: _accountTypes.map((type) {
            final isSelected = _selectedAccountType == type['id'];
            return ChoiceChip(
              label: Text(type['name'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedAccountType = selected ? type['id'] as String : null;
                });
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
