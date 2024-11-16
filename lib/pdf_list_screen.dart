import 'package:flutter/material.dart';
import 'pdf_screen.dart';

class PDFListScreen extends StatelessWidget {
  final List<Map<String, String>> pdfFiles = [
    {
      'name': 'Escuela General',
      'path': 'assets/adultos4.pdf',
      'image': 'assets/general.jpg'
    },
    {
      'name': 'Escuela Juvenil',
      'path': 'assets/escuelajuvenil4.pdf',
      'image': 'assets/jovenes.jpg'
    },
    {
      'name': 'Escuela Infantil',
      'path': 'assets/escuelainfantil4.pdf',
      'image': 'assets/niños.jpg'
    },
    {
      'name': 'Escuela Femenil',
      'path': 'assets/escuelafemenil4.pdf',
      'image': 'assets/femenil2.jpg'
    },
  ];

  PDFListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Escuelas Sabáticas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                return _buildCard(
                  context,
                  pdfFiles[index]['image']!,
                  pdfFiles[index]['name']!,
                  pdfFiles[index]['path']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String imagePath,
    String title,
    String pdfPath,
  ) {
    return Card(
      elevation: 8, // Adds shadow for 3D effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        // Rounded corners
      ),
      margin: const EdgeInsets.all(10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Rounded image corners
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black45,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(pdfPath),
            ),
          );
        },
      ),
    );
  }
}
