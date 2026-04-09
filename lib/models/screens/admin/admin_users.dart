import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// شاشة إدارة المستخدمين
/// تعرض قائمة المستخدمين وتمكن المشرف من إدارتهم
class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث عن مستخدم...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ).animate().fadeIn(),
          
          // قائمة المستخدمين
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _UserCard(
                  name: 'مستخدم ${index + 1}',
                  email: 'user${index + 1}@example.com',
                  status: index % 3 == 0 ? 'محظور' : 'نشط',
                  onTap: () {},
                ).animate().fadeIn(delay: (index * 100).ms).slideX();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// بطاقة المستخدم
class _UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String status;
  final VoidCallback onTap;

  const _UserCard({
    required this.name,
    required this.email,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'نشط';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(name[0]),
        ),
        title: Text(name),
        subtitle: Text(email),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.success : AppColors.error,
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
