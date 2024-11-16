import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'alabanza.dart';
import 'alabanza_detail_screen.dart';
import 'data.dart';
import 'alabanzas_elegidas_screen.dart';

class AlabanzasListScreen extends StatefulWidget {
  @override
  _AlabanzasListScreenState createState() => _AlabanzasListScreenState();
}

class _AlabanzasListScreenState extends State<AlabanzasListScreen> {
  List<Alabanza> alabanzas = [];
  List<Alabanza> alabanzasFiltradas = [];
  List<Alabanza> alabanzasElegidas = [];

  TextEditingController _controller = TextEditingController();
  bool showMessage = false;

  @override
  void initState() {
    super.initState();
    loadAlabanzas();
    loadAlabanzasElegidas();
    _controller.addListener(onSearchTextChanged);
  }

  Future<void> loadAlabanzas() async {
    List<Alabanza> loadedAlabanzas = await fetchAlabanzas();
    setState(() {
      alabanzas = loadedAlabanzas;
      alabanzasFiltradas = loadedAlabanzas;
    });
  }

  void onSearchTextChanged() {
    setState(() {
      String searchText = _controller.text.toLowerCase();
      alabanzasFiltradas = alabanzas
          .where((alabanza) =>
              alabanza.numero.toString().contains(searchText) ||
              alabanza.titulo.toLowerCase().contains(searchText))
          .toList();
    });
  }

  void showAddDialog(BuildContext context, Alabanza alabanza) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: const Text(
                            'Agregado Correctamente',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Cerrar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        showMessage = true;
      });
    });
  }

  void addAlabanzaElegida(Alabanza alabanza) {
    setState(() {
      if (!alabanzasElegidas.contains(alabanza)) {
        alabanzasElegidas.add(alabanza);
        saveAlabanzasElegidas();
        showAddDialog(context, alabanza);
      }
    });
  }

  void removeAlabanzaElegida(Alabanza alabanza) {
    setState(() {
      alabanzasElegidas.remove(alabanza);
      saveAlabanzasElegidas();
    });
  }

  void clearAlabanzasElegidas() {
    setState(() {
      alabanzasElegidas.clear();
      saveAlabanzasElegidas();
    });
  }

  Future<void> saveAlabanzasElegidas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alabanzas = alabanzasElegidas
        .map((alabanza) => json.encode(alabanza.toJson()))
        .toList();
    prefs.setStringList('alabanzasElegidas', alabanzas);
  }

  Future<void> loadAlabanzasElegidas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alabanzas = prefs.getStringList('alabanzasElegidas') ?? [];
    setState(() {
      alabanzasElegidas = alabanzas
          .map((alabanza) => Alabanza.fromJson(json.decode(alabanza)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Oculta el teclado y deselecciona el buscador
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Himnario Iglesia De Dios',
            style: TextStyle(fontWeight: FontWeight.bold, shadows: [
              Shadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              )
            ]),
          ),
          elevation: 16,
          shadowColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Buscar alabanza...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: alabanzasFiltradas.isEmpty
                  ? const Center(child: Text('No se encontraron alabanzas'))
                  : ListView.builder(
                      itemCount: alabanzasFiltradas.length,
                      itemBuilder: (context, index) {
                        Alabanza alabanza = alabanzasFiltradas[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              '${alabanza.numero}. ${alabanza.titulo}'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w900),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                addAlabanzaElegida(alabanza);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlabanzaDetailScreen(
                                    alabanza: alabanza,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.list,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          elevation: 16,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlabanzasElegidasScreen(
                  alabanzasElegidas,
                  removeAlabanzaElegida,
                  clearAlabanzasElegidas,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
