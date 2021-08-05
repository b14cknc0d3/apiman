import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProvider {
  var client = http.Client();
  // ignore: non_constant_identifier_names
  var get_headers = {
    // "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
    "User-Agent": "ApiMan",
    "Accept": "*/*",
    // "Content-Type": "application/json"
  };
  // ignore: non_constant_identifier_names
  var post_headers = {
    // "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
    "User-Agent": "ApiMan",
    "Accept": "*/*",
    // "Content-Type": "application/json"
  };

  Future apiPost(String url, body, hMap) async {
    hMap.isNotEmpty ? post_headers.addAll(hMap) : post_headers = post_headers;
    Map<String, String> data = new Map<String, String>.from(body);
    print(Uri.parse(url));
    print(post_headers.runtimeType);
    try {
      final response = await Future.delayed(
          Duration(seconds: 1),
          () => client.post(
                Uri.parse(url),
                headers: post_headers,
                body: data,
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(response.body);
        final data = json.decode(utf8.decode(response.bodyBytes));
        final result = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "body": data,
          "headers": response.headers,
        };
        return result;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }

  Future apiGet(String url, hMap) async {
    hMap.isNotEmpty ? get_headers.addAll(hMap) : get_headers = get_headers;
    try {
      final response = await Future.delayed(Duration(seconds: 1),
          () => client.get(Uri.parse(url), headers: get_headers));
      if (response.statusCode == 200) {
        if (response.body is List) {
          print("a list");
        }
        print(response.body.runtimeType);
        final data = json.decode(utf8.decode(response.bodyBytes));
        final result = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "body": data,
          "headers": response.headers
        };
        return result;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }

  Future apiPut(String url, data, hMap) async {
    hMap.isNotEmpty ? post_headers.addAll(hMap) : post_headers = post_headers;
    try {
      final response = await Future.delayed(
        Duration(milliseconds: 300),
        () => client.put(Uri.parse(url), headers: post_headers, body: data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final result = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "body": data,
          "headers": response.headers
        };
        return result;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }

  Future apiPatch(String url, data, hMap) async {
    hMap.isNotEmpty ? post_headers.addAll(hMap) : post_headers = post_headers;
    Map<String, String> body = new Map<String, String>.from(data);
    try {
      final response = await Future.delayed(
        Duration(milliseconds: 300),
        () => client.patch(Uri.parse(url), headers: get_headers, body: body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final result = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "body": data,
          "headers": response.headers
        };
        return result;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }

  Future apiDelete(String url, hMap) async {
    hMap.isNotEmpty ? post_headers.addAll(hMap) : post_headers = post_headers;
    try {
      final response = await Future.delayed(
        Duration(milliseconds: 300),
        () => client.delete(
          Uri.parse(url),
          headers: post_headers,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }

  Future apiHead(String url, hMap) async {
    hMap.isNotEmpty ? get_headers.addAll(hMap) : get_headers = get_headers;
    try {
      final response = await Future.delayed(Duration(seconds: 1),
          () => client.head(Uri.parse(url), headers: get_headers));
      if (response.statusCode == 200) {
        if (response.body is List) {
          print("a list");
        }
        print(response.body.runtimeType);
        final data = json.decode(utf8.decode(response.bodyBytes));
        final result = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "body": data,
          "headers": response.headers
        };
        return result;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }

  Future apiOptions(String url, hMap) async {
    hMap.isNotEmpty ? get_headers.addAll(hMap) : get_headers = get_headers;
    try {
      final response = await Future.delayed(Duration(seconds: 1),
          () => client.head(Uri.parse(url), headers: get_headers));
      if (response.statusCode == 200) {
        if (response.body is List) {
          print("a list");
        }
        print(response.body.runtimeType);
        final data = json.decode(utf8.decode(response.bodyBytes));
        final result = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "body": data,
          "headers": response.headers
        };
        return result;
      } else {
        final error = {
          "status_code": "${response.statusCode}",
          "length": "${response.contentLength}",
          "error": "${response.body}",
          "headers": response.headers
        };
        return error;
      }
    } catch (e) {
      print(e);
    }
  }
}
