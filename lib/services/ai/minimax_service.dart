import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MiniMaxService {
  static final MiniMaxService _instance = MiniMaxService._internal();
  factory MiniMaxService() => _instance;
  MiniMaxService._internal();

  final String _baseUrl = 'https://api.minimax.io/anthropic';
  late final String _apiKey;

  Future<void> init() async {
    await dotenv.load();
    _apiKey = dotenv.env['MINIMAX_API_KEY'] ?? '';
  }

  Future<String> generateProductDescription(String productName, String category) async {
    if (_apiKey.isEmpty) return _getMockDescription(productName);
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: jsonEncode({
          'model': 'MiniMax-M2.7',
          'max_tokens': 500,
          'system': 'أنت مساعد متخصص في كتابة أوصاف المنتجات للتسويق الإلكتروني.',
          'messages': [
            {
              'role': 'user',
              'content': 'اكتب وصفاً احترافياً جذاباً لمنتج "$productName" في قسم "$category". كن مقنعاً وموجزاً (50-80 كلمة).'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'] ?? _getMockDescription(productName);
      }
      return _getMockDescription(productName);
    } catch (e) {
      print('❌ خطأ في MiniMax API: $e');
      return _getMockDescription(productName);
    }
  }

  Future<String> generateChatResponse(String userMessage, String context) async {
    if (_apiKey.isEmpty) return _getMockChatResponse(userMessage);
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: jsonEncode({
          'model': 'MiniMax-M2.7',
          'max_tokens': 1000,
          'system': 'أنت مساعد دعم عملاء في منصة "فلكس يمن" للتجارة الإلكترونية. كن مهذباً ومفيداً.',
          'messages': [
            {'role': 'user', 'content': userMessage}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'] ?? _getMockChatResponse(userMessage);
      }
      return _getMockChatResponse(userMessage);
    } catch (e) {
      print('❌ خطأ في MiniMax API: $e');
      return _getMockChatResponse(userMessage);
    }
  }

  String _getMockDescription(String productName) {
    final descriptions = [
      '🌟 منتج رائع وفريد من نوعه! $productName يتميز بجودة عالية وسعر منافس.',
      '✨ اكتشف الجودة مع $productName - خيارك الأمثل للتميز.',
      '💎 $productName: مزيج مثالي من الأناقة والجودة العالية.',
    ];
    return descriptions[DateTime.now().millisecond % descriptions.length];
  }

  String _getMockChatResponse(String message) {
    if (message.contains('سعر') || message.contains('price')) {
      return '💰 الأسعار تبدأ من 1000 ريال. يمكنك الاطلاع على التفاصيل في صفحة المنتج.';
    }
    if (message.contains('شحن') || message.contains('delivery')) {
      return '🚚 نوفر خدمة التوصيل لجميع المحافظات خلال 3-5 أيام عمل.';
    }
    if (message.contains('مرجع') || message.contains('return')) {
      return '🔄 يمكنك إرجاع المنتج خلال 14 يوماً من تاريخ الاستلام.';
    }
    return 'شكراً لتواصلك مع فريق دعم فلكس يمن. كيف يمكننا مساعدتك؟ 😊';
  }
}
