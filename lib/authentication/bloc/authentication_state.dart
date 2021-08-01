part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  String toString() => "Authentication State Initialized!";
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => "Authentication State Loading";
}

class AuthenticatedState extends AuthenticationState {
  @override
  String toString() => "Authenticated";
}

class UnAuthenticatedState extends AuthenticationState {
  @override
  String toString() => "UnAuthenticated";
}
