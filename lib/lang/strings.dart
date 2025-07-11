import 'dart:io';

import 'package:quchi/lang/en.dart';
import 'package:quchi/lang/it.dart';

abstract class Strings {
  String get title;

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
