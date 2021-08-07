part of 'lang_cubit.dart';

abstract class LangState extends Equatable {
  const LangState();

  @override
  List<Object> get props => [];
}

class LangInitial extends LangState {}

class LangChanging extends LangState {
  @override
  String toString() => "LangChanging";
}

class LangChanged extends LangState {
  @override
  String toString() => "LangChanged";
}
