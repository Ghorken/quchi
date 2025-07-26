import 'package:flutter/material.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/record.dart';

class Pet extends Record {
  TextEditingController poopedController = TextEditingController(text: strings.emptyDate);
  TextEditingController bedCleanedController = TextEditingController(text: strings.emptyDate);

  Pet({String? name}) : super(type: RecordType.pet, name: name ?? '', hint: strings.petName, color: Colors.brown[400]!);

  factory Pet.fromJson(Map<String, dynamic> json) {
    final pet = Pet(name: json['name']);

    pet.poopedController.text = json['poopedDate'] ?? '';
    pet.bedCleanedController.text = json['bedCleanedDate'] ?? '';

    return pet;
  }

  @override
  Map<String, dynamic> toJson() => {'type': RecordType.pet.typeName, 'name': name, 'poopedDate': poopedController.text, 'bedCleanedDate': bedCleanedController.text};

  @override
  Widget panel(Record record, Function autoUpdateDate, Function chooseDate) {
    Pet pet = record as Pet;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(pet.poopedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(pet.poopedController, 'dd/MM/yyyy')),
            Expanded(child: Text(pet.poopedController.text.isEmpty ? strings.emptyDate : '${strings.poopedOn} ${pet.poopedController.text}', style: TextStyle(fontSize: 16))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(pet.bedCleanedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(pet.bedCleanedController, 'dd/MM/yyyy')),
            Expanded(
              child: Text(pet.bedCleanedController.text.isEmpty ? strings.emptyDate : '${strings.bedCleanedOn} ${pet.bedCleanedController.text}', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }
}
