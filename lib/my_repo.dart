import 'models/user.dart';
import 'web_services.dart';

class MyRepo {
  final WebServices webServices;
  final String database = 'omar';
  final String password = 'admin';
  int userId = 0;

  MyRepo(this.webServices);

  // Authentication
  Future<bool> authenticate(String login, String password) async {
    try {
      final response = await webServices.authenticate({
        'jsonrpc': '2.0',
        'params': {
          'db': database,
          'login': login,
          'password': password,
        },
      });

      if (response['result'] != null) {
        userId = response['result']['uid'];
        return true;
      }
      return false;
    } catch (e) {
      print('Auth error: $e');
      return false;
    }
  }

  // Get all customers
  Future<List<User>> getAllCustomers() async {
    try {
      final response = await webServices.getCustomers({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'service': 'object',
          'method': 'execute_kw',
          'args': [
            database,
            userId,
            password,
            'res.partner',
            'search_read',
            [],
            {
              'domain': [['company_type', '=', 'person']],
              'fields': ['id', 'name', 'email', 'phone'],
              'limit': 20,
            },
          ]
        },
        'id': 1,
      });

      // Extract the actual result from JSON-RPC response
      if (response['result'] != null) {
        final List<dynamic> results = response['result'];
        return results.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get customers error: $e');
      return [];
    }
  }

  // Create customer
  Future<int?> createCustomer(User user) async {
    try {
      final response = await webServices.createCustomer({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'service': 'object',
          'method': 'execute_kw',
          'args': [
            database,
            userId,
            password,
            'res.partner',
            'create',
            [
              {
                'name': user.name,
                'email': user.email,
                'phone': user.phone,
                'company_type': 'person',
              }
            ],
          ]
        },
        'id': 1,
      });

      // Extract the created ID from JSON-RPC response
      return response['result'];
    } catch (e) {
      print('Create customer error: $e');
      return null;
    }
  }

  // Update customer
  Future<bool> updateCustomer(User user) async {
    try {
      final response = await webServices.updateCustomer({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'service': 'object',
          'method': 'execute_kw',
          'args': [
            database,
            userId,
            password,
            'res.partner',
            'write',
            [
              [user.id],
              {
                'name': user.name,
                'email': user.email,
                'phone': user.phone,
              }
            ],
          ]
        },
        'id': 1,
      });

      // Extract the success status from JSON-RPC response
      return response['result'] == true;
    } catch (e) {
      print('Update customer error: $e');
      return false;
    }
  }

  // Delete customer
  Future<bool> deleteCustomer(int id) async {
    try {
      final response = await webServices.deleteCustomer({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'service': 'object',
          'method': 'execute_kw',
          'args': [
            database,
            userId,
            password,
            'res.partner',
            'unlink',
            [
              [id]
            ],
          ]
        },
        'id': 1,
      });

      // Extract the success status from JSON-RPC response
      return response['result'] == true;
    } catch (e) {
      print('Delete customer error: $e');
      return false;
    }
  }
}