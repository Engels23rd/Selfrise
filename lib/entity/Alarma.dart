class Alarma {
  late String tipo;
  late String hora;
  late String? dias;

  Alarma({
    required this.tipo,
    required this.hora,
    this.dias,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'hora': hora,
      'dias': dias,
    };
  }
}
