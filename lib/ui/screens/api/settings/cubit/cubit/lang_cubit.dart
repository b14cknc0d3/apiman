import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lang_state.dart';

class LangCubit extends Cubit<LangState> {
  LangCubit() : super(LangInitial());

  langSwitch() {
    emit(LangChanging());
    Future.delayed(Duration(milliseconds: 300));
    emit(LangChanged());
  }
}
