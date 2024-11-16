// alabanza.dart

class Femenil {
  final String numero;
  final String titulo;
  final String letra;

  Femenil({required this.numero, required this.titulo, required this.letra});

  factory Femenil.fromJson(Map<String, dynamic> json) {
    return Femenil(
      numero: json['numero'],
      titulo: json['titulo'],
      letra: json['letra'],
    );
  }
}
