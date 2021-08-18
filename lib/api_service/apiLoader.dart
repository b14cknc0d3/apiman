import 'dart:convert';

import 'package:http/http.dart';
import 'package:apiman/api_service/apiService.dart';

class ApiLoader {
  final ApiProvider apiProvider = ApiProvider();

  get(String url, hMap) async {
    final response = await apiProvider.apiGet(url, hMap);
    return response;
  }

  post(String url, data, hMap) async {
    final response = await apiProvider.apiPost(url, data, hMap);
    return response;
  }

  patch(String url, data, hMap) async {
    final response = await apiProvider.apiPatch(url, data, hMap);
    return response;
  }

  put(String url, data, hMap) async {
    final response = await apiProvider.apiPut(url, data, hMap);
    return response;
  }

  delete(String url, data, hMap) async {
    final response = await apiProvider.apiDelete(url, hMap);
    return response;
  }

  head(String url, data, hMap) async {
    final response = await apiProvider.apiHead(url, hMap);
    return response;
  }

  options(String url, data, hMap) async {
    final response = await apiProvider.apiOptions(url, hMap);
    return response;
  }
}

void main(List<String> args) async {
  print("json test");
  String jS = '{"test":"1"}';
  String jSS = "{'test':'1'}";
  String jSSf = jSS.replaceAll("\'", "\"");
  String d = '{"email": "test@test.com", "password": "asdfghjkl"}';

  var j = json.decode(jS);
  // var j1 = json.decode(jSS);
  var j3 = json.decode(jSSf);
  print(j);
  print(j3);
  var j4 = json.decode(d);
  print(j4.runtimeType);
  var hMap = {};
  ApiLoader apiLoader = ApiLoader();
  print("TESTING ________API_________________");
  print("[+] testing api post.....");
  var data = {"email": "test@test.com", "password": "asdfghjkl"};
  final r = await apiLoader.post("http://127.0.0.1:8080/api/token", data, hMap);
  print(r);
  var token = r["body"]["access"];
  var h = (r["headers"]);
  print(h);
  print("header length :" + "${h.length}");
  print("[*] done\n\n");
  print("[+] get testing.........");
  final r1 =
      await apiLoader.get("https://jsonplaceholder.typicode.com/todos/1", hMap);

  print("[*] done\n\n");

  token.isNotEmpty ? hMap = {"Authorization": "Token $token"} : hMap = {"": ""};
  hMap = new Map<String, String>.from(hMap);
  print(hMap.runtimeType);
  // final r2 =
  //     await apiLoader.get("https://jsonplaceholder.typicode.com/todos/", hMap);
  // print(r2.toString().substring(0, 2));
  print("[+] get testing with header **************************");

  final r3 = await apiLoader.get("http://127.0.0.1:8080/api/user/yla/", hMap);

  print("[*] done\n\n");

  print("[+] ****************patch testing************");
  var toupdate = {"bio": "i love coding"};
  toupdate = Map<String, String>.from(toupdate);
  final r4 = await apiLoader.patch(
      "http://127.0.0.1:8080/api/user/yla/update", toupdate, hMap);
  print(r4);
  print("[*] done\n\n");

  print("[+] ****************error test************");
  final r5 = await apiLoader.patch(
      "http://127.0.0.1:8080/api/user/yla/", toupdate, hMap);
  print(r5);
  print("[*] done\n\n");
  print("[+] ****************error html test************");
  final r6 = await apiLoader.patch(
      "http://127.0.0.1:8080/api/23434/12321213/", toupdate, hMap);
  print(r6);
  print("[*] done\n\n");
}
