part of 'apimanform_cubit.dart';

class ApimanformState extends Equatable {
  final HeaderBody header;
  final Url url;
  final HeaderBody body;
  final Method method;
  final FormzStatus status;
  final result;

  const ApimanformState(this.result,
      {this.header = const HeaderBody.pure(),
      this.url = const Url.pure(),
      this.body = const HeaderBody.pure(),
      this.method = const Method.pure(),
      this.status = FormzStatus.pure});

  ApimanformState copyWith({
    HeaderBody? header,
    Url? url,
    HeaderBody? body,
    FormzStatus? status,
    Method? method,
    result,
  }) {
    return ApimanformState(result ?? this.result,
        header: header ?? this.header,
        url: url ?? this.url,
        body: body ?? this.body,
        status: status ?? this.status,
        method: method ?? this.method);
  }

  @override
  List<Object> get props => [header, url, body, method, status, result];

  @override
  bool? get stringify => true;
}
