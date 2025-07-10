import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quchi/pianta.dart';

class PianteScreen extends StatefulWidget {
  const PianteScreen({super.key});

  @override
  State<PianteScreen> createState() => _PianteScreenState();
}

class _PianteScreenState extends State<PianteScreen> {
  List<Pianta> piante = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 72, 228, 101),
      appBar: AppBar(title: Text('Quchi'), backgroundColor: const Color.fromARGB(255, 54, 207, 82)),
      body: ListView.builder(
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
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: pianta.focusNode,
                            controller: pianta.controller,
                            decoration: InputDecoration(labelText: 'Nome pianta'),
                            onChanged: (value) => pianta.nome = value,
                          ),
                        ),
                        IconButton(icon: Icon(Icons.check_circle_outline), tooltip: 'Termina modifica', onPressed: () => rimuoviFocus(index)),
                        IconButton(icon: Icon(Icons.delete, color: Colors.red), tooltip: 'Rimuovi pianta', onPressed: () => rimuoviPianta(index)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(onPressed: () => aggiornaDataAutomatica(index), child: Text('Data corrente')),
                        SizedBox(width: 8),
                        IconButton(icon: Icon(Icons.calendar_today), tooltip: 'Scegli data', onPressed: () => scegliDataManuale(index)),
                        SizedBox(width: 8),
                        IconButton(icon: Icon(Icons.color_lens), tooltip: 'Cambia colore', onPressed: () => mostraColorPicker(index)),
                        SizedBox(width: 12),
                        Expanded(child: Text(pianta.data.isEmpty ? 'Data non impostata' : 'Innaffiata il: ${pianta.data}', style: TextStyle(fontSize: 16))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: aggiungiPianta, tooltip: 'Aggiungi pianta', child: Icon(Icons.add)),
    );
  }

  void aggiungiPianta() {
    setState(() {
      piante.add(Pianta());
    });
  }

  void aggiornaDataAutomatica(int index) {
    setState(() {
      piante[index].data = DateFormat('dd/MM/yyyy').format(DateTime.now());
    });
  }

  void scegliDataManuale(int index) async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        piante[index].data = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void rimuoviPianta(int index) {
    setState(() {
      piante.removeAt(index);
    });
  }

  void mostraColorPicker(int index) async {
    Color? coloreScelto = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Scegli un colore"),
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
      });
    }
  }

  void rimuoviFocus(int index) {
    piante[index].focusNode.unfocus();
  }

  @override
  void dispose() {
    for (var voce in piante) {
      voce.focusNode.dispose();
      voce.controller.dispose();
    }
    super.dispose();
  }
}
