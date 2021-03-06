import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/DateRangeControl.dart';
import 'package:softflow2/Helpers/DropdownHelper.dart';
import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Helpers/Snakebar.dart';
import 'package:softflow2/Models/Shade.dart';
import 'package:softflow2/Models/Size.dart';
import 'package:softflow2/Models/StockInOut.dart';
import 'package:softflow2/Models/Trantype.dart';
import 'package:softflow2/Models/Type.dart';

import 'StockInStockOutScreen2.dart';

class StockInOutScreen extends StatefulWidget {
  const StockInOutScreen({Key? key}) : super(key: key);

  @override
  State<StockInOutScreen> createState() => _StockInOutScreenState();
}

class _StockInOutScreenState extends State<StockInOutScreen> {
  static int count = 0;
  List<Shade>? shade_items;
  List<Size>? size_items;
  List<Type>? type_items;
  List<Trantype>? transtype_items;

  Shade? selected_shade;
  Size? selected_size;
  Type? selected_type;
  Trantype? selected_trantype;
  DateTimeRange? rangeDate;

  setDateRange(DateTimeRange? rangeDate) {
    setState(() {
      this.rangeDate = rangeDate;
    });
  }

  Future init() async {
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Type> typeItems = await fetch(Type());
    List<Trantype> trantypeItems = await fetch(Trantype());

    shadeItems.insert(0, Shade(id: -1, desc: "Default"));
    sizeItems.insert(0, Size(id: -1, desc: "Default"));
    typeItems.insert(0, Type(id: -1, desc: "Default"));
    trantypeItems.insert(0, Trantype(id: -1, desc: "Default"));

    setState(() {
      this.shade_items = shadeItems;
      this.size_items = sizeItems;
      this.type_items = typeItems;
      this.transtype_items = trantypeItems;

      this.selected_shade = shadeItems.first;
      this.selected_size = sizeItems.first;
      this.selected_type = typeItems.first;
      this.selected_trantype = trantypeItems.first;
    });
  }

  Future _fetch() async {
    if (count > 0) return;
    await init();
    count += 1;
  }

  @override
  void didChangeDependencies() {
    count = 0;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock In Out Report"),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Dropdown(
                  items: transtype_items,
                  label: "Select Trantype",
                  selected: selected_trantype,
                  fun: (val) {
                    setState(() {
                      selected_trantype = val;
                    });
                  }).build(),
              Dropdown(
                  items: size_items,
                  label: "Select Size",
                  selected: selected_size,
                  fun: (val) {
                    setState(() {
                      selected_size = val;
                    });
                  }).build(),
              Dropdown(
                  items: shade_items,
                  label: "Select Shade",
                  selected: selected_shade,
                  fun: (val) {
                    setState(() {
                      selected_shade = val;
                    });
                  }).build(),
              Dropdown(
                  items: type_items,
                  label: "Select Type",
                  selected: selected_type,
                  fun: (val) {
                    setState(() {
                      selected_type = val;
                    });
                  }).build(),
              DateRangeFull(
                fun: setDateRange,
                rangeDate: this.rangeDate,
              ),
              TextButton(
                onPressed: () {
                  if (rangeDate == null) {
                    showSnakeBar(context, "Select Date Range");
                    return;
                  }
                  if (selected_shade!.id == -1 &&
                      selected_size!.id == -1 &&
                      selected_trantype!.id == -1 &&
                      selected_type!.id == -1) {
                    showSnakeBar(context, "Select Atleast One");
                    return;
                  }
                  StockInOut? selectedStockInOut = StockInOut(
                    s: selected_size,
                    shade: selected_shade,
                    t: selected_type,
                    trantype: selected_trantype,
                    r: rangeDate,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockInOutScreen2(
                        stockinout: selectedStockInOut,
                      ),
                    ),
                  );
                },
                child: Text(
                  "GO!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
