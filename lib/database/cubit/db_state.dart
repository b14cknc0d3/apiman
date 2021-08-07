part of 'db_cubit.dart';

abstract class DbState extends Equatable {
  const DbState();

  @override
  List<Object> get props => [];
}

class DbInitial extends DbState {}
