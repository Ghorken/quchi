import 'package:flutter/material.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/record.dart';

class Plant extends Record {
  TextEditingController wateredController = TextEditingController(text: strings.emptyDate);
  TextEditingController fertilizedController = TextEditingController(text: strings.emptyDate);

  Plant({String? name}) : super(type: RecordType.plant, name: name ?? '', hint: strings.plantName, color: Colors.lightGreen);

  factory Plant.fromJson(Map<String, dynamic> json) {
    final plant = Plant(name: json['name']);

    plant.wateredController.text = json['wateredDate'] ?? '';
    plant.fertilizedController.text = json['fertilizedDate'] ?? '';

    return plant;
  }

  @override
  Map<String, dynamic> toJson() => {'type': RecordType.plant.typeName, 'name': name, 'wateredDate': wateredController.text, 'fertilizedDate': fertilizedController.text};

  @override
  Widget panel(Record record, Function autoUpdateDate, Function chooseDate) {
    Plant plant = record as Plant;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(plant.wateredController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(plant.wateredController, 'dd/MM/yyyy')),
            Expanded(
              child: Text(plant.wateredController.text.isEmpty ? strings.emptyDate : '${strings.wateredOn} ${plant.wateredController.text}', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(plant.fertilizedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(plant.fertilizedController, 'dd/MM/yyyy')),
            Expanded(
              child: Text(
                plant.fertilizedController.text.isEmpty ? strings.emptyDate : '${strings.fertilizedOn} ${plant.fertilizedController.text}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
