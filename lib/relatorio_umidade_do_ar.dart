import 'package:atividade_final_dart/utilidades.dart';


void chamarMetodosUmidade(String uF) async {
  await analiseAnualUmidade(uF);
  await analiseMensalUmidade(uF);
}

Future<void> analiseAnualUmidade(String estado) async{
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se está vazia
  if(dados.isEmpty) return;

  //Obtem as umidades
  final umidade = dados
      .where((dados) => dados['Umidade'] is num)
      .map((dados) => dados['Umidade'] as num)
      .toList();
  
  //Verifica se retornou vazia
  if (umidade.isEmpty){
    print('Nenhuma dado de umidade válido encontrado.\n');
    return;
  }

  //Calcula a soma e depois a média das umidades retornadas por estado
  final soma = umidade.reduce((a, b) => a + b);
  final mediaUmidade = soma/umidade.length;

  //Calcula a máxima e a mínima
  final maxUmidade = umidade.reduce((a, b) => a > b ? a : b);
  final minUmidade  = umidade.reduce((a, b) => a < b ? a : b);

  //Imprime os valores da média
  print('Umidade coleta em $estado por ano:');
  print('Máxima: ${maxUmidade.toStringAsFixed(2)}');
  print('Média: ${mediaUmidade.toStringAsFixed(2)}');
  print('Mínima: ${minUmidade .toStringAsFixed(2)}\n');

}

Future<void> analiseMensalUmidade(String estado) async{
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se as linhas estão vazias
  if (dados.isEmpty) return;

  print('Umidade no estado de $estado por mês:');

  //For para cada mês do ano (1 até 12)
  for(int i = 1; i <= 12; i++){
    final umidade = dados
        .where((dados)=>
          int.tryParse(dados['Mes'].toString()) == i && //Verifica se o Mes convertido para int é igual o mes do loop
          dados['Umidade'] is num) //Garante que a umidade seja numérica
        .map((dados) => dados['Umidade'] as num) //Converte para num
        .toList(); //Converte para lista
    //Verifica se nao retornou vazio
    if (umidade.isEmpty) {
      print('Mês $i: Sem dados.\n');
      continue;
    }

    //Calcula a soma e depois a média retornada no mes
    final soma = umidade.reduce((a , b) => a + b);
    final media = soma/umidade.length;

    //Calcula a máxima e a mínima
    final maxUmidade = umidade.reduce((a, b) => a > b ? a : b);
    final minUmidade = umidade.reduce((a, b) => a < b ? a : b);

    //Imprime os valores da média
    print('No mês $i');
    print('Máxima: ${maxUmidade.toStringAsFixed(2)}');
    print('Média: ${soma.toStringAsFixed(2)}');
    print('Mínima: ${minUmidade.toStringAsFixed(2)}\n');

  }
}