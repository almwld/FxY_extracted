import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';

/// شاشة رمز QR
/// تعرض رمز QR للمستخدم وتمكنه من مسح رموز QR
class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _amountController = TextEditingController();
  String? _qrData;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateQrCode();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// توليد رمز QR
  void _generateQrCode() {
    final walletProvider = context.read<WalletProvider>();
    final userId = walletProvider.userId;
    final amount = _amountController.text;
    
    setState(() {
      _qrData = 'flexyemen://payment?userId=$userId&amount=$amount';
    });
  }

  /// مشاركة رمز QR
  Future<void> _shareQrCode() async {
    if (_qrData == null) return;
    
    await Share.share(
      'استخدم هذا الرمز للدفع: $_qrData',
      subject: 'دفع عبر Flex Yemen',
    );
  }

  /// نسخ رمز QR
  Future<void> _copyQrCode() async {
    if (_qrData == null) return;
    
    await Clipboard.setData(ClipboardData(text: _qrData!));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نسخ الرمز')),
      );
    }
  }

  /// معالجة مسح رمز QR
  void _onQrCodeScanned(String code) {
    setState(() {
      _isScanning = false;
    });

    // TODO: Handle scanned QR code
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('رمز QR ممسوح'),
          content: Text('البيانات: $code'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Process payment
              },
              child: const Text('متابعة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('رمز QR'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code), text: 'رمزي'),
            Tab(icon: Icon(Icons.qr_code_scanner), text: 'مسح'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // تبويب عرض رمز QR
          _buildMyQrTab(theme),
          // تبويب مسح رمز QR
          _buildScanQrTab(),
        ],
      ),
    );
  }

  /// بناء تبويب رمزي
  Widget _buildMyQrTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // عنوان
          Text(
            'امسح الرمز للدفع',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideY(),
          
          const SizedBox(height: 8),
          
          Text(
            'شارك هذا الرمز مع الآخرين لاستلام المدفوعات',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 100.ms).slideY(),
          
          const SizedBox(height: 32),
          
          // حقل المبلغ (اختياري)
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'المبلغ (اختياري)',
              hintText: 'أدخل المبلغ المطلوب',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => _generateQrCode(),
          ).animate().fadeIn(delay: 200.ms).slideY(),
          
          const SizedBox(height: 32),
          
          // رمز QR
          if (_qrData != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: QrImageView(
                data: _qrData!,
                version: QrVersions.auto,
                size: 250,
                backgroundColor: Colors.white,
                errorStateBuilder: (context, error) {
                  return const Center(
                    child: Text('خطأ في توليد الرمز'),
                  );
                },
              ),
            ).animate().fadeIn(delay: 300.ms).scale(),
          
          const SizedBox(height: 32),
          
          // أزرار المشاركة والنسخ
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'مشاركة',
                  onPressed: _shareQrCode,
                  icon: Icons.share,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'نسخ',
                  onPressed: _copyQrCode,
                  icon: Icons.copy,
                  isOutlined: true,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms).slideY(),
        ],
      ),
    );
  }

  /// بناء تبويب المسح
  Widget _buildScanQrTab() {
    if (_isScanning) {
      return Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _onQrCodeScanned(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          // Overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // زر الإغلاق
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isScanning = false;
                });
              },
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 100,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 24),
          Text(
            'امسح رمز QR للدفع',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'وجه الكاميرا نحو رمز QR للمسح',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'بدء المسح',
            onPressed: () {
              setState(() {
                _isScanning = true;
              });
            },
            icon: Icons.camera_alt,
          ),
        ],
      ),
    );
  }
}
