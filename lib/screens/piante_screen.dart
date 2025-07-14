import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/models/pianta.dart';
import 'package:quchi/screens/info_screen.dart';
import 'package:quchi/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PianteScreen extends StatefulWidget {
  const PianteScreen({super.key});

  @override
  State<PianteScreen> createState() => _PianteScreenState();
}

class _PianteScreenState extends State<PianteScreen> {
  List<Pianta> piante = [];
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

    caricaPiante();

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    for (var voce in piante) {
      voce.focusNode.dispose();
      voce.controller.dispose();
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
              itemCount: piante.length,
              itemBuilder: (context, index) {
                final pianta = piante[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    color: pianta.colore,
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
                                  focusNode: pianta.focusNode,
                                  controller: pianta.controller,
                                  decoration: InputDecoration(labelText: strings.plantName),
                                  onChanged: (value) {
                                    pianta.nome = value;
                                    salvaPiante();
                                  },
                                ),
                              ),
                              IconButton(icon: Icon(Icons.check_circle_outline), tooltip: strings.endEdit, onPressed: () => rimuoviFocus(index)),
                              IconButton(icon: Icon(Icons.color_lens), tooltip: strings.changeColor, onPressed: () => mostraColorPicker(index)),
                              IconButton(
                                icon: Icon(Icons.delete, color: pianta.colore == Colors.red ? Colors.white : Colors.red),
                                tooltip: strings.removePlant,
                                onPressed: () => rimuoviPianta(index),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(onPressed: () => aggiornaDataAutomatica(index, true), child: Text(strings.currentDate)),
                              IconButton(icon: Icon(Icons.calendar_today), tooltip: strings.chooseDate, onPressed: () => scegliDataManuale(index, true)),
                              Expanded(
                                child: Text(
                                  pianta.dataInnaffiamento.isEmpty ? strings.emptyDate : '${strings.wateredOn} ${pianta.dataInnaffiamento}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(onPressed: () => aggiornaDataAutomatica(index, false), child: Text(strings.currentDate)),
                              IconButton(icon: Icon(Icons.calendar_today), tooltip: strings.chooseDate, onPressed: () => scegliDataManuale(index, false)),
                              Expanded(
                                child: Text(
                                  pianta.dataConcimazione.isEmpty ? strings.emptyDate : '${strings.concimatedOn} ${pianta.dataConcimazione}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(onPressed: aggiungiPianta, tooltip: strings.addPlant, child: Icon(Icons.add)),
      bottomNavigationBar: SizedBox(height: _bannerAd.size.height.toDouble(), width: _bannerAd.size.width.toDouble(), child: AdWidget(ad: _bannerAd)),
    );
  }

  void aggiungiPianta() {
    setState(() {
      final nuova = Pianta();
      piante.add(nuova);
      salvaPiante();
    });
  }

  void aggiornaDataAutomatica(int index, bool innaffiamento) {
    setState(() {
      innaffiamento
          ? piante[index].dataInnaffiamento = DateFormat('dd/MM/yyyy').format(DateTime.now())
          : piante[index].dataConcimazione = DateFormat('dd/MM/yyyy').format(DateTime.now());
      salvaPiante();
    });
  }

  void scegliDataManuale(int index, bool innaffiamento) async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        innaffiamento ? piante[index].dataInnaffiamento = DateFormat('dd/MM/yyyy').format(picked) : piante[index].dataConcimazione = DateFormat('dd/MM/yyyy').format(picked);
        salvaPiante();
      });
    }
  }

  void rimuoviPianta(int index) {
    setState(() {
      piante.removeAt(index);
      salvaPiante();
    });
  }

  void mostraColorPicker(int index) async {
    Color? coloreScelto = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.chooseColor),
          content: Wrap(
            spacing: 10,
            children:
                [Colors.white, Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange, Colors.purple, Colors.grey, Colors.brown].map((color) {
                  return GestureDetector(onTap: () => Navigator.of(context).pop(color), child: CircleAvatar(backgroundColor: color, radius: 20));
                }).toList(),
          ),
        );
      },
    );

    if (coloreScelto != null) {
      setState(() {
        piante[index].colore = coloreScelto;
        salvaPiante();
      });
    }
  }

  void rimuoviFocus(int index) {
    piante[index].focusNode.unfocus();
  }

  Future<void> salvaPiante() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = jsonEncode(piante.map((p) => p.toJson()).toList());
    await prefs.setString('piante', listaJson);
  }

  Future<void> caricaPiante() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('piante');

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        piante = jsonList.map((json) => Pianta.fromJson(json)).toList();
      });
    }
  }
}
