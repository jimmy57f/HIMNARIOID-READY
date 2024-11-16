import 'package:flutter/material.dart';
import 'alabanza_juvenil.dart'; // Importa la clase Alabanza

class JuvenilDetailScreen extends StatelessWidget {
  final Juvenil alabanza;

  const JuvenilDetailScreen({super.key, required this.alabanza});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Semantics(
          header: true, // Indica que esto es un encabezado
          label: 'Título de la alabanza: ${alabanza.titulo}',
          child: Text(
            alabanza.titulo,
            style: const TextStyle(
              fontSize: 22,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Semantics(
              label: 'Información de la convención',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      'Convención:',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          shadows: [
                            Shadow(
                              blurRadius: 3.0,
                              color: Colors.black54,
                              offset: Offset(1.0, 1.0),
                            ),
                          ]),
                    ),
                  ),
                  Text(
                    '${alabanza.numero}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black54,
                            offset: Offset(1.0, 1.0),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Semantics(
              label: 'Letra de la alabanza',
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
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
                child: Text(
                  alabanza.letra,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black54,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
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
