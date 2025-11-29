
import '../models/user.dart';

abstract class MyState {}

class MyInitial extends MyState {}

class MyLoading extends MyState {}

class MyLoaded extends MyState {
  final List<User> users;
  final bool isConnected;

  MyLoaded({required this.users, required this.isConnected});
}

class MyError extends MyState {
  final String message;

  MyError(this.message);
}

class MyOperationSuccess extends MyState {
  final String message;

  MyOperationSuccess(this.message);
}

class MyOperationError extends MyState {
  final String message;

  MyOperationError(this.message);
}