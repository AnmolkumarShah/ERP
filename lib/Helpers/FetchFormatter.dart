import 'dart:convert';
import 'package:softflow2/Helpers/getMethodHelperFunction.dart';
import 'package:softflow2/Helpers/url_model.dart';
import 'package:softflow2/Interface/Model_Interface.dart';

Future fetch(Model m) async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: m.getQuery(),
  );
  try {
    final url = urlObject.getUrl();
    var result = await Get.call(url);
    final data = json.decode(result.body) as List<dynamic>;
    result = m.format(data);
    return result;
  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future fetchQuery({String? query, String? p1 = '0'}) async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: query!,
    p1: p1!,
  );
  try {
    final url = urlObject.getUrl();
    var result = await Get.call(url);
    var data;
    try {
      data = json.decode(result.body) as List<dynamic>;
    } catch (e) {
      data = json.decode(result.body);
    }
    return data;
  } catch (e) {
    print(e.toString());
    return [];
  }
}
