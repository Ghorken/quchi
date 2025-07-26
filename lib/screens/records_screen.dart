import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/baby.dart';
import 'package:quchi/models/home.dart';
import 'package:quchi/models/medicine.dart';
import 'package:quchi/models/pet.dart';
import 'package:quchi/models/plant.dart';
import 'package:quchi/models/record.dart';
import 'package:quchi/screens/info_screen.dart';
import 'package:quchi/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<Record> records = [];
  late BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner fallito: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    loadRecords();

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    for (Record record in records) {
      record.focusNode.dispose();
      record.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.backgroundColor,
      appBar: AppBar(
        title: Text(strings.title),
        centerTitle: true,
        backgroundColor: Themes.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoScreen()));
            },
          ),
        ],
      ),
      body: Column(
        spacing: 20.0,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                Record record;
                record = records[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    color: record.color,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        spacing: 8.0,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: record.focusNode,
                                  controller: record.controller,
                                  decoration: InputDecoration(labelText: record.hint, hintText: record.hint),
                                  onChanged: (value) {
                                    record.name = value;
                                  },
                                ),
                              ),
                              IconButton(icon: Icon(Icons.check_circle_outline, color: Colors.white), tooltip: strings.endEdit, onPressed: () => removeFocus(index)),
                              IconButton(icon: Icon(Icons.delete, color: Colors.red), tooltip: strings.removeRecord, onPressed: () => removeRecord(index)),
                            ],
                          ),
                          record.panel(record, autoUpdateDate, chooseDate),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        direction: SpeedDialDirection.up,
        children: [
          SpeedDialChild(child: Icon(Icons.forest), label: strings.addPlant, onTap: () => addRecord(RecordType.plant)),
          SpeedDialChild(child: Icon(Icons.baby_changing_station), label: strings.addBaby, onTap: () => addRecord(RecordType.baby)),
          SpeedDialChild(child: Icon(Icons.pets), label: strings.addPet, onTap: () => addRecord(RecordType.pet)),
          SpeedDialChild(child: Icon(Icons.home), label: strings.addHome, onTap: () => addRecord(RecordType.home)),
          SpeedDialChild(child: Icon(Icons.medication), label: strings.addMedicine, onTap: () => addRecord(RecordType.medicine)),
        ],
      ),
      bottomNavigationBar: SizedBox(height: _bannerAd.size.height.toDouble(), width: _bannerAd.size.width.toDouble(), child: AdWidget(ad: _bannerAd)),
    );
  }

  void addRecord(RecordType type) {
    final Record newRecord;
    switch (type) {
      case RecordType.plant:
        newRecord = Plant();
        break;
      case RecordType.baby:
        newRecord = Baby();
        break;
      case RecordType.pet:
        newRecord = Pet();
        break;
      case RecordType.home:
        newRecord = Home();
        break;
      case RecordType.medicine:
        newRecord = Medicine();
        break;
    }
    setState(() {
      records.add(newRecord);
      saveRecords();
    });
  }

  void autoUpdateDate(TextEditingController controller, String dateFormat) {
    setState(() {
      controller.text = DateFormat(dateFormat).format(DateTime.now());
      saveRecords();
    });
  }

  void chooseDate(TextEditingController controller, String dateFormat) async {
    String formattedDate = '';

    if (dateFormat == 'Hm') {
      final TimeOfDay? hourPicked = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 00, minute: 00),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!);
        },
      );
      if (hourPicked != null) {
        formattedDate = hourPicked.format(context);
      }
    } else {
      final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));

      if (picked != null) {
        formattedDate = DateFormat(dateFormat).format(picked);
      }
    }

    setState(() {
      controller.text = formattedDate;
      saveRecords();
    });
  }

  void removeRecord(int index) {
    setState(() {
      records.removeAt(index);
      saveRecords();
    });
  }

  void removeFocus(int index) {
    records[index].focusNode.unfocus();
    saveRecords();
  }

  Future<void> saveRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonList = jsonEncode(records.map((r) => r.toJson()).toList());
    await prefs.setString('records', jsonList);
  }

  Future<void> loadRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('records');

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        records = jsonList.map((json) => Record.fromDynamicJson(json)).toList();
      });
    }
  }
}
