import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:atividade_final_dart/utilidades.dart';

// Diretório dos arquivos
final diretorio = Directory('C:/CLIMA/sensores/');
// Colunas de identificação
final colunas = [
    'Mes', 'Dia', 'Hora', 'Temperatura', 'Umidade', 'Densidade do ar',
    'Velocidade do Vento', 'Direcao do Vento'
];

void main() async {
  await mediaTemperatura('SC');  // Chama o método para calcular a média da temperatura
}

// Acessa o diretório dos arquivos CSV
Future<List<dynamic>> lerArquivos(String estado) async {
  // Verifica se o diretório existe
  if (!await diretorio.exists()) {
    print('Pasta não encontrada.');
    return [];
  }

  // Lista todos os arquivos e ordena por nome
  final arquivos = await diretorio
      .list()
      .where((e) => e is File && e.path.contains('$estado.csv'))
      .toList();

  // Por ordem alfabética
  arquivos.sort((a, b) => a.path.compareTo(b.path));
  var linhas = [];
  // Fazendo a leitura dos arquivos
  for (var arquivo in arquivos) {
    if (arquivo is File) {
      print('Lendo o arquivo: ${arquivo.path}');
      // Chamando o método para ler o CSV
      linhas = await lerCSV(arquivo);
    }
  }
  return linhas;
}

// Método de leitura do CSV
Future<List<dynamic>> lerCSV(File arquivo) async {
  // Fazendo leitura das palavras
  final entrada = await arquivo.readAsString(encoding: latin1);
  final linhas = CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(entrada);
  return linhas;
}

Future<void> mediaTemperatura(String estado) async {
  var linhas = await lerArquivos(estado); // Espera os dados de lerArquivos

  // Verifica se as linhas estão vazias
  if (linhas.isEmpty) {
    print('Nenhum dado encontrado.');
    return;
  }

  final soma = linhas.skip(1) // Pula a primeira linha, já que seu índice começa de 1
    .map((linha) => Map.fromIterables(colunas, linha)) // Cria o mapa para cada linha
    .where((dados) => dados.containsKey('Temperatura')) // Filtra apenas os mapas que têm a chave 'Temperatura'
    .map((dados) => dados['Temperatura']) // Extrai os valores de 'Temperatura'
    .whereType<num>() // Filtra apenas os valores numéricos
    .reduce((a, b) => a + b); // Soma os valores encontrados

  // Calcula a média
  double mediaTemp = soma / (linhas.length - 1); // Subtrai 1 devido ao cabeçalho
  print(paraFahrenheit(mediaTemp)); // Chama paraFahrenheit (supondo que converta Celsius para Fahrenheit)
  print(mediaTemp); // Exibe a média em Celsius
}