

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_app/cubit/my_state_state.dart';
import 'package:vision_app/models/user.dart';
import 'package:vision_app/my_repo.dart';

class MyCubit extends Cubit<MyState> {
  final MyRepo myRepo;

  MyCubit(this.myRepo) : super(MyInitial());

  bool isConnected = false;
  List<User> users = [];

  // Connect to Odoo
  Future<void> connectToOdoo() async {
    emit(MyLoading());
    try {
      isConnected = await myRepo.authenticate('admin', 'admin');
      if (isConnected) {
        await loadCustomers();
      } else {
        emit(MyError('فشل في الاتصال بـ Odoo'));
      }
    } catch (e) {
      emit(MyError('خطأ في الاتصال: $e'));
    }
  }

  // Load customers
  Future<void> loadCustomers() async {
    emit(MyLoading());
    try {
      users = await myRepo.getAllCustomers();
      emit(MyLoaded(users: users, isConnected: isConnected));
    } catch (e) {
      emit(MyError('فشل في تحميل العملاء: $e'));
    }
  }

  // Add customer
  Future<void> addCustomer(String name, String email, String phone) async {
    if (name.isEmpty) {
      emit(MyOperationError('الاسم مطلوب'));
      return;
    }

    final user = User(name: name, email: email, phone: phone);
    
    try {
      final newId = await myRepo.createCustomer(user);
      if (newId != null && newId > 0) {
        emit(MyOperationSuccess('تم إضافة العميل بنجاح'));
        await loadCustomers();
      } else {
        emit(MyOperationError('فشل في إضافة العميل'));
      }
    } catch (e) {
      emit(MyOperationError('فشل في إضافة العميل: $e'));
    }
  }

  // Update customer
  Future<void> updateCustomer(User user) async {
    try {
      final success = await myRepo.updateCustomer(user);
      if (success) {
        emit(MyOperationSuccess('تم تعديل العميل بنجاح'));
        await loadCustomers();
      } else {
        emit(MyOperationError('فشل في تعديل العميل'));
      }
    } catch (e) {
      emit(MyOperationError('فشل في تعديل العميل: $e'));
    }
  }

  // Delete customer
  Future<void> deleteCustomer(int id) async {
    try {
      final success = await myRepo.deleteCustomer(id);
      if (success) {
        emit(MyOperationSuccess('تم حذف العميل بنجاح'));
        await loadCustomers();
      } else {
        emit(MyOperationError('فشل في حذف العميل'));
      }
    } catch (e) {
      emit(MyOperationError('فشل في حذف العميل: $e'));
    }
  }

  // Clear operation messages
  void clearOperationMessage() {
    if (state is MyLoaded) {
      emit(MyLoaded(users: users, isConnected: isConnected));
    }
  }
}