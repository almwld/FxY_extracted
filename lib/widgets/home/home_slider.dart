import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../core/constants/app_colors.dart';

/// سلايدر الصفحة الرئيسية
class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'تخفيضات كبرى',
      'subtitle': 'خصم يصل إلى 50% على جميع المنتجات',
      'color': AppColors.goldColor,
    },
    {
      'title': 'منتجات جديدة',
      'subtitle': 'اكتشف أحدث المنتجات المضافة',
      'color': Colors.blue,
    },
    {
      'title': 'شحن مجاني',
      'subtitle': 'على الطلبات فوق 10,000 ر.ي',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _slides.map((slide) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    slide['color'] as Color,
                    (slide['color'] as Color).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slide['title'] as String,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      slide['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: slide['color'] as Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('تسوق الآن'),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // مؤشرات
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _slides.asMap().entries.map((entry) {
            return Container(
              width: _currentIndex == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == entry.key
                    ? AppColors.goldColor
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
