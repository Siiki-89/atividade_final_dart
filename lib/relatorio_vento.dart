import 'dart:collection';
import 'dart:math';

import 'package:atividade_final_dart/utilidades.dart';

Future<void> chamarMetodosVento(String uF) async {
  await direcaoMaisFrequenteAnual(uF);
  await direcaoMaisFrequenteMensal(uF);
}

Future<void> direcaoMaisFrequenteAnual(String estado) async {
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se está vazia
  if (dados.isEmpty) return;


  final direcoes = dados
      .where((dado) => dado['Direcao do Vento'] is num && dado['Direcao do Vento'] != 0)
      .map((dado) => dado['Direcao do Vento'] as num)
      .toList();

  if (direcoes.isEmpty) {
    print('Nenhuma direção de vento válida encontrada.\n');
    return;
  }

  //Conta a frequência de cada direção
  var frequencias = HashMap<num, int>(); //num: direção do vento; int: a quantidade que a direção apareceu

  //Contando quantas vezes cada direção aparece
  for (var direcao in direcoes) {
    frequencias[direcao] = (frequencias[direcao] ?? 0) + 1;
  }

  //Encontra a direção com maior frequência
  var direcaoMaisFrequente = frequencias.entries.reduce((a, b) => a.value > b.value ? a : b);

  //Imprime a direção mais frequente em graus e radianos
  print('Direção do vento mais frequente em $estado por ano:');
  print('Graus: ${direcaoMaisFrequente.key}');
  print('Radianos: ${paraRadianos(direcaoMaisFrequente.key.toDouble())}\n');
}

Future<void> direcaoMaisFrequenteMensal(String estado) async {
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se está vazia
  if (dados.isEmpty) return;

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
      print('Mês $mes: Sem dados.\n');
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
    print('Mês $mes');
    print('Graus: ${maisFrequente.key}');
    print('Radianos: ${paraRadianos(maisFrequente.key.toDouble())}\n');
  }
}
