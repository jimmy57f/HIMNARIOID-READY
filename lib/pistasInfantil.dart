import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class pistasInfantil extends StatefulWidget {
  @override
  _pistasInfantilState createState() => _pistasInfantilState();
}

class _pistasInfantilState extends State<pistasInfantil>
    with SingleTickerProviderStateMixin {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _musicFiles = [];
  List<String> _filteredMusicFiles = [];
  String? _currentPlaying;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _loadMusicFiles();
    _setupAudioPlayer();

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _rotateAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _filteredMusicFiles = _musicFiles
            .where((file) =>
            file.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  Future<void> _loadMusicFiles() async {
    try {
      final ListResult result = await _storage.ref('musica/infantil').listAll();
      setState(() {
        _musicFiles = result.items.map((ref) => ref.name).toList();

        // Ordenar los archivos por el número antes de "ª"
        _musicFiles.sort((a, b) {
          final RegExp regExp = RegExp(r'(\d+)');
          final int? numA = int.tryParse(regExp.firstMatch(a)?.group(0) ?? '0');
          final int? numB = int.tryParse(regExp.firstMatch(b)?.group(0) ?? '0');
          return numA!.compareTo(numB!);
        });

        _filteredMusicFiles = List.from(_musicFiles);
      });
    } catch (e) {
      print("Error al cargar archivos: $e");
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.playingStream.listen((isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _nextMusic();
      }
    });
  }

  Future<void> _playMusic(String fileName) async {
    try {
      setState(() {
        _isLoading = true;
        _currentPlaying = fileName;
      });

      final File localFile = await _downloadFile(fileName);
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(localFile.path)));

      setState(() {
        _currentIndex = _musicFiles.indexOf(_currentPlaying!);
        _isLoading = false;
      });

      await _audioPlayer.play();
    } catch (e) {
      print("Error al reproducir música: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _nextMusic() async {
    if (_musicFiles.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _musicFiles.length;
      await _playMusic(_musicFiles[_currentIndex]);
    }
  }

  Future<void> _previousMusic() async {
    if (_musicFiles.isNotEmpty) {
      _currentIndex = (_currentIndex - 1) % _musicFiles.length;
      if (_currentIndex < 0) {
        _currentIndex = _musicFiles.length - 1; // Volver al final de la lista
      }
      await _playMusic(_musicFiles[_currentIndex]);
    }
  }

  Future<File> _downloadFile(String fileName) async {
    final ref = _storage.ref('musica/infantil/$fileName');
    final filePath = await _getLocalFilePath(fileName);
    final File localFile = File(filePath);

    if (await localFile.exists()) {
      return localFile;
    }

    try {
      final TaskSnapshot downloadTask = await ref.writeToFile(localFile);
      if (downloadTask.state == TaskState.success) {
        return localFile;
      } else {
        throw Exception("Error al descargar el archivo: $fileName");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Himnos Infantiles'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_rotateAnimation.value * 3.1416),
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/3d_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSearchBar(),
                Expanded(child: _buildMusicList()),
                _build3DMusicPlayer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _build3DMusicPlayer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.6),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isLoading
              ? CircularProgressIndicator(color: Colors.red)
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeIn,
              )),
              child: Text(
                _currentPlaying ?? 'No hay música seleccionada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                _position.inMinutes.toString().padLeft(2, '0') + ':' +
                    (_position.inSeconds.remainder(60)).toString().padLeft(2, '0'),
                style: TextStyle(color: Colors.white),
              ),
              Expanded(
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  activeColor: Colors.red,
                  inactiveColor: Colors.white54,
                  onChanged: (value) async {
                    final newPosition = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(newPosition);
                  },
                ),
              ),
              Text(
                _duration.inMinutes.toString().padLeft(2, '0') + ':' +
                    (_duration.inSeconds.remainder(60)).toString().padLeft(2, '0'),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _animatedButton(Icons.skip_previous, _previousMusic), // Botón de anterior
              _animatedButton(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                _togglePlayPause,
              ),
              _animatedButton(Icons.skip_next, _nextMusic), // Botón de siguiente
            ],
          ),
        ],
      ),
    );
  }

  Widget _animatedButton(IconData icon, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMusicList() {
    return ListView.builder(
      itemCount: _filteredMusicFiles.length,
      itemBuilder: (context, index) {
        final fileName = _filteredMusicFiles[index];
        return ListTile(
          leading: Icon(Icons.music_note, color: Colors.white),
          title: Text(
            fileName,
            style: TextStyle(color: Colors.white),
          ),
          onTap: () => _playMusic(fileName),
        );
      },
    );
  }
}
