class ApiManModel {
  late List<Tab>? tab;

  ApiManModel({required this.tab});

  ApiManModel.fromJson(Map<String, dynamic> json) {
    if (json['Tab'] != null) {
      tab = <Tab>[];
      json['Tab'].forEach((v) {
        tab!.add(new Tab.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tab != null) {
      data['Tab'] = this.tab!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tab {
  String? method;
  String? url;
  String? headers;
  String? body;

  Tab({this.method, this.url, this.headers, this.body});

  Tab.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    url = json['url'];
    headers = json['headers'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['url'] = this.url;
    data['headers'] = this.headers;
    data['body'] = this.body;
    return data;
  }
}
