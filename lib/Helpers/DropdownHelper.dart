import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FieldCover.dart';
import 'package:softflow2/Models/Model_Interface.dart';

class Dropdown {
  Model? selected;
  List<Model>? items;
  Function? fun;
  String? label;

  Dropdown({this.items, this.fun, this.selected, this.label});

  List<DropdownMenuItem<Model>> buildItems(List<Model>? li) {
    List<DropdownMenuItem<Model>>? list = li!
        .map((e) => DropdownMenuItem<Model>(
              child: Text(
                e.display(),
              ),
              value: e,
            ))
        .toList();
    return list;
  }

  Widget build() {
    return Fieldcover(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            this.label!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<Model>(
              items: buildItems(this.items),
              onChanged: (value) {
                this.selected = value;
                this.fun!(value);
              },
              value: selected,
            ),
          ),
        ],
      ),
    );
  }
}
