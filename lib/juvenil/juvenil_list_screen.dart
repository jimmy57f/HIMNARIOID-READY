import 'package:flutter/material.dart';
import 'alabanza_juvenil.dart'; // Importa la clase Alabanza
import 'juvenil_detail_screen.dart'; // Importa la pantalla de detalle de la alabanza
import 'data_juvenil.dart'; // Importa la función fetchAlabanzas

class JuvenilListScreen extends StatefulWidget {
  @override
  _JuvenilListScreenState createState() => _JuvenilListScreenState();
}

class _JuvenilListScreenState extends State<JuvenilListScreen> {
  List<Juvenil> alabanzas = [];
  List<Juvenil> alabanzasFiltradas = [];
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadAlabanzas();
    _controller.addListener(onSearchTextChanged);
  }

  Future<void> loadAlabanzas() async {
    List<Juvenil> loadedAlabanzas = await fetchAlabanzasJuveniles();
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
          title: Semantics(
            header: true,
            label: 'Lista de himnos de las Convenciones Juveniles',
            child: const Text(
              'Convenciones Juveniles',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
          shadowColor: Colors.black,
          elevation: 10,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Semantics(
                label: 'Campo de búsqueda para encontrar himnos lema',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: Offset(3, 3),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Buscar himno lema...',
                      hintText: 'Ingrese el número o título del himno',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: alabanzasFiltradas.isEmpty
                  ? Center(
                      child: Semantics(
                        label: 'No se encontraron alabanzas',
                        child: const Text(
                          'No se encontraron alabanzas',
                          style: TextStyle(
                            fontSize: 16.0,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black54,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: alabanzasFiltradas.length,
                      itemBuilder: (context, index) {
                        Juvenil alabanza = alabanzasFiltradas[index];
                        return Semantics(
                          button: true,
                          label:
                              'Alabanza número ${alabanza.numero}, ${alabanza.titulo}'.toUpperCase(),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  offset: Offset(3, 3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                '${alabanza.numero}. ${alabanza.titulo}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JuvenilDetailScreen(
                                      alabanza: alabanza,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
