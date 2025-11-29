
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vision_app/cubit/my_state_cubit.dart';
import 'package:vision_app/my_repo.dart';
import 'package:vision_app/web_services.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerLazySingleton<MyCubit>(() => MyCubit(getIt()));
  getIt.registerLazySingleton<MyRepo>(() => MyRepo(getIt()));
  getIt.registerLazySingleton<WebServices>(() => WebServices(createAndSetupDio()));
}

Dio createAndSetupDio() {
  Dio dio = Dio();
  
  dio.options.connectTimeout = const Duration(milliseconds: 10000);
  dio.options.receiveTimeout = const Duration(milliseconds: 30000);
  dio.options.sendTimeout = const Duration(milliseconds: 30000);

  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    error: true,
    requestHeader: false,
    responseHeader: false,
    request: true,
    requestBody: true,
  ));
  
  return dio;
}