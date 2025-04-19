import 'package:atividade_final_dart/utilidades.dart';
import 'package:yaansi/yaansi.dart';

final buffer = StringBuffer();

//Metodo para chamar os relatorios
Future<void> chamarMetodosUmidade() async {
  try {
    //chamando os metodos e passando o UF como parametro
    await analiseAnualUmidade('SC');
    await analiseAnualUmidade('SP');

    await analiseMensalUmidade('SC');
    await analiseMensalUmidade('SP');

    //Para salvar o relatorio da umidade gerado
    await salvarRelatorio(buffer.toString(), 'UMIDADE');

    buffer.clear(); //Limpando o buffer

    print('Relatório completo salvo com sucesso.\n');
  } catch (e){
    print('Erro ao chamar métodos da umidade: $e');
  }
}

Future<void> analiseAnualUmidade(String estado) async{
  try {
    //Verifica as linhas e as obtem caso valida
    final dados = await obterLinhasValidas(estado);

    //Verifica se está vazia
    if(dados.isEmpty) return;

    //Obtem as umidades
    final umidade = dados
        .where((dados) => dados['Umidade'] is num) //Garante que a umidade seja numérica
        .map((dados) => dados['Umidade'] as num)  //Converte para num
        .toList();
    
    //Verifica se retornou vazia
    if (umidade.isEmpty){
      buffer.writeln('Nenhuma dado de umidade válido encontrado.\n');
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
  } catch (e){
    print('Erro na análise anual de umidade: $e');
  }
}

Future<void> analiseMensalUmidade(String estado) async{
  try {
    //Verifica as linhas e as obtem caso valida
    final dados = await obterLinhasValidas(estado);

    //Verifica se as linhas estão vazias
    if (dados.isEmpty) return;

    buffer.writeln('Umidade no estado de $estado por mês:');
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
        buffer.writeln('Mês $mes: Sem dados.\n');
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
  } catch (e){
    print('Erro na análise mensal de umidade: $e');
  }
}
//Imprimir umidade reunido em um metodo
void imprimirUmidade (String texto, num maxUmidade, num mediaUmidade, num minUmidade){
  // Cria uma String temporária para imprimir
  final trecho = StringBuffer();
  
  trecho.writeln(texto);
  trecho.writeln('Máxima: ${maxUmidade.toStringAsFixed(2)}'.red);
  trecho.writeln('Média: ${mediaUmidade.toStringAsFixed(2)}'.green);
  trecho.writeln('Mínima: ${minUmidade.toStringAsFixed(2)}\n'.blue);

  // Print só do trecho atual
  print(trecho.toString());

  // Acumula no buffer
  buffer.write(trecho.toString());
}