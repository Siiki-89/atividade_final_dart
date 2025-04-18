import 'package:atividade_final_dart/utilidades.dart';
import 'package:yaansi/yaansi.dart';

Future<void> chamarMetodosTemperatura(String uF) async {
  await analiseAnulTemperatura(uF);
  await analiseMensalTemperatura(uF);
  await mediaPorHora(uF);
}
  
//Relatorio por estado por ano
Future<void> analiseAnulTemperatura (String estado) async {
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //verifica se esta vazia
  if (dados.isEmpty) return;

  //Obtem as temperaturas
  final temperaturas = dados
      .where((dados) => dados['Temperatura'] is num)
      .map((dados) => dados['Temperatura'] as num)
      .toList();

  //Verifica se retornou vazia
  if (temperaturas.isEmpty) {
    print('Nenhuma temperatura válida encontrada.\n');
    return;
  }
  //Calcula a soma e depois a media das temperaturas retornadas por estado
  final soma = temperaturas.reduce((a, b) => a + b);
  final mediaTemp = soma / temperaturas.length;

  //Calcula a máxima e a mínima
  final maxTemp = temperaturas.reduce((a, b) => a > b ? a : b);
  final minTemp = temperaturas.reduce((a, b) => a < b ? a : b);

  //Imprime os valores da média e converte
  imprimirDadosMensais(mediaTemp, maxTemp, minTemp, estado, 0, 0);
}

void imprimirDadosMensais (double media, num maxTemp, num minTemp, String estado, int mes, int hora){

  if(estado.isEmpty){
    print('Média de temperatura em $estado por ano:');
  } else if (mes != 0){
    print('Média no mês $mes');
  } else if (hora != 0){
    print('Hora $hora');
  }

  //Imprime os valores da média e converte
  print('C°: ${media.toStringAsFixed(2)}');
  print('Fahrenheit: ${paraFahrenheit(media)}');
  print('Kelvin: ${paraKelvin(media)}\n');

  //Imprime o valor da máxima e converte 
  print('Temperatura máxima:');
  print('C°: ${maxTemp.toStringAsFixed(2)}');
  print('Fahrenheit: ${paraFahrenheit(maxTemp.toDouble())}');
  print('Kelvin: ${paraKelvin(maxTemp.toDouble())}\n');

  //Imprime o valor da minima e converte
  print('Temperatura mínima:');
  print('C°: ${minTemp.toStringAsFixed(2)}');
  print('Fahrenheit: ${paraFahrenheit(minTemp.toDouble())}');
  print('Kelvin: ${paraKelvin(minTemp.toDouble())}\n');
}

Future<void> analiseMensalTemperatura(String estado) async {
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se as linhas estão vazias
  if (dados.isEmpty) return;

  print('Temperatura no estado de $estado por mês:');

  //For para cada mês do ano (1 até 12)
  for (int mes = 1; mes <= 12; mes++) {
     final temperaturas = dados
        .where((dados) =>
            int.tryParse(dados['Mes'].toString()) == mes && //Verifica se o Mes convertido para int é igual o mes do loop
            dados['Temperatura'] is num) //Garante que é numerico
        .map((dados) => dados['Temperatura'] as num) //Converte os valores de Temperatura para num
        .toList(); //Converte para lista

    //Verifica se nao retornou vazio
    if (temperaturas.isEmpty) {
      print('Mês $mes: Sem dados.\n');
      continue;
    }

    //Calcula a soma e depois a media retornada no mes
    final soma = temperaturas.reduce((a, b) => a + b);
    final media = soma / temperaturas.length;

    //Calcula a máxima e a mínima
    final maxTemp = temperaturas.reduce((a, b) => a > b ? a : b);
    final minTemp = temperaturas.reduce((a, b) => a < b ? a : b);

    imprimirDadosMensais(media, maxTemp, minTemp, estado, 0, 0);
    //Imprime os valores e converte
    print('Média no mês $mes');
    print('C°: ${media.toStringAsFixed(2)}');
    print('Fahrenheit: ${paraFahrenheit(media)}');
    print('Kelvin: ${paraKelvin(media)}\n');

    //Imprime o valor da máxima e converte 
    print('Temperatura máxima:');
    print('C°: ${maxTemp.toStringAsFixed(2)}');
    print('Fahrenheit: ${paraFahrenheit(maxTemp.toDouble())}');
    print('Kelvin: ${paraKelvin(maxTemp.toDouble())}\n');

    //Imprime o valor da minima e converte
    print('Temperatura mínima:');
    print('C°: ${minTemp.toStringAsFixed(2)}');
    print('Fahrenheit: ${paraFahrenheit(minTemp.toDouble())}');
    print('Kelvin: ${paraKelvin(minTemp.toDouble())}\n');
  }
}

Future<void> mediaPorHora(String estado) async {
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se as linhas estão vazias
  if (dados.isEmpty) return;

  print('Média, Máxima e Mínima de temperatura no estado de $estado por hora:');

  //For para cada hora do dia (de 1 até 24)
  for (int hora = 1; hora <= 24; hora++) {
    // Filtra os dados para pegar as temperaturas da hora atual
    final temperaturas = dados
        .where((dados) =>
            int.tryParse(dados['Hora'].toString()) == hora && //Verifica se a Hora convertida para int é igual do loop
            dados['Temperatura'] is num) //Garante que a temperatura seja numérica
        .map((dados) => dados['Temperatura'] as num) //Converte para num
        .toList(); //Converte para lista

    //Verifica se não retornou vazio
    if (temperaturas.isEmpty) {
      print('Hora $hora: Sem dados.\n');
      continue;
    }

    //Calcula a soma e depois a média da temperatura para a hora
    final soma = temperaturas.reduce((a, b) => a + b);
    final media = soma / temperaturas.length;

    //Imprime os valores e converte
    print('Hora $hora');
    print('Média C°: ${media.toStringAsFixed(2)}');
    print('Fahrenheit: ${paraFahrenheit(media)}');
    print('Kelvin: ${paraKelvin(media)}\n');

  }
}


