import 'dart:collection';
import 'package:atividade_final_dart/utilidades.dart';
import 'package:yaansi/yaansi.dart';

final buffer = StringBuffer();

Future<void> chamarMetodosVento() async {
  try{
    //chamando os metodos e passando o UF como parametro
    await direcaoMaisFrequenteAnual('SC');
    await direcaoMaisFrequenteAnual('SP');

    await direcaoMaisFrequenteMensal('SC');
    await direcaoMaisFrequenteMensal('SP');

    //Para salvar o relatorio do vento gerado
    await salvarRelatorio(buffer.toString(), 'VENTO');

    buffer.clear(); //Limpando o buffer

    print('Relatório completo salvo com sucesso.\n');
  } catch (e){
    print('Erro ao chamar métodos do vento: $e');
  }
}

Future<void> direcaoMaisFrequenteAnual(String estado) async {
  try{
    //Verifica as linhas e as obtem caso valida
    final dados = await obterLinhasValidas(estado);

    //Verifica se está vazia
    if (dados.isEmpty) return;


    final direcoes = dados
        .where((dado) => dado['Direcao do Vento'] is num && dado['Direcao do Vento'] != 0)
        .map((dado) => dado['Direcao do Vento'] as num)
        .toList();

    if (direcoes.isEmpty) {
      buffer.writeln('Nenhuma direção de vento válida encontrada.\n');
      return;
    }

    //Conta a frequência de cada direção
    var frequencias = HashMap<num, int>(); //num: direção do vento; int: a quantidade que a direção apareceu

    //Contando quantas vezes cada direção aparece
    for (var direcao in direcoes) {
      frequencias[direcao] = (frequencias[direcao] ?? 0) + 1;
    }

    //Encontra a direção com maior frequência
    var maisFrequente = frequencias.entries.reduce((a, b) => a.value > b.value ? a : b);

    //Imprime a direção mais frequente em graus e radianos
    String texto = 'Direção do vento mais frequente em $estado por ano:';
    imprimirVento(texto, maisFrequente);

  } catch (e){
    print('Erro na análise da direção mais frequente do vento anual: $e');
  }
}

Future<void> direcaoMaisFrequenteMensal(String estado) async {
  try{
    //Verifica as linhas e as obtem caso valida
    final dados = await obterLinhasValidas(estado);

    //Verifica se está vazia
    if (dados.isEmpty) return;

    buffer.writeln('Direção do vento mais frequente em $estado por mês:');
    print('Direção do vento mais frequente em $estado por mês:');

    //For para cada mês do ano (1 até 12)
    for (int mes = 1; mes <= 12; mes++) {
      final direcoes = dados
          .where((dados) =>
              int.tryParse(dados['Mes'].toString()) == mes && //Verifica se o Mes convertido para int é igual o mes do loop
              dados['Direcao do Vento'] is num &&//Garente que a direção seja númerica
              dados['Direcao do Vento'] != 0)
          .map((dados) => dados['Direcao do Vento'] as num) //Converte para num
          .toList(); //Converte para lista
      //Verifica se nao retornou vazio
      if (direcoes.isEmpty) {
        buffer.writeln('Mês $mes: Sem dados.\n');
        continue;
      }

      final frequencia = HashMap<num, int>(); //num: direção do vento; int: a quantidade que a direção apareceu

      //Contando quantas vezes cada direção aparece
      for (var direcao in direcoes) {
        frequencia[direcao] = (frequencia[direcao] ?? 0) + 1;
      }

      //Encontra a direção com maior frequência
      final maisFrequente = frequencia.entries.reduce((a, b) => a.value > b.value ? a : b);

      //Imprime a direção mais frequente em graus e radianos
      String texto = 'Mês $mes';
      imprimirVento(texto, maisFrequente);
    }
  } catch(e){
    print('Erro na análise da direção mais frequente do vento mensal: $e');
  }
}

//Imprimir umidade reunido em um metodo
void imprimirVento(String texto, MapEntry<num, int> maisFrequente ){
  // Cria uma String temporária para imprimir
  final trecho = StringBuffer();

  trecho.writeln(texto);
  trecho.writeln('Graus: ${maisFrequente.key}'.yellow);
  trecho.writeln('Radianos: ${paraRadianos(maisFrequente.key.toDouble())}\n'.yellow);

  //Imprime e salva
  print(trecho.toString());
  // Acumula no buffer
  buffer.write(trecho.toString());
}
