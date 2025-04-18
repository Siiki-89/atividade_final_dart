import 'dart:math';

import 'ler_csv.dart';

//Colunas de identificação
final colunas = [
    'Mes', 'Dia', 'Hora', 'Temperatura', 'Umidade', 'Densidade do ar',
    'Velocidade do Vento', 'Direcao do Vento'
  ];

//Converter de Celcius para Fahrenheit usando apenas duas casas
String paraFahrenheit(double celsius) => ((celsius * 9 / 5) + 32).toStringAsFixed(2);

//Converter de Celcius para Kelvin
String paraKelvin(double temperatura)=> (temperatura + 273.15).toStringAsFixed(2);

//Verificar se as linhas retornadas são validas
Future<List<Map<String, dynamic>>> obterLinhasValidas(String estado) async {
  var linhas = await lerArquivos(estado);
  
  //Verifica se as linhas estão vazias
  if (linhas.isEmpty) {
    print('Nenhum dado encontrado para $estado.');
    return [];
  }

  return linhas.skip(1) // Ignora o cabeçalho
      .map((linha) => Map.fromIterables(colunas, linha))
      .toList();
}

// Velocidade do vento
String paraKmH(double ms) => (ms * 3.6).toStringAsFixed(2);
String paraMph(double ms) => (ms * 2.23694).toStringAsFixed(2);

// Direção do vento
String paraRadianos(double graus) => (graus * (pi / 180)).toStringAsFixed(4);