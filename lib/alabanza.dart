class Alabanza {
  final int numero;
  final String titulo;
  final String letra;
  String notaMusical; // Añadido para la nota musical

  Alabanza({
    required this.numero,
    required this.titulo,
    required this.letra,
    this.notaMusical = "", // Valor por defecto
  });

  factory Alabanza.fromJson(Map<String, dynamic> json) {
    return Alabanza(
      numero: json['numero'],
      titulo: json['titulo'],
      letra: json['letra'],
      notaMusical: json['notaMusical'] ?? "", // Manejo de notaMusical
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'titulo': titulo,
      'letra': letra,
      'notaMusical': notaMusical, // Añadido para guardar notaMusical
    };
  }
}
