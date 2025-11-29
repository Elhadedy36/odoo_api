import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_app/cubit/my_state_cubit.dart';
import 'package:vision_app/cubit/my_state_state.dart';
import 'package:vision_app/models/user.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Connect to Odoo when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyCubit>().connectToOdoo();
    });
  }

  String convertToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is bool) return value ? 'نعم' : 'لا';
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    return value.toString();
  }

  void _showEditDialog(User user) {
    nameController.text = convertToString(user.name);
    emailController.text = convertToString(user.email);
    phoneController.text = convertToString(user.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل العميل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'البريد'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'الهاتف'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final updatedUser = user.copyWith(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
              );
              context.read<MyCubit>().updateCustomer(updatedUser);
              Navigator.pop(context);
              nameController.clear();
              emailController.clear();
              phoneController.clear();
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العملاء - Odoo'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MyCubit>().loadCustomers(),
          ),
        ],
      ),
      body: BlocListener<MyCubit, MyState>(
        listener: (context, state) {
          if (state is MyOperationSuccess) {
            _showMessage(state.message);
            context.read<MyCubit>().clearOperationMessage();
          } else if (state is MyOperationError) {
            _showMessage(state.message);
            context.read<MyCubit>().clearOperationMessage();
          }
        },
        child: BlocBuilder<MyCubit, MyState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Connection status
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            (state is MyLoaded && state.isConnected) 
                                ? Icons.cloud_done 
                                : Icons.cloud_off,
                            color: (state is MyLoaded && state.isConnected) 
                                ? Colors.green 
                                : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            (state is MyLoaded && state.isConnected) 
                                ? 'متصل بقاعدة omar' 
                                : 'غير متصل',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (state is MyLoaded && state.isConnected) 
                                  ? Colors.green 
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Add customer form
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'إضافة عميل جديد',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'اسم العميل *',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: state is MyLoading
                                ? null
                                : () {
                                    context.read<MyCubit>().addCustomer(
                                          nameController.text,
                                          emailController.text,
                                          phoneController.text,
                                        );
                                    nameController.clear();
                                    emailController.clear();
                                    phoneController.clear();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: state is MyLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('إضافة عميل', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Customers list
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'قائمة العملاء (${state is MyLoaded ? state.users.length : 0})',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: state is MyLoading
                                      ? null
                                      : () => context.read<MyCubit>().loadCustomers(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _buildCustomersList(state),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomersList(MyState state) {
    if (state is MyLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is MyError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    } else if (state is MyLoaded) {
      final users = state.users;
      if (users.isEmpty) {
        return const Center(
          child: Text(
            'لا يوجد عملاء',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(convertToString(user.name)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (convertToString(user.email).isNotEmpty)
                    Text('📧 ${convertToString(user.email)}'),
                  if (convertToString(user.phone).isNotEmpty)
                    Text('📞 ${convertToString(user.phone)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _showEditDialog(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<MyCubit>().deleteCustomer(user.id!),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          'جارٍ التحميل...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}