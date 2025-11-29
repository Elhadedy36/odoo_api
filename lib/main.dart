import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_app/cubit/my_state_cubit.dart';
import 'package:vision_app/home.dart';

import 'injection.dart';

void main() {
  initGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<MyCubit>( // ← Add the explicit type here
        create: (context) => getIt<MyCubit>(),
        child: const HomeView(),
      ),
    );
  }
}