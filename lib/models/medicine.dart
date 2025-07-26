import 'package:flutter/material.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/record.dart';

class Medicine extends Record {
  TextEditingController takenOnController = TextEditingController(text: strings.emptyDate);
  TextEditingController takenAtController = TextEditingController(text: strings.emptyDate);

  Medicine({String? name}) : super(type: RecordType.medicine, name: name ?? '', hint: strings.medicineName, color: Colors.grey[400]!);

  factory Medicine.fromJson(Map<String, dynamic> json) {
    final medicine = Medicine(name: json['name']);

    medicine.takenOnController.text = json['takenOnDate'] ?? '';
    medicine.takenAtController.text = json['takenAtDate'] ?? '';

    return medicine;
  }

  @override
  Map<String, dynamic> toJson() => {'type': RecordType.medicine.typeName, 'name': name, 'takenOnDate': takenOnController.text, 'takenAtDate': takenAtController.text};

  @override
  Widget panel(Record record, Function autoUpdateDate, Function chooseDate) {
    Medicine medicine = record as Medicine;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(medicine.takenOnController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(medicine.takenOnController, 'dd/MM/yyyy')),
            Expanded(
              child: Text(medicine.takenOnController.text.isEmpty ? strings.emptyDate : '${strings.takenOn} ${medicine.takenOnController.text}', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(medicine.takenAtController, 'Hm'), child: Text(strings.currentHour)),
            IconButton(icon: Icon(Icons.timer_outlined, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(medicine.takenAtController, 'Hm')),
            Expanded(
              child: Text(medicine.takenAtController.text.isEmpty ? strings.emptyDate : '${strings.takenAt} ${medicine.takenAtController.text}', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }
}
