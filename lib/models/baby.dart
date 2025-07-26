import 'package:flutter/material.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/record.dart';

class Baby extends Record {
  TextEditingController poopedController = TextEditingController(text: strings.emptyDate);
  TextEditingController peedController = TextEditingController(text: strings.emptyDate);
  TextEditingController eatedController = TextEditingController(text: strings.emptyDate);

  Baby({String? name}) : super(type: RecordType.baby, name: name ?? '', hint: strings.babyName, color: Colors.pink[100]!);

  factory Baby.fromJson(Map<String, dynamic> json) {
    final baby = Baby(name: json['name']);

    baby.poopedController.text = json['poopedDate'] ?? '';
    baby.peedController.text = json['peedDate'] ?? '';
    baby.eatedController.text = json['eatedDate'] ?? '';

    return baby;
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': RecordType.baby.typeName,
    'name': name,
    'poopedDate': poopedController.text,
    'peedDate': peedController.text,
    'eatedDate': eatedController.text,
  };

  @override
  Widget panel(Record record, Function autoUpdateDate, Function chooseDate) {
    Baby baby = record as Baby;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(baby.poopedController, 'Hm'), child: Text(strings.currentHour)),
            IconButton(icon: Icon(Icons.timer_outlined, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(baby.poopedController, 'Hm')),
            Expanded(child: Text(baby.poopedController.text.isEmpty ? strings.emptyDate : '${strings.poopedAt} ${baby.poopedController.text}', style: TextStyle(fontSize: 16))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(baby.peedController, 'Hm'), child: Text(strings.currentHour)),
            IconButton(icon: Icon(Icons.timer_outlined, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(baby.peedController, 'Hm')),
            Expanded(child: Text(baby.peedController.text.isEmpty ? strings.emptyDate : '${strings.peedAt} ${baby.peedController.text}', style: TextStyle(fontSize: 16))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(baby.eatedController, 'Hm'), child: Text(strings.currentHour)),
            IconButton(icon: Icon(Icons.timer_outlined, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(baby.eatedController, 'Hm')),
            Expanded(child: Text(baby.eatedController.text.isEmpty ? strings.emptyDate : '${strings.eatedAt} ${baby.eatedController.text}', style: TextStyle(fontSize: 16))),
          ],
        ),
      ],
    );
  }
}
