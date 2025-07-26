import 'package:flutter/material.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/record.dart';

class Home extends Record {
  TextEditingController showerCleanedController = TextEditingController(text: strings.emptyDate);
  TextEditingController windowsCleanedController = TextEditingController(text: strings.emptyDate);
  TextEditingController fridgeCleanedController = TextEditingController(text: strings.emptyDate);
  TextEditingController freezerCleanedController = TextEditingController(text: strings.emptyDate);

  Home({String? name}) : super(type: RecordType.home, name: name ?? '', hint: strings.homeName, color: Colors.lightBlueAccent);

  factory Home.fromJson(Map<String, dynamic> json) {
    final home = Home(name: json['name']);

    home.showerCleanedController.text = json['showerCleanedDate'] ?? '';
    home.windowsCleanedController.text = json['windowsCleanedDate'] ?? '';
    home.fridgeCleanedController.text = json['fridgeCleanedDate'] ?? '';
    home.freezerCleanedController.text = json['freezerCleanedDate'] ?? '';

    return home;
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': RecordType.home.typeName,
    'name': name,
    'showerCleanedDate': showerCleanedController.text,
    'windowsCleanedDate': windowsCleanedController.text,
    'fridgeCleanedDate': fridgeCleanedController.text,
    'freezerCleanedDate': freezerCleanedController.text,
  };

  @override
  Widget panel(Record record, Function autoUpdateDate, Function chooseDate) {
    Home home = record as Home;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(home.showerCleanedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(home.showerCleanedController, 'dd/MM/yyyy')),
            Expanded(
              child: Text(
                home.showerCleanedController.text.isEmpty ? strings.emptyDate : '${strings.showerCleanedOn} ${home.showerCleanedController.text}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(home.windowsCleanedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.white),
              tooltip: strings.chooseDate,
              onPressed: () => chooseDate(home.windowsCleanedController, 'dd/MM/yyyy'),
            ),
            Expanded(
              child: Text(
                home.windowsCleanedController.text.isEmpty ? strings.emptyDate : '${strings.windowsCleanedOn} ${home.windowsCleanedController.text}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(home.fridgeCleanedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), tooltip: strings.chooseDate, onPressed: () => chooseDate(home.fridgeCleanedController, 'dd/MM/yyyy')),
            Expanded(
              child: Text(
                home.fridgeCleanedController.text.isEmpty ? strings.emptyDate : '${strings.fridgeCleanedOn} ${home.fridgeCleanedController.text}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () => autoUpdateDate(home.freezerCleanedController, 'dd/MM/yyyy'), child: Text(strings.currentDate)),
            IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.white),
              tooltip: strings.chooseDate,
              onPressed: () => chooseDate(home.freezerCleanedController, 'dd/MM/yyyy'),
            ),
            Expanded(
              child: Text(
                home.freezerCleanedController.text.isEmpty ? strings.emptyDate : '${strings.freezerCleanedOn} ${home.freezerCleanedController.text}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
