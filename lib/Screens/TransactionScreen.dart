import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/CalenderHelper.dart';
import 'package:softflow2/Helpers/DropdownHelper.dart';
import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Helpers/Snakebar.dart';
import 'package:softflow2/Helpers/TextFieldHelper.dart';
import 'package:softflow2/Models/Rollsize.dart';
import 'package:softflow2/Models/Shade.dart';
import 'package:softflow2/Models/Size.dart';
import 'package:softflow2/Models/Transaction.dart';
import 'package:softflow2/Models/Trantype.dart';
import 'package:softflow2/Models/Type.dart';

// ignore: must_be_immutable
class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Rollsize>? rollsize_items;
  List<Shade>? shade_items;
  List<Size>? size_items;
  List<Trantype>? trantype_items;
  List<Type>? type_items;

  Rollsize? selected_rollsize;
  Shade? selected_shade;
  Size? selected_size;
  Trantype? selected_trantype;
  Type? selected_type;
  DateTime? date;
  String? party;
  String? rolls;
  String? mtrs;
  String? refNum;

  static int count = 0;

  Future init() async {
    List<Rollsize> rollsizeItems = await fetch(Rollsize());
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Trantype> trantypeItems = await fetch(Trantype());
    List<Type> typeItems = await fetch(Type());

    setState(() {
      this.rollsize_items = rollsizeItems;
      this.shade_items = shadeItems;
      this.size_items = sizeItems;
      this.trantype_items = trantypeItems;
      this.type_items = typeItems;

      this.selected_rollsize = rollsizeItems.first;
      this.selected_shade = shadeItems.first;
      this.selected_size = sizeItems.first;
      this.selected_trantype = trantypeItems.first;
      this.selected_type = typeItems.first;
    });

    return;
  }

  _fetchData() async {
    if (count > 0) return;
    await init();
    count += 1;
  }

  bool? loading;

  bool check() {
    if (date == null) {
      return false;
    } else if (this.rolls == null) {
      return false;
    } else if (this.mtrs == null) {
      return false;
    }
    return true;
  }

  save() async {
    if (!check()) {
      showSnakeBar(context, "Fill All Fields Properly");
      return;
    }
    setState(() {
      loading = true;
    });

    Transaction tra = Transaction(
      date: this.date,
      mtrs: this.mtrs,
      party: this.party,
      refno: this.refNum,
      rolls: this.rolls,
      rollsize: this.selected_rollsize,
      shade: this.selected_shade,
      size: this.selected_size,
      trantype: this.selected_trantype,
      type: this.selected_type,
    );

    final result = await tra.save();
    print(result);

    if (result['message'] == 'success') {
      showSnakeBar(context, "Transaction Saved Successfully");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              CalenderHelper(
                selectedDate: this.date,
                cancel: () {
                  setState(() {
                    this.date = null;
                  });
                },
                context: context,
                fun: (val) {
                  setState(() {
                    this.date = val;
                  });
                },
                label: "Date",
              ).build(),
              TextFieldHelper(
                hint: "Referance Number",
                type: TextInputType.name,
                val: refNum,
                fun: (val) {
                  setState(() {
                    this.refNum = val;
                  });
                },
              ).build(),
              TextFieldHelper(
                hint: "Party Name",
                type: TextInputType.name,
                val: party,
                fun: (val) {
                  setState(() {
                    this.party = val;
                  });
                },
              ).build(),
              Dropdown(
                label: "TranType",
                items: this.trantype_items,
                fun: (val) {
                  setState(() {
                    this.selected_trantype = val;
                  });
                },
                selected: this.selected_trantype,
              ).build(),
              Dropdown(
                label: "Size",
                items: this.size_items,
                fun: (val) {
                  setState(() {
                    this.selected_size = val;
                  });
                },
                selected: this.selected_size,
              ).build(),
              Dropdown(
                label: "Shade",
                items: this.shade_items,
                fun: (val) {
                  setState(() {
                    this.selected_shade = val;
                  });
                },
                selected: this.selected_shade,
              ).build(),
              Dropdown(
                label: "Type",
                items: this.type_items,
                fun: (val) {
                  setState(() {
                    this.selected_type = val;
                  });
                },
                selected: this.selected_type,
              ).build(),
              Dropdown(
                label: "Rollsize",
                items: this.rollsize_items,
                fun: (val) {
                  setState(() {
                    this.selected_rollsize = val;
                    this.mtrs = (double.parse(this.rolls!) *
                            double.parse(this.selected_rollsize!.desc!))
                        .toString();
                  });
                },
                selected: this.selected_rollsize,
              ).build(),
              TextFieldHelper(
                w: true,
                hint: "Rolls",
                type: TextInputType.number,
                val: rolls,
                fun: (val) {
                  setState(() {
                    this.rolls = val;
                    this.mtrs = (double.parse(this.rolls!) *
                            double.parse(this.selected_rollsize!.desc!))
                        .toString();
                  });
                },
              ).build(),
              TextFieldHelper(
                w: true,
                hint: "Meters",
                type: TextInputType.number,
                val: mtrs,
                fun: (val) {
                  setState(() {
                    this.mtrs = (double.parse(this.rolls!) *
                            double.parse(this.selected_rollsize!.desc!))
                        .toString();
                  });
                },
              ).build(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          save();
                        },
                        child: Text("Save Transaction"),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
