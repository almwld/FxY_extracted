import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// شاشة بيانات الهوية
class IdentityInfoScreen extends StatefulWidget {
  const IdentityInfoScreen({super.key});

  @override
  State<IdentityInfoScreen> createState() => _IdentityInfoScreenState();
}

class _IdentityInfoScreenState extends State<IdentityInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idNumberController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    // إرسال البيانات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من الهوية'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // الشرح
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.goldColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.goldColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'نحتاج للتحقق من هويتك لضمان أمان حسابك',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // رقم الهوية
              CustomTextField(
                controller: _idNumberController,
                label: 'رقم الهوية',
                hint: 'أدخل رقم الهوية',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.badge_outlined,
                validator: Validators.validateIdNumber,
              ),
              const SizedBox(height: 20),
              // تاريخ الميلاد
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: 'تاريخ الميلاد',
                    hint: _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'اختر تاريخ الميلاد',
                    prefixIcon: Icons.calendar_today_outlined,
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // رفع الصور
              const Text(
                'صور الهوية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildImageUpload(
                      'الوجه الأمامي',
                      Icons.insert_drive_file,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageUpload(
                      'الوجه الخلفي',
                      Icons.insert_drive_file,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // صورة شخصية
              _buildImageUpload(
                'صورة شخصية',
                Icons.person,
              ),
              const SizedBox(height: 40),
              // زر الإرسال
              CustomButton(
                text: 'إرسال للتحقق',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUpload(String label, IconData icon) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
