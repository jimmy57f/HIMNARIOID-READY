import 'package:HimnarioID/MusicPlayerScreen.dart';
import 'package:HimnarioID/pistas.dart';
import 'package:flutter/material.dart';
import 'convenciones.dart';
import 'pdf_list_screen.dart';
import 'alabanzas_list_screen.dart';
import 'package:in_app_update/in_app_update.dart';

class Principal extends StatelessWidget {

  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    // Mostrar el diálogo flotante al iniciar la app
    Future.delayed(Duration.zero, () => _showReminderDialog(context));

    // Verificar actualizaciones al iniciar la app
    UpdateChecker().checkForUpdate();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Text(
                "Himnario ID",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
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
              const SizedBox(height: 35),
              Center(
                child: Image.asset(
                  "assets/BAUTIZOS.png",
                  width: 350,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              _buildElevatedButton(
                context,
                label: "Himnario Seleccionado",
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(AlabanzasListScreen()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildElevatedButton(
                context,
                label: "Himnos lema",
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(const Convenciones()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildElevatedButton(
                context,
                label: "Escuelas Sabaticas",
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(PDFListScreen()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildElevatedButton(
                context,
                label: "Pistas",
                onPressed: () {
                  Navigator.of(context).push(
                    _createPageRoute(Pistas()),
                  );
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
          fontSize: 16,
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

  // Función que muestra el cuadro de diálogo al iniciar la app
  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            textAlign: TextAlign.center,
            "Paz amada iglesia, recordatorio de actualización",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              Text(
                "les recordamos que deben actualizar la app cada sábado de inicio de trimestre, para que puedan tener las últimas escuelas y funciones nuevas que se le van agregando a la app.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              Text(
                "Paz a cada uno de vosotros",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo al presionar Aceptar
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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

void showAvailableSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
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
                      'Disponible Pronto',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class UpdateChecker {
  Future<void> checkForUpdate() async {
    try {
      // Verifica si hay actualizaciones disponibles
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      // Si hay una actualización disponible
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Intenta realizar la actualización inmediata
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      print("Error al verificar actualizaciones: $e");
      // Manejo de errores
    }
  }
}
