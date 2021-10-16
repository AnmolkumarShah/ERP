import 'Model_Interface.dart';

class Type implements Model {
  int? id;
  String? desc;
  static String query = 'select * from type';
  Type({this.desc, this.id});
  @override
  display() {
    return this.desc;
  }

  @override
  getQuery() {
    return Type.query;
  }

  @override
  format(List li) {
    return li.map((e) => Type(desc: e['type'], id: e['id'])).toList();
  }
}
