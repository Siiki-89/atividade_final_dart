import 'package:atividade_final_dart/utilidades.dart';
import 'package:yaansi/yaansi.dart';


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
  String texto = 'Umidade coletada em $estado por ano:';
  imprimirUmidade(texto, maxUmidade, mediaUmidade, minUmidade);

}

Future<void> analiseMensalUmidade(String estado) async{
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se as linhas estão vazias
  if (dados.isEmpty) return;

  print('Umidade no estado de $estado por mês:');

  //For para cada mês do ano (1 até 12)
  for(int mes = 1; mes <= 12; mes++){
    final umidade = dados
        .where((dados)=>
          int.tryParse(dados['Mes'].toString()) == mes && //Verifica se o Mes convertido para int é igual o mes do loop
          dados['Umidade'] is num) //Garante que a umidade seja numérica
        .map((dados) => dados['Umidade'] as num) //Converte para num
        .toList(); //Converte para lista
    //Verifica se nao retornou vazio
    if (umidade.isEmpty) {
      print('Mês $mes: Sem dados.\n');
      continue;
    }

    //Calcula a soma e depois a média retornada no mes
    final soma = umidade.reduce((a , b) => a + b);
    final mediaUmidade = soma/umidade.length;

    //Calcula a máxima e a mínima
    final maxUmidade = umidade.reduce((a, b) => a > b ? a : b);
    final minUmidade = umidade.reduce((a, b) => a < b ? a : b);

    //Imprime os valores da média
    String texto = 'No mês $mes';
    imprimirUmidade(texto, maxUmidade, mediaUmidade, minUmidade);

  }
}
void imprimirUmidade (String texto, num maxUmidade, num mediaUmidade, num minUmidade){
  print(texto);
  print('Máxima: ${maxUmidade.toStringAsFixed(2)}'.red);
  print('Média: ${mediaUmidade.toStringAsFixed(2)}'.green);
  print('Mínima: ${minUmidade .toStringAsFixed(2)}\n'.blue);
}