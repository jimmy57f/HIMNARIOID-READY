import 'package:HimnarioID/MusicPlayerScreen.dart';
import 'package:HimnarioID/PistasCampamentos.dart';
import 'package:HimnarioID/PistasFemenil.dart';
import 'package:HimnarioID/pistasInfantil.dart';
import 'package:flutter/material.dart';
import 'femenil/femenil_list_screen.dart';
import 'juvenil/juvenil_list_screen.dart';
import 'widgets/Header_Convenciones.dart';

class Pistas extends StatelessWidget {
  const Pistas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Himnos Lema',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        shadowColor: Colors.black,
        elevation: 10,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeaderConvenciones(),
          const SizedBox(height: 50),
          Column(
            children: <Widget>[
              _buildElevatedButton(
                context,
                label: 'JUVENIL',
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(MusicPlayerScreen()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildElevatedButton(
                context,
                label: 'FEMENIL',
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(PistasFemenil()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildElevatedButton(
                context,
                label: 'INFANTIL',
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(pistasInfantil()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildElevatedButton(
                context,
                label: 'CAMPAMENTOS',
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(Pistascampamentos()),
                  ); // Muestra el dialog
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildElevatedButton(
      BuildContext context, {
        required String label,
        required VoidCallback onPressed,
      }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.25),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
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
    );
  }

  PageRouteBuilder _createPageRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return screen;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeOut;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}

// Función para mostrar el diálogo de "Muy pronto"
void showAvailableSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
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
                      'Muy Pronto',
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                            ),
                          ]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Cambia el color de fondo a negro
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
