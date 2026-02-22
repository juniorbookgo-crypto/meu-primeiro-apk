class ResultadoModel {
  final DateTime data;
  final String milhar;
  final String centena;
  final String dezena;
  final int grupo;

  ResultadoModel({
    required this.data,
    required this.milhar,
    required this.centena,
    required this.dezena,
    required this.grupo,
  });

  factory ResultadoModel.fromMap(Map<String, dynamic> map) {
    return ResultadoModel(
      data: DateTime.parse(map['data']),
      milhar: map['milhar'],
      centena: map['centena'],
      dezena: map['dezena'],
      grupo: map['grupo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toIso8601String(),
      'milhar': milhar,
      'centena': centena,
      'dezena': dezena,
      'grupo': grupo,
    };
  }
}