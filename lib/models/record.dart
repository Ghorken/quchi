import 'package:flutter/material.dart';
import 'package:quchi/models/baby.dart';
import 'package:quchi/models/home.dart';
import 'package:quchi/models/medicine.dart';
import 'package:quchi/models/pet.dart';
import 'package:quchi/models/plant.dart';

enum RecordType {
  plant,
  baby,
  pet,
  home,
  medicine;

  String get typeName => name;

  static RecordType fromString(String str) => RecordType.values.firstWhere((e) => e.name == str, orElse: () => throw Exception('Tipo non valido: $str'));
}

abstract class Record {
  RecordType type;
  String hint;
  String name;
  Color color;
  late TextEditingController controller;
  late FocusNode focusNode;

  Record({required this.type, this.name = '', required this.hint, required this.color}) {
    controller = TextEditingController(text: name);
    focusNode = FocusNode();
  }

  Map<String, dynamic> toJson();

  static Record fromDynamicJson(Map<String, dynamic> json) {
    switch (RecordType.fromString(json['type'])) {
      case RecordType.plant:
        return Plant.fromJson(json);
      case RecordType.baby:
        return Baby.fromJson(json);
      case RecordType.pet:
        return Pet.fromJson(json);
      case RecordType.home:
        return Home.fromJson(json);
      case RecordType.medicine:
        return Medicine.fromJson(json);
    }
  }

  Widget panel(Record plant, Function autoUpdateDate, Function chooseDate);
}
