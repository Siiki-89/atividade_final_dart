import 'package:atividade_final_dart/utilidades.dart';
import 'package:yaansi/yaansi.dart';

final buffer = StringBuffer();

Future<void> chamarMetodosTemperatura() async {
  try {
    await analiseAnulTemperatura('SC');
    await analiseAnulTemperatura('SP');
    
    await analiseMensalTemperatura('SC');
    await analiseMensalTemperatura('SP');

    await mediaPorHora('SC');
    await mediaPorHora('SP');

    await salvarRelatorio(buffer.toString(), 'CLIMA');
    buffer.clear();
    print('Relatório completo salvo com sucesso.\n');
  } catch (e) {
    print('Erro ao chamar métodos de temperatura: $e');
  }
}
  
//Relatorio por estado por ano
Future<void> analiseAnulTemperatura (String estado) async {
  try{
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
    final media = soma / temperaturas.length;

    //Calcula a máxima e a mínima
    final maxTemp = temperaturas.reduce((a, b) => a > b ? a : b);
    final minTemp = temperaturas.reduce((a, b) => a < b ? a : b);

    //Imprime os valores da média e converte
    String texto = 'Média de temperatura em $estado por ano:';
    imprimirTemperaturas(texto, media, maxTemp, minTemp);
    } catch (e){
      print('Erro na análise anual de temperatura: $e');
    }
  
}

Future<void> analiseMensalTemperatura(String estado) async {
  try{
    //Verifica as linhas e as obtem caso valida
    final dados = await obterLinhasValidas(estado);

    //Verifica se as linhas estão vazias
    if (dados.isEmpty) return;

    buffer.writeln('Temperatura no estado de $estado por mês:');

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

      //Imprime os valores e converte
      String texto = 'Média no mês $mes';
      imprimirTemperaturas(texto, media, maxTemp, minTemp);
    }
  } catch (e){
    print('Erro na análise mensal de temperatura: $e');
  }
  
}

Future<void> mediaPorHora(String estado) async {
  try{
    //Verifica as linhas e as obtem caso valida
    final dados = await obterLinhasValidas(estado);

    //Verifica se as linhas estão vazias
    if (dados.isEmpty) return;

    buffer.writeln('Média, Máxima e Mínima de temperatura no estado de $estado por hora:');

    //For para cada hora do dia (de 1 até 24)
    for (int mes = 1; mes <= 24; mes++) {
      // Filtra os dados para pegar as temperaturas da hora atual
      final temperaturas = dados
          .where((dados) =>
              int.tryParse(dados['Hora'].toString()) == mes && //Verifica se a Hora convertida para int é igual do loop
              dados['Temperatura'] is num) //Garante que a temperatura seja numérica
          .map((dados) => dados['Temperatura'] as num) //Converte para num
          .toList(); //Converte para lista

      //Verifica se não retornou vazio
      if (temperaturas.isEmpty) {
        print('Hora $mes: Sem dados.\n');
        continue;
      }

      //Calcula a soma e depois a média da temperatura para a hora
      final soma = temperaturas.reduce((a, b) => a + b);
      final media = soma / temperaturas.length;

      final String texto = 'Hora $mes';
      //Chama método para imprimir
      imprimirTemperaturas(texto, media, 0,0);
    }
  } catch (e){
    print('Erro na análise media por hora de temperatura: $e');
  }
}

//Imprimir temperaturas reunido em um unico metodo
void imprimirTemperaturas(String texto, double media, num maxTemp, num minTemp) async {
  
  if(maxTemp == 0 && minTemp == 0){
    //mediaPorHora
    buffer.writeln('$texto:');
    buffer.writeln('Média C°: ${media.toStringAsFixed(2)}'.red);
    buffer.writeln('Fahrenheit: ${paraFahrenheit(media)}'.yellow);
    buffer.writeln('Kelvin: ${paraKelvin(media)}\n'.blue);
    //Imprime e salva
    print(buffer.toString());

  } else {
    //Média
    buffer.writeln('$texto:');
    buffer.writeln('Média:');
    buffer.writeln('C°: ${media.toStringAsFixed(2)}'.red);
    buffer.writeln('Fahrenheit: ${paraFahrenheit(media)}'.yellow);
    buffer.writeln('Kelvin: ${paraKelvin(media)}\n'.blue);
    
    //Máxima
    buffer.writeln('Temperatura máxima:');
    buffer.writeln('C°: ${maxTemp.toStringAsFixed(2)}'.red);
    buffer.writeln('Fahrenheit: ${paraFahrenheit(maxTemp.toDouble())}'.yellow);
    buffer.writeln('Kelvin: ${paraKelvin(maxTemp.toDouble())}\n'.blue);
    
    //Mínima
    buffer.writeln('Temperatura mínima:');
    buffer.writeln('C°: ${minTemp.toStringAsFixed(2)}'.red);
    buffer.writeln('Fahrenheit: ${paraFahrenheit(minTemp.toDouble())}'.yellow);
    buffer.writeln('Kelvin: ${paraKelvin(minTemp.toDouble())}\n'.blue);

    //Imprime e salva
    print(buffer.toString());
  }
}



