import '../Interface/Model_Interface.dart';

class Shade implements Model {
  int? id;
  String? desc;
  static String query = 'select * from shade';
  Shade({this.desc, this.id});
  @override
  display() {
    return this.desc;
  }

  @override
  getQuery() {
    return Shade.query;
  }

  @override
  format(List li) {
    return li.map((e) => Shade(desc: e['shade'], id: e['id'])).toList();
  }
}
