import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'web_services.g.dart';

@RestApi(baseUrl: 'http://localhost:8067/')
abstract class WebServices {
  factory WebServices(Dio dio, {String baseUrl}) = _WebServices;

  // Authentication
  @POST('web/session/authenticate')
  Future<dynamic> authenticate(@Body() Map<String, dynamic> credentials);

  // Customer CRUD operations - return dynamic to avoid generation issues
  @POST('jsonrpc')
  Future<dynamic> getCustomers(@Body() Map<String, dynamic> rpcBody);

  @POST('jsonrpc')
  Future<dynamic> createCustomer(@Body() Map<String, dynamic> rpcBody);

  @POST('jsonrpc')
  Future<dynamic> updateCustomer(@Body() Map<String, dynamic> rpcBody);

  @POST('jsonrpc')
  Future<dynamic> deleteCustomer(@Body() Map<String, dynamic> rpcBody);
}