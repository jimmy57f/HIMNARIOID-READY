import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:HimnarioID/my_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  // Variables para el anuncio intersticial
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    loadInterstitialAd(); // Carga el anuncio intersticial

    // Inicialización del controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Animación de escala para el contenedor del logo
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animación de opacidad para el texto
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Iniciar las animaciones
    _controller.forward();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navega a la pantalla principal después de mostrar el anuncio
    Future.delayed(const Duration(seconds: 3), () {
      showInterstitialAd();
    });
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3145406972514388/5909198222", // Usa tu ID de anuncio intersticial
        request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
    _interstitialAd = ad;
    _interstitialAd!.setImmersiveMode(true); // Configura el modo inmersivo

    // Establecer el callback de contenido completo
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
    ad.dispose(); // Libera los recursos del anuncio
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const Principal()),
    );
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    ad.dispose(); // Libera los recursos si no se muestra
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const Principal()),
    );
    },
    );
  },
  onAdFailedToLoad: (LoadAdError error) {
  debugPrint('InterstitialAd failed to load: $error');
  // Si no se carga, navega a la pantalla principal directamente
  Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (context) => const Principal()),
  );
  },
  ),
  );
}

void showInterstitialAd() {
  if (_interstitialAd != null) {
    _interstitialAd!.show();
    _interstitialAd = null; // Desecha el anuncio después de mostrarlo
  } else {
    // Si no hay anuncio, navega a la pantalla principal directamente
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }
}

@override
void dispose() {
  _controller.dispose(); // Liberar recursos del controlador de animación
  _interstitialAd?.dispose(); // Liberar recursos del anuncio intersticial
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Image.asset(
                  "assets/BAUTIZOS.png",
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          FadeTransition(
            opacity: _opacityAnimation,
            child: const Text(
              "IGLESIA DE DIOS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FadeTransition(
            opacity: _opacityAnimation,
            child: const Text(
              "El Salvador",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
