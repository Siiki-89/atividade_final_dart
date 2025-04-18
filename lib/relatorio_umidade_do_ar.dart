import 'package:atividade_final_dart/utilidades.dart';

void main () async {

}

Future<void> analiseAnualUmidade(String estado) async{
  //Verifica as linhas e as obtem caso valida
  final dados = await obterLinhasValidas(estado);

  //Verifica se está vazia
  if(dados.isEmpty) return;

  //Obtem as umidades
  final umidade = dados
      .where((dados)=> dados['Umidade'] is num)
      .map((dados)=> dados['Umidade'] as num)
      .toList();
  
  //Verifica se retornou vazia
  if (umidade.isEmpty){
    print('Nenhuma dado de umidade válido encontrado.');
  }
}