import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'db_state.dart';

class DbCubit extends Cubit<DbState> {
  DbCubit() : super(DbInitial());
}
