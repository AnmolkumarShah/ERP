import 'dart:convert';

import 'package:softflow2/Helpers/DateFormatForDB.dart';
import 'package:softflow2/Helpers/getMethodHelperFunction.dart';
import 'package:softflow2/Helpers/url_model.dart';
import 'package:softflow2/Models/Rollsize.dart';
import 'package:softflow2/Models/Shade.dart';
import 'package:softflow2/Models/Size.dart';
import 'package:softflow2/Models/Trantype.dart';
import 'package:softflow2/Models/Type.dart';

class Transaction {
  String? refno;
  DateTime? date;
  String? party;
  Type? type;
  Size? size;
  Shade? shade;
  Trantype? trantype;
  Rollsize? rollsize;
  String? rolls;
  String? mtrs;

  Transaction({
    this.date,
    this.mtrs,
    this.party,
    this.refno,
    this.rolls,
    this.rollsize,
    this.shade,
    this.size,
    this.trantype,
    this.type,
  });

  Future save() async {
    try {
      final UrlGlobal urlObject = UrlGlobal(
        p2: """
          insert into transactions(TranRef,TranDate,party,TranType,size,shade,type,rollsize,rolls,mtrs)
          values('${this.refno}', '${formateDate(this.date!)}', '${this.party}', ${this.trantype!.id}, ${this.size!.id}, ${this.shade!.id},
          ${this.type!.id}, ${this.rollsize!.id}, ${this.rolls}, ${this.mtrs})          
        """,
        p1: '1',
      );
      final url = urlObject.getUrl();
      final result = await Get.call(url);
      final data = json.decode(result.body);

      return {"message": data['status'], 'data': data};
    } catch (e) {
      print(e.toString());
    }
  }
}
