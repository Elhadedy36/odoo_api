import 'package:odoo_rpc/odoo_rpc.dart';

class OdooService {
  final client = OdooClient('http://localhost:8067');
  
  Future<void> connect() async {
    try {
      // المصادقة
      await client.authenticate('omar', 'admin', 'admin');
      print('تم الاتصال بنجاح!');
    } catch (e) {
      print('خطأ في الاتصال: $e');
    }
  }
  
  // مثال لجلب العملاء
  Future<List<dynamic>> getCustomers() async {
    return await client.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': [['customer', '=', true]],
        'fields': ['id', 'name', 'email', 'phone'],
      },
    });
  }
  
  // مثال لإنشاء موعد
  Future<dynamic> createAppointment(Map<String, dynamic> data) async {
    return await client.callKw({
      'model': 'calendar.event',
      'method': 'create',
      'args': [data],
      'kwargs': {},
    });
  }
}