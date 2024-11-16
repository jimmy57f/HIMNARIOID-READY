import 'package:HimnarioID/alabanza_detail_screen.dart';
import 'package:flutter/material.dart';
import 'alabanza.dart';

class AlabanzasElegidasScreen extends StatefulWidget {
  final List<Alabanza> alabanzasElegidas;
  final Function(Alabanza) removeAlabanzaElegida;
  final Function() clearAlabanzasElegidas;

  AlabanzasElegidasScreen(this.alabanzasElegidas, this.removeAlabanzaElegida,
      this.clearAlabanzasElegidas);

  @override
  _AlabanzasElegidasScreenState createState() =>
      _AlabanzasElegidasScreenState();
}

class _AlabanzasElegidasScreenState extends State<AlabanzasElegidasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Semantics(
          header: true,
          label: 'Pantalla de alabanzas elegidas',
          child: const Text(
            'Alabanzas Elegidas',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Semantics(
            label: 'Eliminar todas las alabanzas elegidas',
            child: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {
                widget.clearAlabanzasElegidas();
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: widget.alabanzasElegidas.isEmpty
          ? Center(
        child: Semantics(
          label: 'No hay alabanzas elegidas',
          child: const Text('No hay alabanzas elegidas',
              style: TextStyle(fontSize: 18, color: Colors.black54)),
        ),
      )
          : ReorderableListView.builder(
        itemCount: widget.alabanzasElegidas.length,
        itemBuilder: (context, index) {
          Alabanza alabanza = widget.alabanzasElegidas[index];
          return Card(
            key: ValueKey(alabanza.numero), // Necesario para que funcione el reordenamiento
            margin:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Semantics(
              label:
              'Alabanza número ${alabanza.numero}: ${alabanza.titulo}',
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                title: Text(
                  '${alabanza.numero}. ${alabanza.titulo}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Semantics(
                  label: 'Eliminar alabanza',
                  child: IconButton(
                    icon:
                    const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      widget.removeAlabanzaElegida(alabanza);
                      setState(() {});
                    },
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AlabanzaDetailScreen(alabanza: alabanza),
                    ),
                  );
                },
              ),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final alabanza = widget.alabanzasElegidas.removeAt(oldIndex);
            widget.alabanzasElegidas.insert(newIndex, alabanza);
          });
        },
      ),
    );
  }
}
