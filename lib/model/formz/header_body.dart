import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum HBValidationError { invalid }

class HeaderBody extends FormzInput<String, HBValidationError> {
  const HeaderBody.dirty([String value = "{}"]) : super.dirty(value);
  const HeaderBody.pure([String value = "{}"]) : super.pure(value);

  @override
  HBValidationError? validator(String value) {
    print("--hb-bool----");
    print(isJson(value));
    print("--hb-bool----");
    bool isValid = isJson(value);
    return isValid ? null : HBValidationError.invalid;
  }
}

enum UrlValidationError { invalid }

class Url extends FormzInput<String, UrlValidationError> {
  const Url.dirty([String value = ""]) : super.dirty(value);
  const Url.pure([String value = ""]) : super.pure(value);

  @override
  UrlValidationError? validator(String value) {
    print("--ur-bool----");
    print(isURL(value));
    print("-url--bool----");
    bool isValid = isURL(value);
    return isValid ? null : UrlValidationError.invalid;
  }
}

enum MethodValidationError { invalid }

class Method extends FormzInput<String, MethodValidationError> {
  const Method.dirty([String value = "get"]) : super.dirty(value);
  const Method.pure([String value = "get"]) : super.pure(value);

  @override
  MethodValidationError? validator(String value) {
    print("-method--bool----");
    print((value.runtimeType == String));
    print("-method--bool----");
    bool isValid = (value.runtimeType == String);
    return isValid ? null : MethodValidationError.invalid;
  }
}
