part of 'wsformcubit_cubit.dart';

class WsformcubitState extends Equatable {
  final HeaderBody header;
  final Url url;
  final HeaderBody body;
  // final bool connected;
  // final bool snapShotReceived;
  final FormzStatus status;
  // final dynamic result;

  const WsformcubitState(
      {
      //   this.result = "",
      // this.connected = false,
      // this.snapShotReceived = false,
      this.header = const HeaderBody.pure(),
      this.url = const Url.pure(),
      this.body = const HeaderBody.pure(),
      this.status = FormzStatus.pure});

  WsformcubitState copyWith({
    HeaderBody? header,
    Url? url,
    HeaderBody? body,
    FormzStatus? status,
    Method? method,
    // dynamic result,
    // bool? connected,
    // bool? snapShotReceived
  }) {
    return WsformcubitState(
      // snapShotReceived ?? this.snapShotReceived,
      // connected ?? this.connected,
      // result ?? this.result,
      header: header ?? this.header,
      url: url ?? this.url,
      body: body ?? this.body,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        header,
        url,
        body,
        status,
      ];

  @override
  bool? get stringify => true;
}
