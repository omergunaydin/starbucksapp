part of 'user_cubit.dart';

class UserState {}

class UserInitial extends UserState {}

class UserSignIn extends UserState {
  StarUser user;
  UserSignIn({required this.user});
}

class UserSignInFailed extends UserState {}

class UserSignOut extends UserState {}

class UserDataChanged extends UserState {
  StarUser user;
  UserDataChanged({required this.user});
}
