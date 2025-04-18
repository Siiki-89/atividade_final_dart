import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';


//Diretorio dos arquivos
final diretorio = Directory('C:/CLIMA/sensores/');
//Acessa o diretorio dos arquivos CSV
Future<List<dynamic>> lerArquivos(String estado) async{
  //Verifica se o diretorio existe
  if (!await diretorio.exists()) {
    print('Pasta não encontrada.');
    return [];
  }

  //Lista todos os arquivos e ordena por nome
  final arquivos = await diretorio
      .list()
      .where((e) => e is File && e.path.contains(estado) && e.path.endsWith('.csv'))
      .toList();

  //Por ordem alfabética
  arquivos.sort((a, b) => a.path.compareTo(b.path));
  var linhas = [];
  
  //Fazendo a leitura dos arquivos
  for (var arquivo in arquivos) {
    if (arquivo is File) {
      //print('Lendo o arquivo: ${arquivo.path}');
      //Chamando metodo para ler CSV
      final linhasDoArquivo = await lerCSV(arquivo);
      linhas.addAll(linhasDoArquivo);
    }
  }
  return linhas; 
}

//Metodo de leitura CSV
Future<List<dynamic>> lerCSV (File arquivo) async{
  //Fazendo leitura das palavras
  final entrada = await arquivo.readAsString(encoding: latin1);
  final linhas = CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(entrada);
  return linhas;
  
}