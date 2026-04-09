import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// شاشة إدارة الطلبات
/// تعرض قائمة الطلبات وتمكن المشرف من إدارتها
class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  final List<String> _statuses = ['الكل', 'قيد الانتظار', 'قيد المعالجة', 'تم الشحن', 'تم التوصيل'];
  String _selectedStatus = 'الكل';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
      ),
      body: Column(
        children: [
          // شريط التصفية
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _statuses.length,
              itemBuilder: (context, index) {
                final status = _statuses[index];
                final isSelected = _selectedStatus == status;
                
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(),
          
          // قائمة الطلبات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _OrderCard(
                  orderNumber: '#ORD-${1000 + index}',
                  customer: 'عميل ${index + 1}',
                  total: '${(index + 1) * 5000} ر.ي',
                  status: _statuses[index % _statuses.length],
                  onTap: () {},
                ).animate().fadeIn(delay: (index * 100).ms).slideX();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة الطلب
class _OrderCard extends StatelessWidget {
  final String orderNumber;
  final String customer;
  final String total;
  final String status;
  final VoidCallback onTap;

  const _OrderCard({
    required this.orderNumber,
    required this.customer,
    required this.total,
    required this.status,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'قيد الانتظار':
        return AppColors.warning;
      case 'قيد المعالجة':
        return AppColors.info;
      case 'تم الشحن':
        return Colors.blue;
      case 'تم التوصيل':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.shopping_bag, color: AppColors.primary),
        ),
        title: Text(orderNumber),
        subtitle: Text('$customer - $total'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
