import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alabanza.dart';

class AlabanzaDetailScreen extends StatefulWidget {
  final Alabanza alabanza;

  const AlabanzaDetailScreen({super.key, required this.alabanza});

  @override
  _AlabanzaDetailScreenState createState() => _AlabanzaDetailScreenState();
}

class _AlabanzaDetailScreenState extends State<AlabanzaDetailScreen> {
  late TextEditingController _notaController;

  @override
  void initState() {
    super.initState();
    _notaController = TextEditingController();
    _loadNotaMusical();
  }

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _loadNotaMusical() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNota = prefs.getString('nota_${widget.alabanza.numero}') ?? '';
    setState(() {
      _notaController.text = savedNota;
    });
  }

  Future<void> _saveNotaMusical() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'nota_${widget.alabanza.numero}', _notaController.text);

    // Mostrar mensaje de éxito con un SnackBar estilizado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Nota guardada',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Semantics(
          header: true,
          label: 'Título de la alabanza: ${widget.alabanza.titulo}'.toUpperCase(),
          child: Text(
            widget.alabanza.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black54,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ),
        shadowColor: Colors.black,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNotaMusical,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(3, 3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    'Número: ${widget.alabanza.numero}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 100, // Ajusta el ancho del TextField aquí
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(3, 3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _notaController,
                    style: const TextStyle(
                      fontSize: 18, // Tamaño de letra más grande
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nota',
                      hintStyle: TextStyle(
                        fontSize: 16, // Tamaño del texto del hint
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    ),
                    onChanged: (value) {
                      // Lógica opcional para cuando el texto cambie
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Semantics(
              label: 'Letra de la alabanza',
              child: Container(
                padding: const EdgeInsets.all(15),
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
                alignment: Alignment.center,
                child: Text(
                  widget.alabanza.letra,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
