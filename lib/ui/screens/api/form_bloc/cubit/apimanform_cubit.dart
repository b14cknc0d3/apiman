import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:websocket_tester/api_service/apiLoader.dart';
import 'package:websocket_tester/model/formz/header_body.dart';

part 'apimanform_state.dart';

class ApimanformCubit extends Cubit<ApimanformState> {
  final ApiLoader _apiLoader;
  ApimanformCubit({required ApiLoader apiLoader})
      : _apiLoader = apiLoader,
        super(const ApimanformState([]));

  void urlChanged(String value) {
    final url = Url.dirty(value);
    emit(state.copyWith(
      url: url,
      status: Formz.validate([url, state.body, state.header, state.method]),
    ));
  }

  void headerChanged(String value) {
    final header = HeaderBody.dirty(value);
    emit(state.copyWith(
        header: header,
        status: Formz.validate([header, state.url, state.body, state.method])));
  }

  void bodyChanged(String value) {
    final body = HeaderBody.dirty(value);
    emit(state.copyWith(
        body: body,
        status: Formz.validate([state.header, state.url, body, state.method])));
  }

  void methodChanged(String value) {
    final method = Method.dirty(value);
    emit(state.copyWith(
        method: method.valid ? method : Method.pure(method.value),
        status: Formz.validate([
          method,
          state.header,
          state.url,
          state.body,
        ])));
  }

  Future<void> formSummits() async {
    //when pressed sumit
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final String url = state.url.value;
      final String method = state.method.value;
      final String header = state.header.value;
      final String body = state.body.value;
      Map<String, dynamic> hMap = json.decode(header) as Map<String, dynamic>;
      Map<String, dynamic> data = json.decode(body) as Map<String, dynamic>;

      switch (method) {
        // migrate here

        case "get":
          final result = await _apiLoader.get(url, hMap);

          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;
        case "post":
          final result = await _apiLoader.post(url, data, hMap);
          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;

        case "put":
          final result = await _apiLoader.put(url, data, hMap);
          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;
        case "patch":
          final result = await _apiLoader.patch(url, data, hMap);
          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;
        case "delete":
          final result = await _apiLoader.delete(url, data, hMap);
          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;
        case "head":
          final result = await _apiLoader.head(url, data, hMap);
          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;
        default:
          final result = await _apiLoader.get(url, hMap);
          if (result != null) {
            emit(state.copyWith(
                result: result, status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
          break;
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
