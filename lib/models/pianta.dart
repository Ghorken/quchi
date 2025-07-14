import 'package:flutter/material.dart';

class Pianta {
  String nome;
  String dataInnaffiamento;
  String dataConcimazione;
  Color colore;
  late TextEditingController controller;
  late FocusNode focusNode;

  Pianta({this.nome = '', this.dataInnaffiamento = '', this.dataConcimazione = '', this.colore = Colors.white}) {
    controller = TextEditingController(text: nome);
    focusNode = FocusNode();
  }

  Pianta.fromJson(Map<String, dynamic> json)
    : nome = json['nome'],
      dataInnaffiamento = json['dataInnaffiamento'] ?? '',
      dataConcimazione = json['dataConcimazione'] ?? '',
      colore = mapToColor(json['colore']) {
    controller = TextEditingController(text: nome);
    focusNode = FocusNode();
  }

  Map<String, dynamic> toJson() => {'nome': nome, 'dataInnaffiamento': dataInnaffiamento, 'dataConcimazione': dataConcimazione, 'colore': colorToMap(colore)};

  static Color mapToColor(Map<String, dynamic> colorString) {
    return Color.from(
      alpha: (colorString["a"] as num).toDouble(),
      red: (colorString["r"] as num).toDouble(),
      green: (colorString["g"] as num).toDouble(),
      blue: (colorString["b"] as num).toDouble(),
    );
  }

  Map<String, double> colorToMap(Color color) {
    return {"a": color.a, "r": color.r, "g": color.g, "b": color.b};
  }
}
