import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:formz/formz.dart';

import 'package:websocket_tester/model/formz/header_body.dart';

part 'wsformcubit_state.dart';

class WsformcubitCubit extends Cubit<WsformcubitState> {
  WsformcubitCubit() : super(WsformcubitState());
  void urlChanged(String value) {
    final url = Url.dirty(value);
    emit(state.copyWith(
      url: url,
      status: Formz.validate([
        url,
        state.body,
        state.header,
      ]),
    ));
  }

  void headerChanged(String value) {
    final header = HeaderBody.dirty(value);
    emit(state.copyWith(
        header: header,
        status: Formz.validate([
          header,
          state.url,
          state.body,
        ])));
  }

  void bodyChanged(String value) {
    final body = HeaderBody.dirty(value);
    emit(state.copyWith(
        body: body,
        status: Formz.validate([
          state.header,
          state.url,
          body,
        ])));
  }

  // void loading() {
  //   emit(state.copyWith(connected: false));
  // }

  // void socketConnected() {
  //   emit(state.copyWith(connected: true));
  // }

  // void sendDataSuccess() {
  //   emit(state.copyWith(snapShotReceived: true));
  // }

  // Future<void> connectSocket() async {
  //   if (!state.status.isValidated) return;
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));

  //   try {
  //     final String url = state.url.value;

  //     final String header = state.header.value;
  //     final String body = state.body.value;
  //     Map<String, dynamic> hMap = json.decode(header) as Map<String, dynamic>;
  //     // Map<String, dynamic> data = json.decode(body) as Map<String, dynamic>;

  //     final IOWebSocketChannel _channel =
  //         _webSocketProvider.connectSocket(url, hMap);
  //     _channel.toString();
  //     emit(WsformcubitState(_channel, status: FormzStatus.submissionSuccess));
  //     ss = _channel.stream.listen((event) {
  //       print("printing event");
  //       print(event);

  //       emit(WsformcubitState(_channel, status: FormzStatus.submissionSuccess));
  //     }, onDone: () {
  //       _channel.sink.close();
  //       //  final IOWebSocketChannel _channel = wsAPiLoader.getConnect(path);
  //     }, onError: (e) {
  //       print("----error-----");

  //       print(e);
  //       emit(WsformcubitState(FormzStatus.submissionFailure));
  //       print("----error-----");
  //     }, cancelOnError: true);
  //     // ss.pause();

  //   } catch (e) {
  //     emit(WsformcubitState(FormzStatus.submissionFailure));
  //   }
  // }

  // Future<void> sinkAdd(IOWebSocketChannel stream) async {
  //   if (!state.status.isSubmissionSuccess || !state.status.isValidated) return;
  //   try {
  //     final String body = state.body.value;
  //     Map<String, dynamic> data = json.decode(body) as Map<String, dynamic>;
  //     stream.sink.add(data);
  //   } catch (e) {}
  // }
}
