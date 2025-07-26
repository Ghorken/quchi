import 'dart:io';

import 'package:quchi/lang/en.dart';
import 'package:quchi/lang/it.dart';

abstract class Strings {
  String get title;
  String get recordName;
  String get endEdit;
  String get removeRecord;
  String get currentDate;
  String get currentHour;
  String get chooseDate;
  String get changeColor;
  String get emptyDate;
  String get plantName;
  String get wateredOn;
  String get fertilizedOn;
  String get babyName;
  String get poopedAt;
  String get peedAt;
  String get eatedAt;
  String get petName;
  String get poopedOn;
  String get bedCleanedOn;
  String get homeName;
  String get showerCleanedOn;
  String get windowsCleanedOn;
  String get fridgeCleanedOn;
  String get freezerCleanedOn;
  String get medicineName;
  String get takenOn;
  String get takenAt;
  String get addPlant;
  String get addBaby;
  String get addPet;
  String get addHome;
  String get addMedicine;
  String get chooseColor;

  String get info;
  String get bugRequest;
  String get join;
  String get email;
  String get support;
  String get discord;
  String get urlError;
  String get sendEmail;
}

Strings get strings {
  if (Platform.localeName.contains("it")) {
    return It();
  } else {
    return En();
  }
}
