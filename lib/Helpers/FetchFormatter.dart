import 'dart:convert';
import 'package:softflow2/Helpers/getMethodHelperFunction.dart';
import 'package:softflow2/Helpers/url_model.dart';
import 'package:softflow2/Models/Model_Interface.dart';

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
  }
}
