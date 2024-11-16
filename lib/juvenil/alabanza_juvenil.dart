// alabanza.dart

class Juvenil {
  final String numero;
  final String titulo;
  final String letra;

  Juvenil({required this.numero, required this.titulo, required this.letra});

  factory Juvenil.fromJson(Map<String, dynamic> json) {
    return Juvenil(
      numero: json['numero'],
      titulo: json['titulo'],
      letra: json['letra'],
    );
  }
}
