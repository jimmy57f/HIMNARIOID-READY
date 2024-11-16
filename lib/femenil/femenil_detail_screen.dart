import 'package:flutter/material.dart';
import 'alabanza_femenil.dart'; // Importa la clase Alabanza

class FemenilDetailScreen extends StatelessWidget {
  final Femenil alabanza;

  const FemenilDetailScreen({super.key, required this.alabanza});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Semantics(
          header: true,
          label: 'Título de la alabanza: ${alabanza.titulo}',
          child: Text(
            alabanza.titulo,
            style: const TextStyle(
              fontSize: 20,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Semantics(
              label: 'Información de la convención',
              child: Container(
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ExcludeSemantics(
                      child: Text(
                        'Convención:',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
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
                    const SizedBox(height: 5),
                    Text(
                      '${alabanza.numero}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: 'Letra de la alabanza',
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
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(
                  alabanza.letra,
                  style: const TextStyle(
                    fontSize: 21,
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
