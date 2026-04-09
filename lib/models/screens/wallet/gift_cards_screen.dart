import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../models/wallet/gift_card.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// شاشة بطاقات الهدايا
/// تتيح للمستخدم شراء واستخدام بطاقات الهدايا
class GiftCardsScreen extends StatefulWidget {
  const GiftCardsScreen({super.key});

  @override
  State<GiftCardsScreen> createState() => _GiftCardsScreenState();
}

class _GiftCardsScreenState extends State<GiftCardsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGiftCards();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// تحميل بطاقات الهدايا
  Future<void> _loadGiftCards() async {
    final walletProvider = context.read<WalletProvider>();
    await walletProvider.loadGiftCards();
  }

  /// استرداد بطاقة الهدايا
  Future<void> _redeemGiftCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final walletProvider = context.read<WalletProvider>();
      await walletProvider.redeemGiftCard(_codeController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم استرداد بطاقة الهدايا بنجاح')),
        );
        _codeController.clear();
        _loadGiftCards();
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
    final giftCards = walletProvider.giftCards;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.giftCards),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'بطاقاتي'),
              Tab(text: 'استرداد'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // تبويب بطاقاتي
            _buildMyGiftCardsTab(theme, walletProvider, giftCards),
            // تبويب الاسترداد
            _buildRedeemTab(theme),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showBuyGiftCardDialog(context);
          },
          icon: const Icon(Icons.card_giftcard),
          label: const Text('شراء بطاقة'),
        ),
      ),
    );
  }

  /// بناء تبويب بطاقاتي
  Widget _buildMyGiftCardsTab(
    ThemeData theme,
    WalletProvider walletProvider,
    List<GiftCard> giftCards,
  ) {
    if (walletProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (giftCards.isEmpty) {
      return _buildEmptyState(theme);
    }

    return RefreshIndicator(
      onRefresh: _loadGiftCards,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: giftCards.length,
        itemBuilder: (context, index) {
          final card = giftCards[index];
          return _GiftCardItem(
            giftCard: card,
          ).animate().fadeIn(delay: (index * 100).ms).slideY();
        },
      ),
    );
  }

  /// بناء تبويب الاسترداد
  Widget _buildRedeemTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'استرداد بطاقة الهدايا',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().slideX(),
            
            const SizedBox(height: 16),
            
            Text(
              'أدخل كود بطاقة الهدايا لاسترداد قيمتها',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 100.ms).slideX(),
            
            const SizedBox(height: 32),
            
            // حقل الكود
            CustomTextField(
              controller: _codeController,
              label: 'كود البطاقة',
              hint: 'أدخل كود بطاقة الهدايا',
              prefixIcon: Icons.card_giftcard,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'كود البطاقة مطلوب';
                }
                return null;
              },
            ).animate().fadeIn(delay: 200.ms).slideY(),
            
            const SizedBox(height: 32),
            
            // زر الاسترداد
            CustomButton(
              text: 'استرداد',
              onPressed: _redeemGiftCard,
              isLoading: _isLoading,
              icon: Icons.redeem,
            ).animate().fadeIn(delay: 300.ms).slideY(),
            
            const SizedBox(height: 24),
            
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
                      'يمكنك استرداد بطاقة الهدايا مرة واحدة فقط',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_giftcard_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد بطاقات هدايا',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اشترِ بطاقة هدايا أو استرد كوداً',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  /// عرض حوار شراء بطاقة الهدايا
  void _showBuyGiftCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('شراء بطاقة هدايا'),
          content: const Text(
            'سيتم توجيهك إلى صفحة شراء بطاقات الهدايا',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to buy gift card screen
              },
              child: const Text('متابعة'),
            ),
          ],
        );
      },
    );
  }
}

/// عنصر بطاقة الهدايا
class _GiftCardItem extends StatelessWidget {
  final GiftCard giftCard;

  const _GiftCardItem({
    required this.giftCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.primaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 40,
                  ),
                  if (giftCard.isRedeemed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'مستردة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else if (giftCard.isExpired)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'منتهية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'نشطة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                giftCard.formattedAmount,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'كود: ${giftCard.maskedCode}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تنتهي: ${giftCard.expiryDate.day}/${giftCard.expiryDate.month}/${giftCard.expiryDate.year}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
